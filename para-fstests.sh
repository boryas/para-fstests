#!/bin/bash

. functions.sh

while getopts ht: opt; do
  case ${opt} in
    h )
      echo "Usage:"
      echo "   para-fstests -t [test] vms"
      exit 0
      ;;
    t )
      TESTLIST=${OPTARG};;
    \?)
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

VMS=("$@")
for vm in ${VMS[@]}
do
  vm_worker $vm
done

get_tests_cmd="cd $FSTESTS_DIR; sudo ./check -n $TESTLIST"
TESTS=$(ssh ${VMS[0]} $get_tests_cmd | grep -E '[a-zA-Z]+/[0-9]+$')

check_vm() {
      dbg "try $vm"
      ssh $vm 'echo hi > /dev/null' || return $?
}

for t in $TESTS
do
  dbg "Assigning test: $t"
  assigned=0
  while [ $assigned -eq 0 ]
  do
    for vm in ${VMS[@]}
    do
      check_vm $vm || continue;
      assign_cmd="echo $t > $vm-fifo"
      flock -n "$vm-lock" -c "$assign_cmd"
      if [ $? -eq 0 ]
      then
        assigned=1
        break
      fi
    done
    sleep 1
  done
done

for vm in ${VMS[@]}
do
  dbg "send DONE to $vm"
  done_cmd="echo DONE > $vm-fifo"
  flock "$vm-lock" -c "$done_cmd"
  dbg "sent DONE to $vm"
done

wait

# clean up
for vm in ${VMS[@]}
do
  tear_down_vm_worker $vm
done
