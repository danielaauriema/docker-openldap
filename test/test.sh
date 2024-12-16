#!/bin/bash
set -e

BASH_TEST="/opt/bash-test/bash-test.sh"

if [ ! -f "${BASH_TEST}" ]; then
  curl -s "https://raw.githubusercontent.com/danielaauriema/bash-tools/master/lib/bash-test.sh" > "${BASH_TEST}"
  chmod ugo+rx "${BASH_TEST}"
fi
. "${BASH_TEST}"

bash_test "/opt/test/test-config.sh"