# Get list of up hosts
.nmap.up-hosts()
{
    if ! [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/([0-9]|[12][0-9]|3[012]))?$ ]]; then
        echo "${FUNCNAME[0]} [subnet]"
		echo '└─ List up hosts in [subnet]'

        [[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
    fi

    nmap -sn -T4 -oG - "$1" |
		grep 'Status: Up' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}'
}

# Get a list of hosts with specific ports open
.nmap.open-ports()
{
    if ! [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/([0-9]|[12][0-9]|3[012]))?$ && "$2" -gt 1 && "$2" -lt 65535 ]]; then
        echo "${FUNCNAME[0]} [subnet] [port][,port].."
		echo '└─ List hosts in [subnet] with port(s) [port] open'

        [[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
    fi

    nmap -Pn --open -p "$2" -oG - "$1" |
		grep 'Status: Up' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}'
}
