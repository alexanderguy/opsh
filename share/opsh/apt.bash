apt::env() {
    # Disable interactive frontends by default.
    DEBIAN_FRONTEND=noninteractive
    export DEBIAN_FRONTEND

    : "${SUDO:=sudo --preserve-env=DEBIAN_FRONTEND}"
    : "${APT:=$SUDO apt-get -qy}"
}

apt::update() {
    (
        apt::env
        $APT update "$@"
    )
}

apt::install() {
    (
        apt::env
        $APT install "$@"
    )
}
