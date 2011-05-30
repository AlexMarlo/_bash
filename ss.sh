#!/usr/bin/env bash

if [ $# -eq 0 ]
then
  svn status | sed "/^$/d;/Performing status on external item at/d;/^X/d"
  exit 0
elif [ $# -gt 1 ]
then
  echo "Too many params!"
  exit 1
fi

svn status $1 | sed "/^$/d;/Performing status on external item at/d;/^X/d"

