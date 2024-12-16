ifdef CMD
	CMD_TEST=${CMD}
	CMD_LOCAL=${CMD}
else
	CMD_TEST=./test.sh
	CMD_LOCAL=./entrypoint.sh
endif

V_TEST="$(PWD)/test:/opt/test"
V_STARTUP="$(PWD)/startup:/opt/startup"
V_BASH_TEST="$(PWD)/bash-test:/opt/bash-test"

.PHONY: build config test run start stop

build:
	@docker build --no-cache -t devops/ldap:test .

config:
	@docker run -it --rm \
	-v "${V_CACHE}" \
	-v "${V_STARTUP}" \
	devops/ldap:test "/opt/startup/config.sh"

test:
	@docker run -t --rm \
	-v "${V_TEST}" \
	-v "${V_STARTUP}" \
	-v "${V_BASH_TEST}" \
	--workdir /opt/test \
	devops/ldap:test "${CMD_TEST}"

run:
	@docker run -it --rm \
	--name ldap-test \
	-v "${V_CACHE}" \
	-v "${V_STARTUP}" \
	devops/ldap:test

start:
	@docker run -d --rm \
	--name ldap-test \
	-v "${V_CACHE}" \
	-v "${V_STARTUP}" \
	devops/ldap:test

stop:
	@docker stop ldap-test
