EXIT_FUNCS=()

exit::trap () {
    local func
    for func in "${EXIT_FUNCS[@]}"; do
	$func
    done
}

trap exit::trap EXIT

exit::trigger () {
    EXIT_FUNCS+=("$*")
}

TMPDIR=$(mktemp -d)
export TMPDIR

temp::cleanup () {
    log::debug cleaning up "$TMPDIR"...
    rm -rf "$TMPDIR"
}

exit::trigger temp::cleanup

# shellcheck disable=SC2120 # these options are optional.
temp::file () {
    mktemp -p "$TMPDIR" "$@"
}

# shellcheck disable=SC2120 # these options are optional.
temp::dir () {
    mktemp -d -p "$TMPDIR" "$@"
}

CRED=''
CGRN=''
CYEL=''
CBLU=''
CNONE=''

if [[ -t 1 ]]; then
    CRED='\033[0;31m'
    CGRN='\033[0;32m'
    CYEL='\033[0;32m'
    CBLU='\033[0;34m'
    CNONE='\033[0m'
fi

log::output () {
    local level
    level="$1"
    shift

    printf "$level:\t%s\n" "$*" >&2
}

log::debug () {
    [[ -v DEBUG ]] || return 0

    log::output "${CBLU}DEBUG${CNONE}" "$@"
}

log::info () {
    log::output "${CGRN}INFO${CNONE}" "$@"
}

log::warn () {
    log::output "${CYEL}WARN${CNONE}" "$@"
}

log::error () {
    log::output "${CRED}ERROR${CNONE}" "$@"
}

log::fatal () {
    log::output "${CRED}FATAL${CNONE}" "$@"
    exit 1
}

lib::import () {
    local libfile
    for libname in "$@" ; do
	libfile="$OPSHROOTDIR/share/opsh/$libname.bash"
	[[ -f $libfile ]] || log::fatal "library '$libname' not found!"

	# shellcheck disable=SC1090
	source "$libfile"
    done
}
