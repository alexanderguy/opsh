#!/usr/bin/env opsh

lib::import test-harness ssh

source "$SCRIPTDIR/utils.opsh"

check-ssh-path-setup() {
    local oldpath realssh

    oldpath="$PATH"
    realssh=$(command -v ssh)

    ssh::begin

    [[ $PATH == "$_OPSH_SSH_CONTEXT/bin:$oldpath" ]] || testing::fail "PATH doesn't appear to have been setup correctly"
    [[ $(command -v ssh) == "$_OPSH_SSH_CONTEXT/bin/ssh" ]] || testing::fail "couldn't find proxied ssh in PATH search"
    ssh::end

    [[ $PATH == "$oldpath" ]] || testing::fail "PATH wasn't properly restored"
    [[ $(command -v ssh) == "$realssh" ]] || testing::fail "couldn't find the real ssh after the environment was torn down"

}

testing::register check-ssh-path-setup "make sure we setup and teardown the proxied ssh properly"

check-that-proxied-ssh-works() {
    ssh::begin
    ssh::config <<'EOF'
Host foobar.com
    User whatwhat
EOF
    eval-and-check-output "ssh -G foobar.com | grep 'user '" <<EOF
user whatwhat
EOF

    ssh::end
}

testing::register check-that-proxied-ssh-works "make sure that we're running our proxied ssh"

make-sure-broken-environments-error() {
    local ctx ret

    ssh::begin
    ctx=$_OPSH_SSH_CONTEXT
    unset _OPSH_SSH_CONTEXT

    ret=0
    eval-and-check-output "ssh 2>&1" <<EOF || ret=$?
FATAL:	proxied ssh being run outside of opsh ssh context; this is a bug
EOF
    [[ $ret -eq 1 ]] || testing::fail "incorrect error status found"

    _OPSH_SSH_CONTEXT=$ctx
    ssh::end
}

testing::register make-sure-broken-environments-error "handle the case where we call a proxied ssh in a broken environment"

testing::run
