FSTESTS_DIR="${FST_DIR-fstests}"
DEBUG="${FST_DEBUG-n}"

DATE_CMD="date +%H:%M:%S"

log () {
  echo $($DATE_CMD) $BASHPID $(basename "$0") $@
}

dbg() {
  if [ $DEBUG = "y" ]
  then
    log $@
  fi
}

worker() {
  file=$1
  work=$2

  log "start worker: $file, $work"

  while (true)
  do
    if read t
    then
      if [ "$t" = "DONE" ]
      then
        break
      else
        $work $t
      fi
    fi
  done < $file
}

vm_worker() {
  vm=$1
  rm "$vm-fifo" > /dev/null 2>&1
  mkfifo "$vm-fifo"
  touch "$vm-lock"
  (worker $vm-fifo "./vm-work.sh $vm")&
}

tear_down_vm_worker() {
  vm=$1
  rm "$vm-fifo" > /dev/null 2>&1
  rm "$vm-lock" > /dev/null 2>&1
}
