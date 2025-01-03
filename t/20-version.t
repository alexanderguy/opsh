#!/usr/bin/env opsh

lib::import test-harness git

verify-git-version() {
    [[ $(opsh::version) = $(git::repo::version) ]] || testing::fail
}

testing::register verify-git-version "check that we return the correct opsh version in a git environment"

testing::run
