#!/bin/bash -x


EPOC=`perl -e 'print int(time)' 2>/dev/null` ; test "X${EPOC}" = "X" && exit 4
SELF="$0" ; test "X${SELF}" = "X" && exit 2
DIR=`dirname ${SELF}`
BASE=`basename ${SELF}`


cd ${DIR}/repos || exit 9
COMMENTS=`for i in * ; do
  cd ${i}
  RANGE=\`git pull origin master|grep "^Updating "|awk {'print $2'}\`
  test "X${RANGE}" != "X" && {
    git log  --format=%s  --author=sstecker  ${RANGE}
    }
  cd ..
  done | sort -u | grep '.'`

cd ..
mkdir -p MESGS/
test "X${COMMENTS}" != "X" &&  echo "${COMMENTS}"  > MESGS/${EPOC}


