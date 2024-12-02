CMD?=./entrypoint.sh

build_and_run: build run

build:
	docker build --no-cache -t devops/ldap:test .

run:
	docker run -it --rm devops/ldap:test

start:
	docker run -it --rm devops/ldap:test "./start.sh"

config:
	docker run -it --rm devops/ldap:test "./config.sh"

local:
	docker run -it --rm -v "$(PWD)/start:/openldap/start" devops/ldap:test "${CMD}"

bash:
	docker run -it --rm --entrypoint /bin/bash devops/ldap:test

test_config:
	docker run -it --rm \
	-v "$(PWD)/start:/openldap/start" \
	-v "$(PWD)/test/test_config.sh:/openldap/start/test_config.sh" \
	devops/ldap:test "./test_config.sh"
