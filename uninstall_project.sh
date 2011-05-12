#!/usr/bin/env bash

a2_vhosts_path="/etc/apache2/sites-available"
sys_hosts_path="/etc/hosts"
min_params_count=2
max_params_count=2

if [ $# -lt $min_params_count ]; then
  echo "Needs params, like:"
  echo "$0 <project_name> <project_dir>"
  exit 1
elif [ $# -gt $max_params_count ]; then
  echo "Needs params, like:"
  echo "$0 <project_name> <project_dir>"
  exit 2
fi

if [ "root" != `whoami` ]
then
  echo "Needs root premissions!"
  exit 3
fi

project_name=$1
project_dir=$2

sed -i "/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*[ \t]*$project_name/d" "$sys_hosts_path"
sudo a2dissite $project_name

sudo rm -rf $project_dir "$a2_vhosts_path"/"$project_name"
