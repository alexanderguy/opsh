git::repo::version() {
    git describe --tags --dirty 2>/dev/null || git rev-parse --short HEAD
}
