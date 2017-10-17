#!/bin/bash -x


SELF="$0" ; test "X${SELF}" = "X" && exit 2
DIR=`dirname ${SELF}`
BASE=`basename ${SELF}`
cd ${DIR}/ || exit 9
export CWD=`pwd`
##RDY2SND=`find MESGS -type f -mtime +24h`
RDY2SND=`find MESGS -type f`
test "X${RDY2SND}" = "X" && exit 10
####NEWCOMMENTS=`cat MESGS/*|grep -v -i merge|sort -u|grep "[A-Z,a-z,0-9]"`
####test "X${NEWCOMMENTS}" = "X" && exit 10
mkdir -p ./logs.git
test -d ./logs.git/.git || git init logs.git
cat repos/.did/.git/config > ./logs.git/.git/config
ALREADYSENTTODAY=`git --git-dir=logs.git/.git log --format=%s  --author=sstecker  --since=12am`
test "X${ALREADYSENTTODAY}"  != "X" && {
  echo "${ALREADYSENTTODAY}"|while read line ; do
    clean=`echo "${line}"|perl -p -e 's|\@|\\\@|g'|perl -p -e 's|\?|\\\?|g'|perl -p -e 's|\(|\\\(|g'|perl -p -e 's|\)|\\\)|g'|perl -p -e 's#\|#\\\|#g'|perl -p -e 's|\[|\\\[|g'|perl -p -e 's|\]|\\\]|g'|perl -p -e 's|\.|\\\.|g'|perl -p -e 's|\*|\\\*|g'|perl -p -e 's|(\\$)|\\\\\1|g'|perl -p -e 's|\+|\\\+|g'`
    perl -p -i -e "s|^${clean}\n||g"  MESGS/*
    done
  }

##exit
  
NEWCOMMENTS=`cat MESGS/*|grep -v -i merge|sort -u|grep "[A-Z,a-z,0-9]"|egrep "[ \t]OPS-[0-9]+[ \t]*$"`


test "X${NEWCOMMENTS}" != "X" &&  {
  echo "${NEWCOMMENTS}"|while read line ; do
    __TICKET=`echo "${line}" | perl -p -e "s|^.*(OPS-[0-9]+).*?$|\1|g"`
    test "X${__TICKET}" = "X" && continue
    __USER="${__USER}"  __PASS="${__PASS}" __TICKET="${__TICKET}" __URL="${__URL}"  ./commentit.sh `echo "${line}" | perl -p -e "s|${__TICKET}||g"` && {
      __USER="${__USER}"  __PASS="${__PASS}" __TICKET="${__TICKET}" __URL="${__URL}"  ./progressit.sh `echo "${line}" | perl -p -e "s|${__TICKET}||g"`
      clean=`echo "${line}"|perl -p -e 's|\@|\\\@|g'`
      perl -p -i -e "s|^${clean}\n||g"  MESGS/*
      echo "${line}" > logs.git/DIDS
      cd logs.git || exit 19
      git add DIDS
      git commit -m "${line}" DIDS
      cd "${CWD}" || exit 23
      }
    done
  }

cd "${CWD}" || exit 29
EMPTYFILES=`grep  -L  "[A-Z,a-z,0-9]" MESGS/*`

test "X${EMPTYFILES}" != "X" && rm -f ${EMPTYFILES}

