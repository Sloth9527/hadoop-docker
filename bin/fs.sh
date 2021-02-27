#/bin/bash

cmd="hadoop fs -"

if test -z $0;
  then
    cmd="${cmd}-help"
  else
    cmd="${cmd}${@}"
fi

echo $cmd

docker exec -it hadoopMaster bash -c "${cmd}"
