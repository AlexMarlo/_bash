#! /bin/env bach

min_params_count="5"
max_params_count="5"
example_cli="$0 <login> <pass> <ftp remote dir> <remote dir> <local dir>"

if [ $# -lt $min_params_count ]
then
  echo "Needs params, like:"
  echo $example_cli 
  exit 1
elif [ $# -gt $max_params_count ]
then
  echo "Needs params, like:"
  echo $example_cli
  exit 2
fi

login=$1
pass=$2
ftp_remote_domain=$3
remote_dir=$4
local_dir=$5

lftp 'mirror -R $local_dir $remote_dir; bye;' -u $login,$pass $ftp_remote_domain
#lftp -p 21 -u $login,$pass $ftp_remote_domain/$remote_dir << cmd
#mirror -R -c -v --log=/var/log/lftp.log $local_dir
#quit
