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

min_params_count=1
max_params_count=2

work_file="/tmp/count_farsd_traffic"

self_mac=""
bcast_mac="FF:FF:FF:FF:FF:FF"

if [ "root" != `whoami` ]
then
  echo "Needs root premissions!"
  exit 1
fi

if [ $# -gt $max_params_count ]
then
  echo "1Needs params, like:"
  echo "$0 <if_name> dump/count"
  exit 2
elif [ $# -lt $min_params_count ]
then
  echo "2Needs params, like:"
  echo "$0 <if_name> dump/count"
  exit 2
fi

if [ $# -eq $max_params_count ]
then
	if [[ $2 != "dump" && $2 != "count" ]]
	then
	  echo "3Needs params, like:"
	  echo "$0 <if_name> dump/count"
	  exit 2
	fi
fi

self_mac=`ifconfig | grep $1 | awk '{ i = index($0, "HWaddr "); i+=7; print substr($0,i,length($0) - i);}'
`
echo self mac: $self_mac

echo -e ${c_h_blue}FOR EXIT USE ONLY:${c_std} ${c_green}Ctrl+C${c_std}   ${c_h_blue}DO NO USE:${c_std} ${c_h_red}Ctrl+Z${c_std}

if [[ $# -eq $min_params_count || $2 != "count" ]]
then
	sudo rm -rf $work_file
fi


if [[ $# -eq $min_params_count || $2 == "dump" ]]
then
	sudo tcpdump -i $1 ether proto 0x7777 and ether src $self_mac -w $work_file
fi

if [[ $# -eq $min_params_count || $2 == "count" ]]
then
	if [ ! -e $work_file ]
	then
		echo "Needs start with dump param first!"
		exit 3
	fi

	sudo tcpdump -r $work_file | awk '
	{
		if (match($0, /[.]*length[ \t][1-9]*/))
		{
			where = match($0, /[.]*length[ \t]([1-9])*/);
			size = substr($0, where + 7, length($0) - where - 8);
	
			if( 0+size > 0+max)
				max = size;
	
			sum +=size; count += 1;
		}
	}
	END{
		print("");
		print("");
		print("Out traffic statistic:");
		printf( "Traffic: %i bytes\n", sum);
		printf( "Max packet size: %i bytes\n", max);
		if( count+0 != 0)
			avr = (sum+0) / count;
		else
			avr = 0;
		printf( "Avrage packet size: %i bytes\n", avr);
		printf( "Packats count: %i\n", count);
	}'
fi
