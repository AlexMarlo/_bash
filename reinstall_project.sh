#!/usr/bin/env bash

min_params_count="3"
max_params_count="4"
limb_version="3"

if [ $# -lt $min_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <project_name> <sour_rep> <dest_dir>  [limb_version]"
  exit 1
elif [ $# -gt $max_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <project_name> <sour_rep> <dest_dir> [limb_version]"
  exit 2
fi

if [ $# -eq 4 ]; then
  if [ "$4" -eq 1 ]; then
    limb_version=$4
  elif [ "$4" -eq 2 ]; then
    limb_version=$4
  fi
fi

if [ "root" != `whoami` ]
then
  echo "Needs root premissions!"
  exit 3
fi

project_name=$1
sour_rep=$2
dest_dir=$3


sudo ./uninstall_project.sh $project_name $sour_rep $dest_dir $limb_version
sudo ./install_project.sh $project_name $dest_dir/$project_name

