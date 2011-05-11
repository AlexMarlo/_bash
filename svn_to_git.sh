#!/usr/bin/env bash
# Переменные с именами цветов
c_std="\E[0;39m"
c_h_std="\E[1;37m"
c_pink="\E[0;35m"
c_h_pink="\E[1;35m"
c_red="\E[0;31m"
c_h_red="\E[1;31m"
c_cayan="\E[0;36m"
c_h_cayan="\E[1;36m"
c_yellow="\E[1;33m"
c_green="\E[0;32m"
c_h_green="\E[1;32m"
c_blue="\E[0;34m"
c_h_blue="\E[1;34m"

#~ echo -e ${c_h_cayan}Это непонятный \:\) цвет${c_std}
#~ echo -e ${c_h_red}Это красный цвет${c_std}
#~ echo -e ${c_yellow}Это жёлтый цвет${c_std}
#~ echo -e ${c_green}Это зелёный цвет${c_std}
#~ echo -e ${c_blue}Это голубой цвет${c_std}

if [ $# -lt "3" ]
then
  echo -e ${c_h_red}Too few params!${c_std}
  exit 1
elif [ $# -gt "3" ]
then
  echo -e ${c_h_red}Too many params!${c_std}
  exit 2
fi

svn_repo=$1
git_repo=$2
author_emails=$3


echo -
echo -e ${c_green}Start SVN to GIT${c_std}
echo -

rm /tmp/svn-authors
rm -rf $git_repo/* $git_repo/.git

/home/xanm/Documents/bash_scripts/get_svn_authors.sh $svn_repo $author_emails >> /tmp/svn-authors

cd $git_repo
git svn clone -s --authors-file=/tmp/svn-authors $svn_repo .

git fetch . refs/remotes/*:refs/heads/*


git checkout branch 
git svn create-ignore
git commit -a -m "-- SVN to GIT: imported svn:ignore"


for branch in `git branch -r`; do git branch -rd $branch; done
git branch -d trunk


git config --remove-section svn-remote.svn
rm -Rf .git/svn/

echo -
echo -e ${c_green}GIT repo created!${c_std}
echo -
