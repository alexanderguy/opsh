#!/usr/bin/env opsh

lib::import test-harness

source "$SCRIPTDIR/utils.opsh"

basic-opsh-invocation() {
    invoke-and-check-output "$SCRIPTDIR/10-test_invocation/simple-output" 3 2 1 go <<EOF
t/10-test_invocation/simple-output
Hey, You, Guys!
3
2
1
go
EOF
}

testing::register basic-opsh-invocation "do some basic checks that args are passed in"

check-exit-triggers() {
    invoke-and-check-output "$SCRIPTDIR/10-test_invocation/exit-trigger" <<EOF
B
C
A
EOF
}

testing::register check-exit-triggers "verify that the exit triggers run properly"

check-required-version() {
    if $SCRIPTDIR/10-test_invocation/impossible-version-require; then
        testing::fail "this version requirement should have failed"
    fi

    opsh::version::require 0.0.0 || testing::fail
}

testing::register check-required-version "test that version requirements work"

testing::run
