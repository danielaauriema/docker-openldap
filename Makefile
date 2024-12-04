ifdef CMD
	CMD_TEST=${CMD}
	CMD_LOCAL=${CMD}
else
	CMD_TEST=./test.sh
	CMD_LOCAL=./entrypoint.sh
endif

.PHONI: build run start config local ldap-test
build_and_run: build run

build:
	docker build --no-cache -t devops/ldap:test .

run:
	docker run -it --rm devops/ldap:test

start:
	docker run -it --rm devops/ldap:test "./start.sh"

config:
	docker run -it --rm devops/ldap:test "./config.sh"

# usage: make local CMD=/bin/bash
local:
	docker run -it --rm \
	-v "$(PWD)/start:/openldap/start" \
	-v "$(PWD)/test:/openldap/test" \
	-v "$(PWD)/.logs:/openldap/logs" \
	devops/ldap:test "${CMD_LOCAL}"

ldap-test:
	docker run --rm \
	-v "$(PWD)/start:/openldap/start" \
	-v "$(PWD)/test:/openldap/test" \
	-v "$(PWD)/.logs:/openldap/logs" \
	--workdir /openldap/test \
	devops/ldap:test "chmod -R ugo+rwx /openldap && ${CMD_TEST}"
