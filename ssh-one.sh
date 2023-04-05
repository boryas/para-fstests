#! /bin/bash

. functions.sh

vm=$1
tst=$2
cmd="cd $FSTESTS_DIR; sudo ./check $tst | grep -e 'Ran:' -e 'Failures:' -e 'Not run:'"
DATE="date +%H:%M:%S"

dbg "ssh-work.sh cmd: $cmd"

res=$(ssh $vm $cmd)

log "$vm: $tst: $res"
