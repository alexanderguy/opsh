# Run a series of functions, in order, starting with a prefix.
steps::run() {
    local prefix start name

    prefix=$1
    shift
    start=""

    if [[ $# -gt 0 ]]; then
        start="${prefix}::$1"
        shift
        log::warn "starting steps with $start..."
    fi

    while read -r name; do
        if [[ $name > $start || $name = "$start" ]]; then
            log::info "running step $name..."
            $name
        fi
    done < <(declare -F | grep "$prefix::" | awk '{ print $3; }')
}
