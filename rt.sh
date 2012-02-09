
#!/usr/bin/env bash
progress=1

while true
do
  if [ $progress -eq 1 ]
  then
    echo "  \\"
  fi

  if [ $progress -eq 2 ]
  then
    echo "  |"
  fi

  if [ $progress -eq 3 ]
  then
    echo "  /"
  fi

  if [ $progress -eq 4 ]
  then
    echo "  -"
    progress=0
  fi

  progress=$[$progress+1]

  route -n
  sleep 1
  clear
done
