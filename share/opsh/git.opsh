git::repo::version() {
    git describe --tags --dirty 2>/dev/null || git rev-parse --short HEAD
}

git::repo::current-branch() {
    git rev-parse --abbrev-ref HEAD
}

git::repo::is-clean() {
    [[ $(git status --porcelain | wc -c) -eq 0 ]] || return 1
}

git::tag::exists() {
    local tag=$1
    shift

    [[ $(git tag -l "$tag") == "$tag" ]] || return 1
}
