#!/usr/bin/env bash

a2_vhosts_path="/etc/apache2/sites-available"
sys_hosts_path="/etc/hosts"
user="xanm"
group="xanm"
min_params_count="2"
max_params_count="2"

max_ip_n1="127"
max_ip_n2="0"
max_ip_n3="0"
max_ip_n4="1"
 
if [ $# -lt $min_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <project_name> <dest_dir>"
  exit 1
elif [ $# -gt $max_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <project_name> <dest_dir>"
  exit 2
fi


if [ "root" != `whoami` ]
then
  echo "Needs root premissions!"
  exit 3
fi

project_name=$1
project_dir=$2

echo "Install host name!"
while read host
do
  ip=`expr match "$host" '\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)[ \t]*[^ \t]*'`
  host_name=`expr match "$host" '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*[ \t]*\([^ \t]*\)'`
  if [ "$host_name" = "$project_name" ]; then
    echo "Host name already exists in <$sys_hosts_path>"
    exit 4
  fi

  if [ "$ip" != "" ]; then
    ip_n1=`expr match "$host" '\([0-9]*\)\.[0-9]*\.[0-9]*\.[0-9]*[ \t]*[^ \t]*'`
    ip_n2=`expr match "$host" '[0-9]*\.\([0-9]*\)\.[0-9]*\.[0-9]*[ \t]*[^ \t]*'`
    ip_n3=`expr match "$host" '[0-9]*\.[0-9]*\.\([0-9]*\)\.[0-9]*[ \t]*[^ \t]*'`
    ip_n4=`expr match "$host" '[0-9]*\.[0-9]*\.[0-9]*\.\([0-9]*\)[ \t]*[^ \t]*'`

    if [ $ip_n1 -gt $max_ip_n1 ] ; then
      max_ip_n1=$ip_n1
      max_ip_n2=$ip_n2
      max_ip_n3=$ip_n3
      max_ip_n4=$ip_n4
    elif [ $ip_n1 -eq $max_ip_n1 ] ; then
      if [ $ip_n2 -gt $max_ip_n2 ] ; then
        max_ip_n1=$ip_n1
        max_ip_n2=$ip_n2
        max_ip_n3=$ip_n3
        max_ip_n4=$ip_n4
      elif [ $ip_n2 -eq $max_ip_n2 ] ; then
        if [ $ip_n3 -gt $max_ip_n3 ] ; then
          max_ip_n1=$ip_n1
          max_ip_n2=$ip_n2
          max_ip_n3=$ip_n3
          max_ip_n4=$ip_n4
        elif [ $ip_n3 -eq $max_ip_n3 ] ; then
          if [ $ip_n4 -gt $max_ip_n4 ] ; then
            max_ip_n1=$ip_n1
            max_ip_n2=$ip_n2
            max_ip_n3=$ip_n3
            max_ip_n4=$ip_n4
          fi
        fi
      fi
    fi
  fi
done < $sys_hosts_path
let max_ip_n4=$max_ip_n4+1
max_host_ip="$max_ip_n1.$max_ip_n2.$max_ip_n3.$max_ip_n4"

for vhost_file in `ls $a2_vhosts_path`; do
  if [ $vhost_file = $project_name ]; then
    echo "Host file name already exists in <$a2_vhosts_path>"
    exit 5
  fi
done


echo "$max_host_ip $project_name" | sudo tee -a $sys_hosts_path

cat > $a2_vhosts_path/$project_name << EOF
<VirtualHost $max_host_ip:80>
  RewriteEngine on 
  ServerAdmin admin@localhost
  DocumentRoot \${DEFAULT_PROJECTS_PATH}$project_name
  ServerName $project_name
  ServerAlias $project_name

  ErrorLog \${DEFAULT_PROJECTS_PATH}apache_errors.log
  CustomLog \${DEFAULT_PROJECTS_PATH}access.log combined
</VirtualHost>
EOF

mkdir $dest_dir/$project_name

sudo a2ensite $project_name
sudo /etc/init.d/apache2 restart
echo "Host created!"

