#!/usr/bin/env bash

if [ $# -eq 0 ]
then
  svn status | grep -v "^$" | sed -e "/limb/d"
  exit 0
elif [ $# -gt 1 ]
then
  echo "Too many params!"
  exit 1
fi

svn status $1 | grep -v "^$" | sed -e "/limb/d"

