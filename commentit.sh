#!/bin/bash -x

test "X${__USER}" = "X" -o "X${__PASS}" = "X" -o "X${__TICKET}" = "X" -o "X${__URL}" = "X"  && exit 1


MYBASE=`dirname $0` ; test "X${MYBASE}" = "X" && exit 2
CWD=`pwd` ; test "X${CWD}" = "X" && exit 3
FQBASE=`echo "${MYBASE}"|perl -p -e "s|(^[^/]+)|${CWD}/\1|g"`
test "X${FQBASE}" = "X" && exit 4

cd "${FQBASE}" || exit 5
test "X${*}" = "X" && exit 1
COMMENT="${*}"


PUTCOMMENT=`cat ${FQBASE}/jira.jsons/comments-update.json|perl -p -e "s|\%\%COMMENT\%\%|${COMMENT}|g"|curl   --max-time  30      -s -S -f  --write-out '\n\nHTTPCODE=%{http_code}\n' -D- -u ${__USER}:${__PASS} -X PUT -H "Content-Type: application/json"  \
  ${__URL}/rest/api/2/issue/${__TICKET}  \
  --data @-`

PUTCOMMENTOK=`echo "${PUTCOMMENT}"|grep "^HTTPCODE="|awk -F\= {'print $2'}|awk {'print $1'}|head -1`
  echo "${PUTCOMMENTOK}" | egrep "^20[0-4]$" || exit $?
  

exit 0


