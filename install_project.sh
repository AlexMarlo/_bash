#!/usr/bin/env bash

tmp_file="/tmp/tmp_install_project"
a2_vhosts_path="/etc/apache2/sites-available"
sys_hosts_path="/etc/hosts"
user="xanm"
group="xanm"
min_params_count="3"
max_params_count="4"
limb_version="3"

max_ip_n1="127"
max_ip_n2="0"
max_ip_n3="0"
max_ip_n4="1"

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

if [ $limb_version -eq 3 ]; then
cat > $a2_vhosts_path/$project_name << EOF
<VirtualHost $max_host_ip:80>
  RewriteEngine on 
  ServerAdmin admin@localhost
  DocumentRoot \${DEFAULT_PROJECTS_PATH}$project_name/www
  ServerName $project_name
  ServerAlias $project_name

  ErrorLog \${DEFAULT_PROJECTS_PATH}apache_errors.log
  CustomLog \${DEFAULT_PROJECTS_PATH}access.log combined

  Alias /shared/wysiwyg \${DEFAULT_PROJECTS_PATH}$project_name/lib/limb/wysiwyg/shared
  Alias /shared/js \${DEFAULT_PROJECTS_PATH}$project_name/lib/limb/js/shared
  Alias /shared/calendar \${DEFAULT_PROJECTS_PATH}$project_name/lib/limb/calendar/shared
  Alias /shared/base \${DEFAULT_PROJECTS_PATH}$project_name/lib/bitcms/base/shared
  Alias /shared/cms \${DEFAULT_PROJECTS_PATH}$project_name/lib/limb/cms/shared
</VirtualHost>
EOF
elif [ $limb_version -eq 2 ]; then
cat > $a2_vhosts_path/$project_name << EOF
<VirtualHost $max_host_ip:80>
  RewriteEngine on 
  ServerAdmin admin@localhost
  DocumentRoot \${DEFAULT_PROJECTS_PATH}$project_name
  ServerName $project_name
  ServerAlias $project_name

  ErrorLog \${DEFAULT_PROJECTS_PATH}apache_errors.log
  CustomLog \${DEFAULT_PROJECTS_PATH}access.log combined

  Alias /shared \${DEFAULT_PROJECTS_PATH}$project_name/external/limb/shared
</VirtualHost>
EOF
elif [ $limb_version -eq 1 ]; then
cat > $a2_vhosts_path/$project_name << EOF
<VirtualHost $max_host_ip:80>
  RewriteEngine on 
  ServerAdmin admin@localhost
  DocumentRoot \${DEFAULT_PROJECTS_PATH}$project_name
  ServerName $project_name
  ServerAlias $project_name

  ErrorLog \${DEFAULT_PROJECTS_PATH}apache_errors.log
  CustomLog \${DEFAULT_PROJECTS_PATH}access.log combined

  Alias /shared \${DEFAULT_PROJECTS_PATH}$project_name/external/limb/shared
</VirtualHost>
EOF
fi

sudo a2ensite $project_name
sudo /etc/init.d/apache2 restart
echo "Host created!"

echo "install project from repo"

mkdir $dest_dir/$project_name

if [ "svn" = `expr match "$sour_rep" '.*\(svn\).*'` ]; then
  svn checkout $sour_rep $dest_dir/$project_name
elif [ "git" = `expr match "$sour_rep" '.*\(git\).*'` ]; then
  git clone $sour_rep $dest_dir/$project_name
  php $sour_rep $dest_dir/$project_name/cli/export_externals.php
fi

sudo mkdir $dest_dir/$project_name/var

sudo chown -R $user:$group $dest_dir/$project_name
if [ $limb_version -eq 3 ]; then
echo "x"
elif [ $limb_version -eq 2 ]; then
cat > $dest_dir/$project_name/setup.override.php << EOF
<?php
define('DB_DSN', 'mysql://root:test@localhost/$project_name?charset=utf8');
EOF
elif [ $limb_version -eq 1 ]; then
cat > $dest_dir/$project_name/setup.override.php  << EOF
<?php
define('DB_DSN', 'mysql://root:test@localhost/$project_name?charset=utf8');
EOF
fi


sudo chmod 777 $dest_dir/$project_name/var

php $dest_dir/$project_name/cli/load.php
#su -c "firefox $project_name" $user
#su -c "firefox $project_name/admin" $user
