ifdef CMD
	CMD_TEST=${CMD}
else
	CMD_TEST=chmod -R +x /opt/test && /opt/test/test.sh
endif

V_TEST="$(PWD)/test:/opt/test"
V_STARTUP="$(PWD)/startup:/opt/startup"

.PHONY: build config test ci-test run start stop

build:
	@docker build --no-cache -t devops/ldap:test .

config:
	@docker run -it --rm \
	-v "$(V_STARTUP)" \
	devops/ldap:test "/opt/startup/config.sh"

test:
	@docker run -it --rm \
	-v "$(V_TEST)" \
	-v "$(V_STARTUP)" \
	devops/ldap:test "$(CMD_TEST)"

ci-test:
	@docker run --rm \
	-v "${RUNNER_WORKSPACE}/openldap/test:/opt/test" \
	devops/ldap:test "$(CMD_TEST)"

run:
	@docker run -it --rm \
	--name ldap-test \
	-v "$(V_STARTUP)" \
	devops/ldap:test

start:
	@docker run -d --rm \
	--name ldap-test \
	-v "$(V_STARTUP)" \
	devops/ldap:test

stop:
	@docker stop ldap-test
