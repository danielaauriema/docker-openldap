#!/bin/bash
set -e

./config.sh

echo
echo "*** starting tests"

echo
echo "Test organization"
slapcat -F "${LDAP_CONF_PATH}" -b "${LDAP_BASE_DN}" -a "(&(objectClass=organization)(dc=${LDAP_ORGANIZATION}))" | grep "dc: devops-tools" > /dev/null && echo "OK" || false

echo
echo "Test LDAP data path: ${LDAP_DATA_PATH}"
ls "${LDAP_DATA_PATH}" | grep "data.mdb" > /dev/null && echo "OK" || false

echo
echo "Test for memberof module"
slapcat -F "${LDAP_CONF_PATH}" -b "cn=config" -a "(objectClass=olcModuleList)" | grep memberof > /dev/null && echo "OK" || false

echo
echo "Test for refint module"
slapcat -F "${LDAP_CONF_PATH}" -b "cn=config" -a "(objectClass=olcModuleList)" | grep refint > /dev/null && echo "OK" || false

echo
echo "Starting OpenLDAP..."
slapd -h "ldapi:/// ldap:///" -F "${LDAP_CONF_PATH}"
while ! ldapsearch -H "ldapi://" -Y EXTERNAL -b "${LDAP_BASE_DN}" 2>&1; do sleep 0.1; done > /dev/null && echo "OK" || false

echo
echo "Test if bind user can authenticate"
ldapwhoami -H "ldapi://" -D "cn=${LDAP_BIND_USERNAME},${LDAP_BASE_DN}" -w "${LDAP_BIND_PASSWORD}" > /dev/null && echo "OK" || false

echo
echo "Test if default user can authenticate"
ldapwhoami -H "ldapi://" -D "cn=${LDAP_DEFAULT_USERNAME},ou=users,${LDAP_BASE_DN}" -w "${LDAP_DEFAULT_PASSWORD}" > /dev/null && echo "OK" || false

echo
echo "Test if default user is member of admin"
ldapsearch -H "ldapi://" -D "cn=${LDAP_BIND_USERNAME},${LDAP_BASE_DN}" -w "${LDAP_BIND_PASSWORD}" -b "${LDAP_BASE_DN}" \
  "(&(objectClass=posixAccount)(uid=${LDAP_DEFAULT_USERNAME})(memberof=cn=admin,ou=groups,${LDAP_BASE_DN}))" uid | \
  grep "uid: ${LDAP_DEFAULT_USERNAME}" > /dev/null && echo "OK" || false

echo
echo "Stopping OpenLDAP..."
pkill slapd && echo "OK"

echo
echo "*** test_config finished successfully!"