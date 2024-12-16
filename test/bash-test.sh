#!/bin/bash
set -e

BASH_TEST_MARGIN=3

bash_test_println(){
  local margin="${2:-$BASH_TEST_MARGIN}"
  if [ "$margin" -gt 0 ]; then
    printf "%${margin}s" " "
  fi
  echo "$1"
}

bash_test_line(){
  local char="$1"
  local length="$2"
  local margin="${3:-$BASH_TEST_MARGIN}"
  local line=""
  for ((i=1; i<=length; i++)); do line+="${char}"; done
  bash_test_println "${line}" "${margin}"
}

bash_test_box(){
  local text="*   $1   *"
  local n=${#text}
  local margin="${2:-$BASH_TEST_MARGIN}"

  bash_test_line "*" "${n}" "${margin}"
  bash_test_println "${text}" "${margin}"
  bash_test_line "*" "${n}" "${margin}"
}

bash_test_header(){
  local text="$1"
  local margin="${2:-1}"
  echo ""
  bash_test_box "$(printf "%-50s" "${text}")" "${margin}"
  echo ""
}

bash_test_result(){
  local status="${1}"
  local text="${2}"
  bash_test_println "$(printf "%-5s %s" "${status}" "${text}")" 4
}

_bash_test_section(){
  echo "*** $1 ***"
}

_bash_test_line(){
  local ls_prefix2=${1:0:2}
  if [ "$ls_prefix2" == "@ " ]; then
    _bash_test_section "${1:2}"
  elif [ "$ls_prefix2" == "+ " ]; then
    TEST_DESCRIPTION="${1:2}"
  elif [ "$ls_prefix2" == "* " ]; then
    eval "${1:2}" > /dev/null
  elif [[ ! ( -z "$1"  || "${1:0:1}" == "#" )  ]]; then
    if eval "$1" > /dev/null; then
      bash_test_result "OK" "${TEST_DESCRIPTION}"
    else
      bash_test_result "ERROR" "${TEST_DESCRIPTION}"
      exit 1
    fi
  fi
}

# bash_test <bash_test_input_file>
bash_test(){
  local test_input_file="$1"
  while read -r line
  do
    _bash_test_line "$line"
  done < "$test_input_file"
  if [[ -n "$line" ]]; then
    _bash_test_line "$line"
  fi
}

if [ -n "$1" ]; then
  bash_test "$1"
fi
