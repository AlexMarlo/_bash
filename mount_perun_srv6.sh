#!/bin/bash
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



echo -
echo -e ${c_green}Mount perun: /var/www/localhost/htdocs to /home/xanm/Documents/perun_www${c_std}
echo -
fusermount -u /home/xanm/Documents/perun_www
mkdir /home/xanm/Documents/perun_www
sshfs bit@perun.bit:/var/www/localhost/htdocs /home/xanm/Documents/perun_www

echo -
echo -e ${c_green}Mount srv6: /www to /home/xanm/Documents/srv6_www${c_std}
echo -
fusermount -u /home/xanm/Documents/srv6_www
mkdir /home/xanm/Documents/srv6_www
sshfs bit@srv6.0x00.ru:/www /home/xanm/Documents/srv6_www
