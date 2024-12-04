#!/bin/bash
set -e

_bash_test_section(){
  echo "*** $(eval "echo \"$1\"") ***"
}

_bash_test_result(){
  echo "$1 $(eval "echo \"$2\"")"
}

_bash_test_line(){
  local ls_prefix2=${1:0:2}
  if [ "$ls_prefix2" == "@ " ]; then
    _bash_test_section "${1:2}"
  elif [ "$ls_prefix2" == "+ " ]; then
    TEST_DESCRIPTION="${1:2}"
  elif [[ ! ( -z "$1"  || "${1:0:1}" == "#" )  ]]; then
    if [[ -z "$line" ]]; then
      echo "";
    elif  eval "$1" > /dev/null; then
      _bash_test_result "OK   " "${TEST_DESCRIPTION}"
    else
      _bash_test_result "ERROR" "${TEST_DESCRIPTION}"
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
