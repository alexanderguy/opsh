#!/usr/bin/env opsh

lib::import test-harness semver

verify-basic-parsing() {
    semver::parse v4.5.6 || testing::fail

    [[ "${OPSH_SEMVER[0]}" -eq 4 ]] || testing::fail
    [[ "${OPSH_SEMVER[1]}" -eq 5 ]] || testing::fail
    [[ "${OPSH_SEMVER[2]}" -eq 6 ]] || testing::fail

    [[ "${#OPSH_SEMVER[@]}" -eq 3 ]] || testing::fail
}

testing::register verify-basic-parsing "make sure we can parse a basic semver"

expr-logical() {
    # eq
    semver::test v4.5.6 -eq 4.5.6 || testing::fail

    if semver::test v1.2.3 -eq 7.8.9; then
        testing::fail
    fi

    if semver::test v1.2.3 -eq 1.2.4; then
        testing::fail
    fi

    # gt
    semver::test v1.2.3 -gt v1.2.1 || testing::fail
    semver::test v3.0.0 -gt v2.9.9 || testing::fail

    if semver::test v1.2.3 -gt v1.2.3; then
        testing::fail
    fi

    if semver::test v1.9.9 -gt v2.0.0; then
        testing::fail
    fi

    # lt
    semver::test v1.2.3 -lt v1.2.4 || testing::fail
    semver::test v2.9.9 -lt v3.0.0 || testing::fail

    if semver::test v1.2.3 -lt v1.2.3; then
        testing::fail
    fi

    if semver::test v3.0.0 -lt v2.9.9; then
        testing::fail
    fi

    # ge
    semver::test v4.5.6 -ge 4.5.6 || testing::fail
    semver::test v4.6.1 -ge 4.5.6 || testing::fail

    if semver::test v1.2.3 -ge 2.3.4; then
        testing::fail
    fi

    # le
    semver::test v0.0.1 -le v0.0.2 || testing::fail
    semver::test 2.2.2 -le 2.2.2 || testing::fail
    semver::test 3.9.9 -le 4.0.0 || testing::fail

    if semver::test v1.2.3 -le v1.2.1; then
        testing::fail
    fi

    if semver::test v1.0.5 -le 0.0.0; then
        testing::fail
    fi

    if semver::test v4.0.0 -le 3.9.9; then
        testing::fail
    fi
}

testing::register expr-logical "check that basic semver expressions logic works"

bad-ver-parsing() {
    for i in .5 badger v4..1 v4.5. v4. sun badger 00.1.2 0.01.2 0.0.02; do
        if semver::parse "$i"; then
            testing::fail "incorrectly parsed '$i'"
        fi
    done
}

testing::register bad-ver-parsing "check to make sure semver parsing fails as expected"

basic-bump() {
    local old new

    old=v1.2.3
    new=$(semver::bump major "$old")

    [[ "$new" = "v2.0.0" ]] || testing::fail
    semver::test "$new" -eq v2.0.0 || testing::fail

    old=V0.0.22
    new=$(semver::bump minor "$old")
    [[ "$new" = "V0.1.0" ]] || testing::fail
    semver::test "$new" -eq v0.1.0 || testing::fail

    old=2.5.9
    new=$(semver::bump patch "$old")
    [[ "$new" = "2.5.10" ]] || testing::fail
    semver::test "$new" -eq v2.5.10 || testing::fail

    if new=$(semver::bump nonsense "6.2.0"); then
        testing::fail
    fi

    [[ -z "$new" ]] || testing::fail
}

testing::register basic-bump "check that bumping semvers works"

testing::run
