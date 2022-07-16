if hash hexdump 2> /dev/null; then
	.dump.hex()
	{
		if [[ -n "$1" && ! -r "$1" ]]; then
			echo "${FUNCNAME[0]} [file]?"
			echo '└─ Dump [file] or stdin to hexadecimal'

			return 1
		fi

		hexdump -ve '/1 "%02x"' "${1:-/dev/stdin}"
		echo
	}

	.dump.array()
	{
		if [[ -n "$1" && ! -r "$1" ]]; then
			echo "${FUNCNAME[0]} [file]?"
			echo '└─ Dump [file] or stdin to a C byte array'

			return 1
		fi

		local dump=$(
			hexdump -ve '"\t" 1/1 "0x%02x" 7/1 ", 0x%02x" ",\n"' "${1:-/dev/stdin}"
		)

		local last=$(
			grep '0x ' <<< "$dump"
		)

		echo 'const uint8_t data[] = {'

		head -n -1 <<< "$dump"

		if [[ -z "$last" ]]; then
			local cutto=8
		else
			local cutto=$[8 - $(grep -oE '0x ' <<< "$last" | wc -l)]
		fi

		tail -1 <<< "$dump" | cut -d ',' -f -${cutto}
		echo '};'
	}

	.dump.str()
	{
		if [[ -n "$1" && ! -r "$1" ]]; then
			echo "${FUNCNAME[0]} [file]?"
			echo '└─ Dump [file] or stdin to an escaped hex string'

			return 1
		fi

		hexdump -ve '"\\\x" 1/1 "%02x"' "${1:-/dev/stdin}"
		echo
	}
fi
