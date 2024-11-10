#!/usr/bin/env opsh

lib::import test-harness

source "$SCRIPTDIR/utils.opsh"

PATH="$SCRIPTDIR/50-cloud_init:$PATH"

lib::import cloud-init

verify-the-basics() {
    cloud-init::is-enabled || testing::fail "cloud-init should come back as enabled, but isn't"
}

testing::register verify-the-basics "make sure our mock cloud-init environment is exposed"

verify-status-results() {
    eval-and-check-status 0 '( _OPSH_MOCK_CLOUD_INIT_STATUS=0 cloud-init::wait-for-finish )'
    eval-and-check-status 1 '( _OPSH_MOCK_CLOUD_INIT_STATUS=1 cloud-init::wait-for-finish )'
    eval-and-check-status 0 '( _OPSH_MOCK_CLOUD_INIT_STATUS=2 cloud-init::wait-for-finish )'
}

testing::register verify-status-results "double check that we react properly on different cloud-init status exit codes"

testing::run
