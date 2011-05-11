#!/usr/bin/env bash

tmp_file="/tmp/tmp_svn_authors"

if [ $# -lt "2" ]
then
  echo "Too few params!"
  exit 1
elif [ $# -gt "2" ]
then
  echo "Too many params!"
  exit 2
fi

svn_dir=$1
author_emails=$2


rm $tmp_file
`svn log $svn_dir -q | grep -e '^r' | awk 'BEGIN { FS = "|" } ; { print $2 }' | sort | uniq >> $tmp_file`

while read author
do
  email="EMAIL"
  if [ "$author" = '(no author)' ]; then
    author='unknown'
  else
    while read auth_email
    do
      a=`expr match "$auth_email" '\([^<>]*\)[ \t]<'`
      if [ "$author" = "$a" ]; then
        email=`expr match "$auth_email" '.*<\([^<>]*\)>'`
      fi
    done < "$author_emails"
  fi

  echo "${author} = ${author} <${email}>"
done < "$tmp_file"
