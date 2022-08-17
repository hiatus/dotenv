.text.lower()
{
	local text

	if [[ $# -ne 0 && ! -r "$1" ]]; then
		echo "${FUNCNAME[0]} [file]?"
		echo '└─ Convert [file] or stdin text to lowercase'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	text="$(< ${1:-/dev/stdin})"
	echo "${text,,}"
}

.text.upper()
{
	local text

	if [[ $# -ne 0 && ! -r "$1" ]]; then
		echo "${FUNCNAME[0]} [file]?"
		echo '└─ Convert [file] or stdin text to uppercase'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	text="$(< ${1:-/dev/stdin})"
	echo "${text^^}"
}
