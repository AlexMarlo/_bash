#!/usr/bin/env bash

tmp_file="/tmp/tmp_install_project"
min_params_count="1"
max_params_count="1"

if [ $# -lt $min_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <project_dir>"
  exit 1
elif [ $# -gt $max_params_count ]
then
  echo "Needs params, like:"
  echo "$0 <project_dir>"
  exit 2
fi

project_dir=$1

rm $tmp_file
svn pg svn:externals $project_dir/lib/limb/ | sed -e 's/svn:\/\/svn\.bit/http:\/\/ioffice\.bit-creative\.com\:8666\/svn\/webdev/' > $tmp_file
svn ps svn:externals -F $tmp_file $project_dir/lib/limb


if [ -d $project_dir/lib/bit-cms ]
then
bitcms_dir="bit-cms"
elif [ -d $project_dir/lib/bitcms ]
then
bitcms_dir="bitcms"
fi
#~ http://ioffice.bit-creative.com:8666/svn/webdev/
svn pg svn:externals $project_dir/lib/$bitcms_dir/ | sed -e 's/svn:\/\/svn\.bit/http:\/\/ioffice\.bit-creative\.com\:8666\/svn\/webdev/' > $tmp_file
svn ps svn:externals -F $tmp_file $project_dir/lib/$bitcms_dir

svn up $project_dir/lib/limb/
svn up $project_dir/lib/$bitcms_dir/

svn revert $dest_dir/lib/limb/
svn revert $dest_dir/lib/$bitcms_dir/
#*********************************
