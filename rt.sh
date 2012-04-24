
#!/usr/bin/env bash
progress=1


while true; do
  if [ $progress -eq 1 ]; then
    echo "  \\"
  fi

  if [ $progress -eq 2 ]; then
    echo "  |"
  fi

  if [ $progress -eq 3 ]; then
    echo "  /"
  fi

  if [ $progress -eq 4 ]; then
    echo "  -"
    progress=0
  fi


  progress=$[$progress+1]
  if_list=`netstat -i | awk '{ if( index($0, "Kernel") == 0 &&  index($0, "Iface") == 0 && index($0, "lo") == 0) {i = index($0, "\t"); print substr($0,1,5);}}'`

  for if in $if_list; do
    echo -ne "$if: "
    ifconfig $if | grep "inet addr:" | awk '{ i = index($0, "inet addr:"); i+=10; ip = substr($0,i,length($0) - i); i = index( ip, " "); print substr(ip,1,i); }'
  done 
  
  echo

  route -n
  sleep 1
  clear
done
