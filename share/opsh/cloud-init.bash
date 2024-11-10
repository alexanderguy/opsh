lib::import command

cloud-init::is-enabled() {
    command::exists cloud-init || return 1
}

cloud-init::wait-for-finish() {
    local ret=0

    cloud-init status --wait &>/dev/null || ret=$?

    case "$ret" in
    0 | 2)
        return 0
        ;;
    *)
        return "$ret"
        ;;
    esac
}
