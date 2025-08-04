#!/usr/bin/env opsh

lib::import test-harness path

source "$SCRIPTDIR/utils.opsh"

check-basic-path-removal() {
    local oldpath newdir anothernewdir

    newdir=$SCRIPTDIR/thisdoesnotexist
    anothernewdir=$SCRIPTDIR/thisalsodoesnotexist
    oldpath=$PATH

    path::env::add "$newdir"

    [[ $PATH == $newdir:$oldpath ]]
    path::env::remove "$newdir"
    [[ $PATH == "$oldpath" ]]

    path::env::add "$newdir" "$anothernewdir" "$newdir"

    path::env::remove "$anothernewdir"
    [[ $PATH == $newdir:$newdir:$oldpath ]]
    path::env::remove "$newdir"
    [[ $PATH == "$oldpath" ]]
}

testing::register check-basic-path-removal "make sure basic PATH removal works"

testing::run
