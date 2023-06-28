# Gateway address
.net.gateway()
{
	if [ $# -ne 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print LAN gateway'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	ip r | awk '/default via/ {print $3}'
}

## LAN
# Subnet
.net.lan.subnet()
{
	if [ $# -ne 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print LAN subnet'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	ip r | awk '/src / {print $1}'
}

# LAN address
.net.lan.ipv4()
{
	if [ $# -ne 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print LAN IPv4 address(es)'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	ip r | awk '/src / {print $9}'
}

# WAN address
.net.wan.ipv4()
{
	if [ $# -ne 0 ]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print WAN IPv4 address'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	host myip.opendns.com resolver4.opendns.com | awk '/address/ { print $NF }'
}

## IO
.net.io.download()
{
	local ifaces rx1=0 rx2=0

	if [[ "$1" =~ ^\-(h|\-help)$ || $# -ne 0 && ! -d "/sys/class/net/${1}" ]]; then
		echo "${FUNCNAME[0]} [iface]?"
		echo '└─ Print the current download throughput of one or all interfaces'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	[ -n "$1" ] && ifaces=("$1") || ifaces=($(ls '/sys/class/net'))

	for iface in "${ifaces[@]}"; do
		rx1=$[rx1 + $(<"/sys/class/net/${iface}/statistics/rx_bytes")]
	done

	sleep 1

	for iface in "${ifaces[@]}"; do
		rx2=$[rx2 + $(<"/sys/class/net/${iface}/statistics/rx_bytes")]
	done

	if ! command -v bc > /dev/null; then
		echo "$[rx2 - rx1] B/s"
	else
		echo "$(bc <<< "scale=2; (${rx2} - ${rx1}) / 1024 / 1024") Mb/s"
	fi
}

.net.io.upload()
{
	local ifaces tx1=0 tx2=0

	if [[ "$1" =~ ^\-(h|\-help)$ || $# -ne 0 && ! -d "/sys/class/net/${1}" ]]; then
		echo "${FUNCNAME[0]} [iface]?"
		echo '└─ Print the current upload throughput'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	[ -n "$1" ] && ifaces=("$1") || ifaces=($(ls '/sys/class/net'))

	for iface in "${ifaces[@]}"; do
		tx1=$[tx1 + $(<"/sys/class/net/${iface}/statistics/tx_bytes")]
	done

	sleep 1

	for iface in "${ifaces[@]}"; do
		tx2=$[tx2 + $(<"/sys/class/net/${iface}/statistics/tx_bytes")]
	done

	if ! command -v bc > /dev/null; then
		echo "$[tx2 - tx1] B/s"
	else
		echo "$(bc <<< "scale=2; (${tx2} - ${tx1}) / 1024 / 1024") Mb/s"
	fi
}
