.text.lower()
{
	local text

	if [[ $# -gt 0 && ! -r "$1" ]]; then
		echo "${FUNCNAME[0]} [file]?"
		echo '└─ Convert [file] or stdin text to lowercase'

		return 1
	fi

	text="$(< ${1:-/dev/stdin})"
	echo "${text,,}"
}

.text.upper()
{
	local text

	if [[ $# -gt 0 && ! -r "$1" ]]; then
		echo "${FUNCNAME[0]} [file]?"
		echo '└─ Convert [file] or stdin text to uppercase'

		return 1
	fi

	text="$(< ${1:-/dev/stdin})"
	echo "${text^^}"
}
