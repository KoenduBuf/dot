
check-variable() {
    eval "VAR=\${$1}"
    if [ -z "${VAR+x}" ] || [ -z "$VAR" ]; then
        echo "The variable $1 is needed for this functionality." >/dev/tty
        echo "Consider setting it in your .dotrc or something."  >/dev/tty
        return 1
    fi
}

backup_data() {
    check-variable "BUTO" || return 1
    echo " [ Starting local backup of data ]"
    echo "-- Backing up to: $BUTO"
    echo "-- Additional arguments: $*"

    rsync $@ -av -e ssh                         \
        --exclude "/temp"                       \
        --exclude "/System Volume Information"  \
        --exclude "/\$RECYCLE.BIN"              \
        --exclude "/.Trash-1000"                \
        --exclude "node_modules"                \
        "/mnt/data/" "$BUTO/backup_data"
    echo " [ Completed local backup of data ]"
}

on_home_wifi() {
    check-variable "HOME_SSID_START" || return 42
    local tmpc=$(nmcli -t -f name connection show --active)
    if [[ "$tmpc" == "$HOME_SSID_START"* ]]; then
        [ ! -z "$1" ] && echo $1    # on home network, echo 1st argument
        return 0
    else
        [ ! -z "$2" ] && echo $2    # on other network, echo 2nd argument
        return 1
    fi
}

home_ssh_ip_and_port() {
    check-variable "HOME_SSH_SERVER_IP" || return 1
    check-variable "HOME_SSH_SERVER_PORT" || return 1
    check-variable "PUBLIC_HOME_IP" || return 1
    check-variable "PUBLIC_HOME_SSH_PORT" || return 1
    on_home_wifi
    ONHOME=$?
    [ $ONHOME -eq 42 ] && return 1
    ([ $ONHOME -eq 0 ] && ping -c2 $HOME_SSH_SERVER_IP >/dev/null &&\
    echo "$HOME_SSH_SERVER_IP -p $HOME_SSH_SERVER_PORT") ||\
    echo "$PUBLIC_HOME_IP -p $PUBLIC_HOME_SSH_PORT"
}

home_ssh_address() {
    check-variable "HOME_SSH_USERNAME" || return 1
    IP_N_P=$(home_ssh_ip_and_port) || return 1
    echo "${HOME_SSH_USERNAME}@$IP_N_P"
}

alias beanie_web='ADDR=$(home_ssh_address) && sshtunnel "$ADDR" 3000'
alias beanie_ssh='ADDR=$(home_ssh_address) && ssh $ADDR'

dot-notify() {
    echo "Not implemented yet"
}


