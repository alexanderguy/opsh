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

testing::run
