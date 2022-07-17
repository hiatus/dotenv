## LAN
# Gateway address
.net.lan.gateway()
{
	if [[ -n "$*" ]]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print LAN gateway'

		return 1
	fi

	ip r | awk '/default/ {print \$3}'
}

# Subnet
.net.lan.subnet()
{
	if [[ -n "$*" ]]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print LAN subnet'

		return 1
	fi

	ip r | awk '/link src/ {print \$1}'
}

# LAN address
.net.lan.ipv4()
{
	if [[ -n "$*" ]]; then
		echo "${FUNCNAME[0]}"
		echo '└─ Print LAN IPv4 address(es)'

		return 1
	fi

	ip r | awk '/dhcp src/ {print \$9}'
}

## WAN
# External IP address
if hash dig 2> /dev/null; then
	# From DNS server
	.net.wan.ipv4()
	{ 
		if [[ -n "$*" ]]; then
			echo "${FUNCNAME[0]}"
			echo '└─ Print WAN IPv4 address'

			return 1
		fi

		dig +short myip.opendns.com @resolver4.opendns.com
	}

elif hash curl 2> /dev/null; then
	# From HTTP server
	net.wan.ipv4()
	{
		if [[ -n "$*" ]]; then
			echo "${FUNCNAME[0]}"
			echo '└─ Show the current IPv4 address(es)'

			return 1
		fi

		echo $(curl whatismyip.akamai.com 2> /dev/null)
	}
fi

## IO
.net.io.download()
{
	local ifaces rx1=0 rx2=0

	if [[ $# -gt 1 || ! -d "/sys/class/net/${1}" ]]; then
		echo "${FUNCNAME[0]} [iface]?"
		echo '└─ Print the current download throughput'

		return 1
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

	if [[ $# -gt 1 || ! -d "/sys/class/net/${1}" ]]; then
		echo "${FUNCNAME[0]} [iface]?"
		echo '└─ Print the current upload throughput'

		return 1
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
