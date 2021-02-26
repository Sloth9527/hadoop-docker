#/bin/bash

cmd="hdfs dfs -"

if test -z $0;
  then
    cmd="${cmd}-help"
  else
    cmd="${cmd}${@}"
fi

echo $cmd

docker exec -it hadoop-master bash -c "${cmd}"
