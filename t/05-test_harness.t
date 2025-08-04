#!/usr/bin/env opsh

lib::import test-harness

source "$SCRIPTDIR/utils.opsh"

check-unknown-commands-fail() {
    invoke-and-check-output "$SCRIPTDIR/05-test_harness/command-not-found" <<EOF
TAP version 13
1..1
not ok 1 - we should fail
# t/05-test_harness/command-not-found: line 7: xxxxthisdoesnotexistasacommand: command not found
EOF
}

testing::register check-unknown-commands-fail "verify that unknown commands inside tests cause a failure"

check-explicit-fail() {
    invoke-and-check-output "$SCRIPTDIR/05-test_harness/explicit-fail" <<EOF
TAP version 13
1..5
not ok 1 - make sure explicit fail works
# FATAL:	t/05-test_harness/explicit-fail:6 inside explicit-fail: explicit error
not ok 2 - make sure explicit fail works after an error
# FATAL:	t/05-test_harness/explicit-fail:13 inside error-and-explicit-fail: explicit fail after error should work
not ok 3 - make sure we fail correctly on an and
# FATAL:	t/05-test_harness/explicit-fail:20 inside true-should-fail: this should fail after true
not ok 4 - make sure we exit on false in an and statement
ok 5 - we should be able to catch the return value
# INFO:	ret should = 1: 1
EOF
}

testing::register check-explicit-fail "verify that explicit failures work properly"

testing::run
