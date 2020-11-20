#! /bin/bash

. functions.sh

vm=$1
tst=$2

dbg "worker $vm read $tst. flocking"
work_cmd="./ssh-one.sh $vm $tst"
flock "$vm-lock" -c "$work_cmd"
dbg "worker $vm released flock"
