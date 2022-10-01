.ref.cheat()
{
	if [[ $# -ne 1 || "$1" =~ ^\-(h|\-help)$ ]]; then
		echo "${FUNCNAME[0]} [query]"
		echo "└─ Query cheat.sh (alias for 'curl cheat.sh/[query]')"

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	curl "cheat.sh/${1}"
}
