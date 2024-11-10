# NOTE: This API is in flux.  It will probably change over time.

_TESTING_REGISTERED_FUNCS=()
_TESTING_REGISTERED_DESC=()

testing::register() {
    local func
    func=$1
    shift

    _TESTING_REGISTERED_FUNCS+=("$func")

    if [[ $# -gt 0 ]]; then
        _TESTING_REGISTERED_DESC+=("$*")
    else
        _TESTING_REGISTERED_DESC+=("")
    fi
}

testing::run() {
    echo "TAP version 13"
    echo "1..${#_TESTING_REGISTERED_FUNCS[@]}"

    local res desc outfile n

    outfile=$(temp::file)

    n=1
    for func in "${_TESTING_REGISTERED_FUNCS[@]}"; do
        res=0
        ("$func") >"$outfile" 2>&1 || res=$?

        if [[ $res -ne 0 ]]; then
            echo -n "not "
        fi

        desc="${_TESTING_REGISTERED_DESC[$((n - 1))]}"

        if [[ -z $desc ]]; then
            echo "ok $n"
        else
            echo "ok $n - $desc"
        fi

        if [[ -s $outfile ]]; then
            sed 's:^:# :' <"$outfile"
        fi

        n=$((n + 1))
    done
}

testing::fail() {
    log::fatal "$*"
}
