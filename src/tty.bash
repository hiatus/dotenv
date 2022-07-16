.tty.dimesions()
{
	echo "Rows    : ${LINES}"
	echo "Columns : ${COLUMNS}"
}

# Output the $((LINES - 1)) first lines
.tty.head()
{
	[ $# -gt 0 ] && head -$((LINES - 1)) $* || head -$((LINES - 1))
}

# Output the $((LINES - 1)) last lines
.tty.tail()
{
	[ $# -gt 0 ] && tail -$((LINES - 1)) $* || tail -$((LINES - 1))
}

if hash script gawk tar xz 2> /dev/null; then
	.tty.log()
	{
		local tmp prc

		if ! [[ -n "$1" && -z "$2" || "$2" =~ ^(0|[1-9][0-9]*)(\.[0-9]+)?$ ]]; then
			echo "${FUNCNAME[0]} [file] [float]"
			echo '├ Save a script session to [file].txz'
			echo '└ Optionally limit timing intervals to [float] seconds'

			return 1
		fi

		mkdir "${tmp:=/tmp/script_$(date +%d-%m-%Y_%H-%M-%S)}" || return $?

		if ! script -qt"${tmp}/timescript" "${tmp}/typescript"; then
			rm -rf "$tmp"
			return 2
		fi

		if [ -n "$2" ]; then
			prc="${2#*.}$(printf '%*s' 5 | tr ' ' '0')"

			gawk -i inplace -v i="${2%.*}.${prc::6}" '{
				if ($0 > i) {
					gsub(/^(0|[1-9][0-9]*)\.[0-9]+/, i, $0)
				}

				print
			}' "${tmp}/timescript"
		fi

		tar -C "$tmp" -cJf "${1}.txz" {time,type}script
		rm -rf "$tmp"
	}
fi
