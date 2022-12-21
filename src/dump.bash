if hash xxd 2> /dev/null; then
	.dump.bin()
	{
		if [[ "$1" =~ ^\-(h|\-help)$ || -n "$1" && ! -r "$1" ]]; then
			echo "${FUNCNAME[0]} [file]?"
			echo '└─ Dump [file] or stdin to binary'

			[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
		fi

		xxd -b "${1:-/dev/stdin}" |	grep -oE '([01]{8}\ )+' | tr -d '[[:space:]]'
		echo
	}
fi

if hash hexdump 2> /dev/null; then
	.dump.hex()
	{
		if [[ "$1" =~ ^\-(h|\-help)$ || -n "$1" && ! -r "$1" ]]; then
			echo "${FUNCNAME[0]} [file]?"
			echo '└─ Dump [file] or stdin to hexadecimal'

			[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
		fi

		hexdump -ve '/1 "%02x"' "${1:-/dev/stdin}"
		echo
	}

	.dump.hex.array()
	{
		if [[ "$1" =~ ^\-(h|\-help)$ || -n "$1" && ! -r "$1" ]]; then
			echo "${FUNCNAME[0]} [file]?"
			echo '└─ Dump [file] or stdin to a C byte array'

			[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
		fi

		local dump=$(
			hexdump -ve '"\t" 1/1 "0x%02x" 11/1 ", 0x%02x" ",\n"' "${1:-/dev/stdin}"
		)

		local last=$(
			grep '0x ' <<< "$dump"
		)

		echo '{'

		head -n -1 <<< "$dump"

		if [[ -z "$last" ]]; then
			local cutto=12
		else
			local cutto=$[12 - $(grep -oE '0x ' <<< "$last" | wc -l)]
		fi

		tail -1 <<< "$dump" | cut -d ',' -f -${cutto}
		echo '};'
	}

	.dump.hex.str()
	{
		if [[ "$1" =~ ^\-(h|\-help)$ || -n "$1" && ! -r "$1" ]]; then
			echo "${FUNCNAME[0]} [file]?"
			echo '└─ Dump [file] or stdin to an escaped hex string'

			[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
		fi

		hexdump -ve '"\\\x" 1/1 "%02x"' "${1:-/dev/stdin}"
		echo
	}
fi
