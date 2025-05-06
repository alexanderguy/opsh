#!/usr/bin/env opsh

lib::import test-harness git

source "$SCRIPTDIR/utils.opsh"

verify-remote-tag-lookup() {
    local hash

    hash=$(git::tag::lookup::remote origin 0.5.1)

    # XXX - This is brittle, but it's a known hash value from a previous release.
    [[ $hash = f9798b9ff4fe4fe84a530a7cabab615baf445431 ]] || test::fail

    eval-and-check-status 1 'git::tag::lookup::remote notreal notatag'
}

testing::register verify-remote-tag-lookup "check if a basic remote tag lookup works"

testing::run
