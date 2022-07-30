.proc.top.cpu()
{
	if ! [[ "$1" =~ ^[1-9][0-9]*$ ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo -e '└─ Show the top [n] processes sorted by CPU usage'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	ps -eo comm,%cpu --sort=-%cpu | head -$(($1 + 1))
}

.proc.top.mem()
{
	if ! [[ "$1" =~ ^[1-9][0-9]*$ ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo -e '└─ Show the top [n] processes sorted by RAM usage'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	ps -eo comm,%mem --sort=-%mem | head -$(($1 + 1))
}
