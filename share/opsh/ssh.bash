export _OPSH_SSH_CONTEXT

ssh::end () {
    [[ -v _OPSH_SSH_CONTEXT ]] || return 0
    eval "$(cat "$_OPSH_SSH_CONTEXT/env")"
    eval "$(ssh-agent -k | grep -v echo)"
    unset _OPSH_SSH_CONTEXT
}

ssh::begin () {
    _OPSH_SSH_CONTEXT=$(temp::dir)
    chmod 700 "$_OPSH_SSH_CONTEXT"

    log::debug "launching local SSH agent..."    
    ssh-agent | grep -v echo > "$_OPSH_SSH_CONTEXT/env" 2>/dev/null
    eval "$(cat "$_OPSH_SSH_CONTEXT/env")"

    exit::trigger ssh::end
}

ssh::config () {
    cat >> "$_OPSH_SSH_CONTEXT/config"
}

ssh::background::close () {
    log::debug "closing SSH port forwarding..."

    echo >&"${_OPSH_SSH_COPROC[1]}"
    wait "$_OPSH_SSH_COPROC_PID"
}

ssh::background::run () {
    local response
    log::debug "launching port forwarding..."
    coproc _OPSH_SSH_COPROC { ssh -F "$_OPSH_SSH_CONTEXT/config" "$@" "echo goliath online ; read" ; }
    read -r response <&"${_OPSH_SSH_COPROC[0]}"

    [[ $response = "goliath online" ]] || log::fatal "failed to port forward"

    exit::trigger ssh::background::close
}

ssh::key::add () {
    local keyfile
    keyfile=$(temp::file)
    chmod 600 "$keyfile"

    if [[ $# -gt 0 ]] ; then
	for i in "$@" ; do
	    cat "$i" >"$keyfile"
	    ssh-add "$keyfile" 2>/dev/null
	done
    else
	cat >"$keyfile"
	ssh-add "$keyfile" 2>/dev/null
	
    fi
    rm "$keyfile"
}
