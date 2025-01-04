#!/usr/bin/env opsh

lib::import test-harness

source "$SCRIPTDIR/utils.opsh"

check-word-splitting() {
    local scratch
    scratch=$(temp::file)

    local val temparray
    val="1 2 3 4 5"
    array::split temparray " " $val

    # Make sure word splitting doesn't happen by default.
    true >$scratch
    for i in $val; do
        echo $i >>$scratch
    done

    diff -u - "$scratch" <<EOF || testing::fail
1 2 3 4 5
EOF

    # Verify that the array was assigned properly from the split.
    true >$scratch
    for i in "${temparray[@]}"; do
        echo $i >>$scratch
    done

    diff -u - "$scratch" <<EOF || testing::fail
1
2
3
4
5
EOF

    # Check that we joined the array back properly.
    array::join , "${temparray[@]}" >$scratch
    diff -u - "$scratch" <<EOF || testing::fail
1,2,3,4,5
EOF
}

testing::register check-word-splitting "verify that word splitting is properly handled"

testing::run
