command::exists() {
    local command=$1
    shift

    command -v "$command" &>/dev/null || return 1
}
