.path.newest()
{
	local age newest_name newest_age=$(date +%s)

	if [[ "$1" =~ ^\-(h|\-help)$ || $# -eq 0 ]]; then
		echo "${FUNCNAME[0]} [file].."
		echo '└─ Print the name of the newest [file]'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "$@"; do
		if ! [ -e "$f" ]; then
			echo "[!] No such file or directory: '$f'"
			return 1
		fi

		age=$(stat -c '%X' "$f")

		if [ $age -gt $newest_age ]; then
			newest_age=$age
			newest_name="$f"
		fi
	done

	echo "$newest_name"
}

.path.oldest()
{
	local age oldest_name oldest_age=$(date +%s)

	if [[ "$1" =~ ^\-(h|\-help)$ || $# -eq 0 ]]; then
		echo "${FUNCNAME[0]} [file].."
		echo '└─ Print the name of the oldest [file]'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "$@"; do
		if ! [ -e "$f" ]; then
			echo "[!] No such file or directory: '$f'"
			return 1
		fi

		age=$(stat -c '%X' "$f")

		if [ $age -lt $oldest_age ]; then
			oldest_age=$age
			oldest_name="$f"
		fi
	done

	echo "$oldest_name"
}

.path.rename.lower()
{
	if [[ "$1" =~ ^\-(h|\-help)$ || $# -eq 0 ]]; then
		echo "${FUNCNAME[0]} [file].."
		echo '└─ Rename [file] to lowercase'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "$@"; do
		if [ -e "$f" ]; then
			mv "$f" "${f,,}"
		else
			echo "[-] No such file or directory: '${f}'"
		fi
	done
}

.path.rename.upper()
{
	if [[ "$1" =~ ^\-(h|\-help)$ || $# -eq 0 ]]; then
		echo "${FUNCNAME[0]} [file].."
		echo '└─ Rename [file] to uppercase'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "$@"; do
		if [ -e "$f" ]; then
			mv "$f" "${f^^}"
		else
			echo "[-] No such file or directory: '${f}'"
		fi
	done
}

.path.rename.capitalize()
{
	if [[ "$1" =~ ^\-(h|\-help)$ ||  $# -eq 0 ]]; then
		echo "${FUNCNAME[0]} [file].."
		echo '└─ Rename [file] to capitalized'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "$@"; do
		if [ -e "$f" ]; then
			mv "$f" "${f^}"
		else
			echo "[-] No such file or directory: '${f}'"
		fi
	done
}

.path.rename.hash()
{
	local d b x

	if ! [[ "$1" =~ ^(md5|sha1|sha256)$ && -e "$2" ]]; then
		echo "${FUNCNAME[0]} [md5|sha1|sha224|sha256|sha384|sha512] [file].."
		echo "└─ Rename [file] to it's hash (preserving filename extensions)"

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "${@:2}"; do
		if ! [ -e "$f" ]; then
			echo "[-] No such file or directory: '${f}'"
			continue
		fi

		d="$(dirname  "$file")"
		b="$(basename "$file")"

		[[ "$b" =~ \. ]] && x=".${f#*.}" || x=''

		case "$1" in
			md5)    mv "$f" "${d}/$(md5sum    "$f" | cut -d ' ' -f 1)${x}" ;;
			sha1)   mv "$f" "${d}/$(sha1sum   "$f" | cut -d ' ' -f 1)${x}" ;;
			sha224) mv "$f" "${d}/$(sha224sum "$f" | cut -d ' ' -f 1)${x}" ;;
			sha256) mv "$f" "${d}/$(sha256sum "$f" | cut -d ' ' -f 1)${x}" ;;
			sha384) mv "$f" "${d}/$(sha384sum "$f" | cut -d ' ' -f 1)${x}" ;;
			sha512) mv "$f" "${d}/$(sha512sum "$f" | cut -d ' ' -f 1)${x}" ;;
		esac
	done
}
