#!/usr/bin/env bash

d=`dirname $0`

min_params_count="1"
max_params_count="2"

if [ $# -lt $min_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <name> [sshf mount path]"
  exit 1
elif [ $# -gt $max_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <name> [sshf mount path]"
  exit 2
fi

name=$1
ssh_conf_path="$d/../.ssh.conf"

while read line
do
  ssh_name=`expr match "$line" '\([^ \#]*\)[ ]*[^ ]*[ ]*[^ ]*[ ]*[^ ]*[ ]*[^ ]*'`
  host=`expr match "$line" '[^ \#]*[ ]*\([^ ]*\)[ ]*[^ ]*[ ]*[^ ]*[ ]*[^ ]*'`
  path=`expr match "$line" '[^ \#]*[ ]*[^ ]*[ ]*\([^ ]*\)[ ]*[^ ]*[ ]*[^ ]*'`
  login=`expr match "$line" '[^ \#]*[ ]*[^ ]*[ ]*[^ ]*[ ]*\([^ ]*\)[ ]*[^ ]*'`
  pass=`expr match "$line" '[^ \#]*[ ]*[^ ]*[ ]*[^ ]*[ ]*[^ ]*[ ]*\([^ ]*\)'`

  if [ "$ssh_name" = "$name" ]; then

    if [ $# -eq 1 ]; then
      echo "ssh $login@$host"
      echo " $path"
      echo " $pass"
    elif [ $# -eq 2 ]; then
      if [ -d $2 ]; then
        echo " $pass"
        sshfs $login@$host:$path $2
      else
        echo "Error $2 not a dir or not exists!"
        exit 1
      fi
    fi

    exit 0
  fi

done < $ssh_conf_path


echo "Not Found!"
