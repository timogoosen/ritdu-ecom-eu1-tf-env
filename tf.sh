#!/usr/bin/env bash

# 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 #
# 💥                                                                        💥 #
# 💥 Do not edit this file as it will be overwritten!                       💥 #
# 💥                                                                        💥 #
# 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 #

readlink_bin="${READLINK_PATH:-readlink}"
if ! "${readlink_bin}" -f test &> /dev/null; then
  __DIR__="$(dirname "$(python3 -c "import os,sys; print(os.path.realpath(os.path.expanduser(sys.argv[1])))" "${0}")")"
else
  __DIR__="$(dirname "$("${readlink_bin}" -f "${0}")")"
fi

source "${__DIR__}/.bash/functions.lib.sh"

set -E
trap 'throw_exception' ERR

cd "${__DIR__}"

# config
kube_env_file="${__DIR__}/.kube-env"
terraform_version="$(<${__DIR__}/.terraform-version)"
aws_profile="rimu"

# envwars
export TF_IN_AUTOMATION="true"

requires_env() {
  if [[ -z "${ENV}" ]]; then
    consolelog "please set ENV" "error"
    exit 1
  fi
}

check_target() {
  if file_exists "${kube_env_file}"; then
    local target
    target="${1}"

    if [[ "${JENKINS_CI}" == "true" ]]; then
      lock_or_wait "kube_context_switch.lock" # only required when deploying to multiple eks clusters via jenkins
    fi

    if [[ "${target}" == "init" ]]; then
      "${__DIR__}/kube.sh" init
      consolelog "initialised kube context" "success"
    fi
  fi
}

check_whoami() {
  if [[ "${JENKINS_CI}" != "true" ]] && [[ "$(id -u)" == "0" ]]; then
    consolelog "do not run as root" "error"
    exit 1
  fi
}

check_terraform() {
  if ! command -v terraform > /dev/null || ! terraform --version | grep -qF "Terraform v${terraform_version}"; then
    # prefer tfenv method
    if command -v tfenv > /dev/null; then
      lock_or_wait "check_terraform.lock" # can remove this when tfenv forces unzip
      tfenv install "${terraform_version}"
      return 0
    fi

    consolelog "installing terraform v${terraform_version}..."
    kernel_name="$(uname -s | tr '[:upper:]' '[:lower:]')"
    zip_file="terraform_${terraform_version}_${kernel_name}_amd64.zip"

    curl -#LO "https://releases.hashicorp.com/terraform/${terraform_version}/${zip_file}"

    if [[ ! -w /usr/local/bin/terraform ]]; then
      sudo touch /usr/local/bin/terraform
      sudo chown "${USER}" /usr/local/bin/terraform
    fi

    unzip -qop "${zip_file}" > /usr/local/bin/terraform
    chmod +x /usr/local/bin/terraform
    rm -f "${zip_file}"
  fi
}

check_provider_aws() {
  if ! command -v aws > /dev/null; then
    sudo -H pip3 install awscli -U
  fi

  if ! aws --profile "${aws_profile}" configure list > /dev/null; then
    aws --profile "${aws_profile}" configure
  fi
}

check_terraecs() {
  if ! command -v terraecs > /dev/null; then
    sudo -H pip3 install terraecs -U
  fi
}

target_upgrade() {
  git clone git@github.com:RingierIMU/tf-common.git tmp_common
  change_profile=0
  if [ -f _providers.tf ]; then
    if grep jenkins_instance_role _providers.tf ; then
      change_profile=1
    fi
  fi

  cp -f tmp_common/*.tf tmp_common/{.gitignore,.terraform-version} ./
  cp -fr tmp_common/.bash ./
  cp -f tmp_common/common/*.tfvars ./common/
  cp -f tmp_common/tf.sh tmp_common/kube.sh ./
  rm -rf tmp_common
  if [ "$change_profile" == "1" ]; then
    echo "Changing the profile back to jenkins_instance_role"
    sed -i "s#id}:role/administrators#id}:role/jenkins_instance_role#g" _providers.tf
  fi

  exit 0
}

target_base() {
  git clone git@github.com:RingierIMU/tf-base.git tmp_base
  cp -f tmp_base/*.tf ./
  cp -f tmp_base/Jenkinsfile.sample ./Jenkinsfile
  rm -rf tmp_base
}

target_env() {
  if [[ -z "${APP_NAME}" ]] || [[ -z "${PREFIX}" ]]; then
    consolelog "please set APP_NAME and PREFIX" "error"
    exit 1
  fi

  git clone git@github.com:RingierIMU/tf-env.git tmp_env
  cp -f tmp_env/*.tf ./
  cp -f tmp_env/Jenkinsfile.sample ./Jenkinsfile

  sed "s/PREFIX/${PREFIX}/g" tmp_env/_remotes.tf.sample > _remotes.tf
  sed "s/APP_NAME/${APP_NAME}/g" tmp_env/variables.tf.sample > variables.tf

  rm -rf tmp_env
}

target_create() {
  if [[ -z "${APP_NAME}" ]] || [[ -z "${PREFIX}" ]]; then
    consolelog "please set APP_NAME, PREFIX and PREFIX_SHORT" "error"
    exit 1
  fi

  sed "s/APP_NAME/${APP_NAME}/g" _backend.tf.sample > _backend.tf

  sed -i.bak "s/PREFIX_SHORT/${PREFIX_SHORT}/g" _backend.tf
  rm -f _backend.tf.bak
  sed -i.bak "s/PREFIX/${PREFIX}/g" _backend.tf
  rm -f _backend.tf.bak

  target_init

  rm _backend.tf.sample

  mkdir -p app
  for workspace in "${@}"; do
    if ! terraform workspace select "${workspace}" 2> /dev/null; then
      terraform workspace new "${workspace}"
      touch "app/${workspace}.tfvars"
    fi
  done

  if [[ "${__DIR__}" == *"/infra" ]]; then
    rm -rf .git
  fi
}

target_init() {
  terraform init -upgrade=true
}

target_validate() {
  requires_env
  
  terraform get
  terraform workspace select "${ENV}"
  terraform fmt -list
  terraform validate
}

target_plan() {
  requires_env

  terraform get
  terraform workspace select "${ENV}"
  # We need to know the PID of the terraform process in order to send a TERM to it.
  # Before: (if plan)
  #
  # jenkins -> TERM -> tf.sh -> starts to kill own children and self -> ERR trapped -> exit 1
  #
  # After: (if plan)
  #
  # jenkins -> TERM -> tf.sh -> TRAP -> LOCK -> SIGTERM PID_OF terraform ->
  # ERR -> waits on lock/timeout -> exit 1
  terraform plan \
    -lock-timeout=600s \
    -var-file="common/${ENV}.tfvars" \
    -var-file="app/${ENV}.tfvars" \
    -out "${ENV}.plan"  &
  echo $! > $TF_PID
  sleep 2
  wait $(cat $TF_PID)
}

target_target() {
  requires_env

  terraform get
  terraform workspace select "${ENV}"
  terraform plan -target "${@}"  \
    -lock-timeout=600s \
    -var-file="common/${ENV}.tfvars" \
    -var-file="app/${ENV}.tfvars" \
    -out "${ENV}.plan"
}

target_show() {
  requires_env

  terraform workspace select "${ENV}"
  terraform show "${ENV}.plan"
}

target_apply() {
  requires_env

  terraform workspace select "${ENV}"
  terraform show "${ENV}.plan"
  terraform apply \
    -lock-timeout=600s \
    "${ENV}.plan"

  rm "${ENV}.plan"
}

target_destroy() {
  requires_env

  terraform workspace select "${ENV}"
  terraform destroy \
    -var-file="common/${ENV}.tfvars" \
    -var-file="app/${ENV}.tfvars"
}

target_state() {
  requires_env

  terraform get
  terraform workspace select "${ENV}"
  terraform state "${@}"
}

target_import() {
  requires_env

  terraform workspace select "${ENV}"
  terraform import \
    -var-file="common/${ENV}.tfvars" \
    -var-file="app/${ENV}.tfvars" \
    "${@}"
}

target_console() {
  requires_env

  terraform get
  terraform workspace select "${ENV}"
  terraform console \
    -var-file="common/${ENV}.tfvars" \
    -var-file="app/${ENV}.tfvars"
}

target_unlock() {
  requires_env

  terraform get
  terraform workspace select "${ENV}"
  terraform force-unlock \
    "${@}"
}

target_runcmd() {
  requires_env
  check_terraecs

  if [[ -z "${REPO_NAME}" ]]; then
    REPO_NAME="$(basename "$PWD")"
    if [[ "${REPO_NAME}" == "infra" ]]; then
      REPO_NAME="$(basename "${PWD%/*}")"
    fi
  fi

  terraform workspace select "${ENV}"
  terraform output "${REPO_NAME//-/_}_cli_ecs_task" -json > output.json

  AWS_PROFILE="${aws_profile}" terraecs -f output.json run "${@}"
}

check_whoami
check_terraform

# we can assume that jenkins is properly configured...
if [[ -z "${JENKINS_CI}" ]] || [[ "${JENKINS_CI}" != "true" ]]; then
  check_provider_aws
fi

target="target_${1}"
if [[ "$(type -t "${target}")" != "function" ]]; then
  consolelog "unknown target: ${target#*_}" "error"

  echo -e "\n\nAvailable targets:"
  targets=( $(compgen -A function) )
  for target in "${targets[@]}"; do
    if [[ "${target}" == "target_"* ]]; then
      echo "- ${target#*_}"
    fi
  done

  exit 1
fi

check_target "${target#*_}"
shift

# Only handle term trap on plan for now while we test.
if [[ "$target" == "target_plan" ]]; then
  trap 'touch /tmp/tf_cleanup_lock; kill $(cat $TF_PID); rm -rf $TF_PID' TERM INT
  TF_PID="$(mktemp)" "${target}" "${@}"
else
  "${target}" "${@}"
fi
