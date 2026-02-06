function fldap-search-user () {  #  $1=user.name
  ldapsearch -x \
    -D "${LDAPSEARCH__D}" \
    -b "${LDAPSEARCH__B}" \
    -w "${LDAPSEARCH__W}" \
    -H "ldap://${LDAPSEARCH__H}" \
    -s sub "(&(objectClass=user)(sAMAccountName=$1))"
}

function fldap-search-user-last-pwd-set-date-time () {  #  $1=user.name
local ts=$(fldap-search-user $1 | grep pwdLastSet: | cut -d: -f2- | tr -d ' ' )
python3 - << EOF
import datetime

ft = ${ts}
unix = (ft - 116444736000000000) / 10_000_000

dt = datetime.datetime.fromtimestamp(unix, datetime.UTC)
print(dt)
EOF
}

