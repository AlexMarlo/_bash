#!/usr/bin/env bash
min_params_count=1
max_params_count=1

if [ $# -lt $min_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <stop/start>"
  exit 1
elif [ $# -gt $max_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <stop/start>"
  exit 2
fi

if [ "root" != `whoami` ]
then
  echo "Needs root premissions!"
  exit 3
fi

sudo service network-manager $1

if [[ $1 == "stop" ]]
then
  if_list=`netstat -i | awk '{ if( index($0, "Kernel") == 0 &&  index($0, "Iface") == 0 && index($0, "lo") == 0) {i = index($0, "\t"); print substr($0,1,5);}}'`

  for if in $if_list; do
    echo down $if
    sudo ifconfig $if down 
  done 
fi  
