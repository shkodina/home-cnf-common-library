function fldap-search-user () {  #  $1=user.name
  ldapsearch -x \
    -D "${LDAPSEARCH__D}" \
    -b "${LDAPSEARCH__B}" \
    -w "${LDAPSEARCH__W}" \
    -H "ldap://${LDAPSEARCH__H}" \
    -s sub "(&(objectClass=user)(sAMAccountName=$1))"
}
