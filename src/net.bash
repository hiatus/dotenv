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
