
alias public="curl ifconfig.me"

alias ssh='/usr/bin/ssh -o ConnectTimeout=8'
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
alias insecscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'

killport() {
    for port in "$@"; do
        processname=$(netstat -ltnp 2>/dev/null | grep --color=never -w ":$port" | awk '{ print $7 }')
        process=$(echo "$processname" | awk -F/ '{ print $1 }')
        if [ -z "$process" ]; then
            echo "No process found for port $port"
            continue
        fi
        echo "Found that the port is in use by $processname, killing it now!"
        kill $process && echo "Kill confirmed" || echo "Could not kill it..."
    done
}

oping() {
    local DOTS=0
    local STOP=600 # max pings (also seconds)
    printf "Pinging using %s until response " "'${@}'"
    while ! timeout 0.5 ping -c 1 -n ${@} &> /dev/null; do
        DOTS=$(( $DOTS + 1 ))
        [ $DOTS -eq 4 ] && printf "\b\b\b   \b\b\b" && DOTS=0 || printf "."
        sleep 0.5
        STOP=$(( $STOP - 1 ))
        [ $STOP -le 0 ] && echo "Stopping (Max tries)" && return 1
    done
    printf "\n%s\n"  "We reached the server!"
    return 0
}

nmap192() {
    ip192=$(ip -o -f inet addr show |
        awk '/scope global/ {print $4}' |
        \grep -E '192(\.[0-9]*){3}[0-9]*/[0-9]*' )
    if [ -z "$ip192" ]; then
        echo "Could not find ip starting with 192"
        return
    fi
    echo "Found scan ip to be $ip192"
    sudo nmap -sn -oX - $ip192 | xmlstarlet sel -t \
            -m '/nmaprun/host[status/@state="up"]' \
            -v 'address[@addrtype="ipv4"]/@addr' -o $'\t' \
            -v 'address[@addrtype="mac"]/@addr' -o $'\t' \
            -v 'address[@addrtype="mac"]/@vendor' -o $'\t' \
            -v 'hostnames/hostname[1]/@name' -n
}



sshtunnel() {
    if [[ $# -lt 2 ]]; then
        print "Usage: sshtunnel <name@hostip -p sshport> <port to tunnel>"
    else
        command="ssh -N -L ${2}:127.0.0.1:${2} ${1}"
        print "Running: $command"
        print "Local port ${2} will serve remote port ${2}"
        eval $command
    fi
}


