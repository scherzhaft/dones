#!/bin/bash -x


SELF="$0" ; test "X${SELF}" = "X" && exit 2
DIR=`dirname ${SELF}`
BASE=`basename ${SELF}`
cd ${DIR}/ || exit 9
RDY2SND=`find MESGS -type f -mtime +24h`
test "X${RDY2SND}" = "X" && exit 10
NEWDONES=`cat MESGS/*|grep -v -i merge|sort -u|grep '.'`
test "X${NEWDONES}" = "X" && exit 10

for i in `echo "${NEWDONES}"` ; do
  ./didit.rb "${i}" && rm ./MESGS/*
  done


