#!/bin/bash

# Create a test directory
#   /tmp/ocaml-inotify-test/tests/RAND
# And a log file
#   /tmp/ocaml-inotify-test/logs/RAND.log
# Add and remove files from the test directory
# and make sure the changes appear in the log.

set -u -e -o pipefail

here=$(dirname $0)

rand=$RANDOM
basedir=/tmp/ocaml-inotify-test
testdir=$basedir/tests/$rand
logdir=$basedir/logs
logfile=$logdir/$rand.log

echo "Running in dir $testdir (log in $logfile)"

mkdir -p $testdir $logdir

($here/test-inotify $testdir > $logfile)&

# Give test-inotify a chance to start watching the directory
sleep 1

# Kill the watcher on exit
test_pid=$!
trap "kill $test_pid" EXIT

# Create some files
touch $testdir/{a,b,c}

# Make sure there are 3 create lines
if (( $(cat $logfile | grep CREATE | wc -l) == 3 )); then
  echo "PASSED"
  exit 0
else
  echo "FAILED:  Expected 3 create lines.  Found "
  cat $logfile
  exit 1
fi
