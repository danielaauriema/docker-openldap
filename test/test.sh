#!/bin/bash
set -e

if [ ! -f "./bash-test.sh" ]; then
  curl -s "https://raw.githubusercontent.com/danielaauriema/bash-tools/master/lib/bash-test.sh" > "./bash-test.sh"
  chmod ugo+rwx "./bash-test.sh"
fi

./bash-test.sh ./test-config.sh