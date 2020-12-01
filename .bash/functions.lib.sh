throw_exception() {
  consolelog "Ooops!" "error"
  wtimeout=60
  if [ -f /tmp/tf_cleanup_lock ]; then
    echo "Possible cleanup in progress, waiting ${wtimeout}s before terminating"
    # docker jenkins / docker in docker could not run ps for some reason - inv later
    #while ps -aef | grep 'plan\|apply' | grep ' [t]erraform'; do
    #  if [[ $(date +%s) -ge $wait_timeout ]]; then
    #    echo "ERROR:  Graceful shutdown timed out with forceful exit after waiting $(( $(expr $wait_timeout - $( date +%s) ))s ) where timeout is $wtimeout"
    #    echo "detimeout expired, aborting."
    #    break
    #  fi
    #done
    sleep 60
    echo "Terminating"
    rm -f /tmp/tf_cleanup_lock
  fi
  echo 'Stack trace:' 1>&2

  while caller $((n++)) 1>&2; do :; done;

  exit 1
}

consolelog() {
  local color
  local ts

  # el-cheapo way to detect if timestamp prefix needed
  if [[ ! -z "${JENKINS_HOME}" ]]; then
    ts=''
  else
    ts="[$(date -u +'%Y-%m-%d %H:%M:%S')] "
  fi

  color_reset='\e[0m'

  case "${2}" in
    success )
      color='\e[0;32m'
      ;;
    error )
      color='\e[1;31m'
      ;;
    * )
      color='\e[0;37m'
      ;;
  esac

  if [[ ! -z "${1}" ]] && [[ ! -z "${2}" ]] && [[ "${2}" = "error" ]]; then
    printf "${color}%s%s: %s${color_reset}\n" "${ts}" "${0##*/}" "${1}" >&2
  elif [[ ! -z "${1}" ]]; then
    printf "${color}%s%s: %s${color_reset}\n" "${ts}" "${0##*/}" "${1}"
  fi

  return 0
}

lock_or_wait() {
  local lock_file="${1}"
  if [[ -z ${lock_file} ]]; then
    consolelog "please specify lockfile" "error"
    exit 1
  fi
  if ! command -v flock > /dev/null; then
    consolelog "install flock" "error"
    exit 1
  fi
  exec 200>/var/tmp/${lock_file} || (consolelog "could not create lockfile" "error" && exit 1)
  flock 200 || (consolelog "fail to initialise flock" "error" && exit 1)
}

file_exists() {
  local file_name
  file_name="${1}"

  if [[ -z "${file_name}" ]]; then
    consolelog "ERROR: required var file_name not supplied" "error"
    throw_exception
  fi
  
  if [[ -f "${file_name}" ]]; then
    return 0
  else
    return 1
  fi
}

aws-eks-update-kubeconfig() {
  local reset="\033[0m"
  local red="\033[31m"
  local aws_profile="${1}"
  local aws_region="${2}"
  local cluster_name="${3}"

  if [[ -z "${1}" ]]; then
    echo "${red}usage: aws-eks-update-kubeconfig <venture profile name> <aws region> <cluster name>${reset}"
    return
  fi

  if ! command -v aws > /dev/null; then
    echo -e "${red}install awscli${reset}"
    return
  fi

  aws \
    --profile "${aws_profile}" eks --region "${aws_region}" \
    update-kubeconfig --name "${cluster_name}"
}

aws-eks-venture-kubeconfig() {
  local reset="\033[0m"
  local red="\033[31m"
  local aws_profile="${1}"

  if [[ -z "${1}" ]]; then
    echo "${red}usage: aws-eks-venture-kubeconfig <venture profile name>${reset}"
    return
  fi

  if ! command -v aws > /dev/null; then
    echo -e "${red}install awscli${reset}"
    return
  fi

  mapfile -t clusters < <( aws --profile "${aws_profile}" eks list-clusters | jq -r '.clusters[]' )

  if [[ -z "${clusters[*]}" ]]; then
    consolelog "could not obtain cluster name" "error"
    throw_exception
  fi

  local aws_region
  for cluster_name in "${clusters[@]}"; do
    aws_region=$(aws --profile "${aws_profile}" eks describe-cluster --name "${cluster_name}" | jq -r '.cluster.arn' | awk -F':' '{print $4}')
    if [[ -z "${aws_region}" ]]; then
      consolelog "could not obtain region name" "error"
      throw_exception
    else
      aws \
        --profile "${aws_profile}" eks --region "${aws_region}" \
        update-kubeconfig --name "${cluster_name}"
      aws_region=""
    fi
  done
}
