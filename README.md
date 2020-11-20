# parallel fstests

Linux file systems can be tested with fstests.
(https://github.com/kdave/xfstests)

Unfortunately, the full suite of tests can take some time to run. On my test
setup, the testlist '-g auto' takes roughly 3 hours to run. This script creates
a simple bash work queue to distribute the hundreds of tests across a set of
inputted machines over ssh. Each test is assigned to the next available worker,
which handles the heterogeneous duration of the tests reasonably well and keeps
the workers busy. With three workers, I can run it in ~1 hour, which suggests
we do get decent parallelism.

## Example
`./para-fstests.sh -t '-g auto' worker1 worker2 worker3`

will run the same tests as `./check -g auto` but across the three workers.
The script assumes a working fstests directory (with the same name) on all the
workers, and takes the same testlist format (via -t) as plain xfstests.

## Configuration
There are two environment variables that configure the execution:
`FST_DEBUG=y` will enable debug logging
`FST_DIR=foo` will set the directory we cd to in the worker host to foo
