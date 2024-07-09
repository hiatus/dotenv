.path.size()
{
	local size desc

	if [[ "$1" =~ ^\-(h|\-help)$ || $# -eq 0 ]]; then
		echo "${FUNCNAME[0]} [file].."
		echo '└─ Print the size of each [file] in an informational manner'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "$@"; do
		if ! [ -f "$f" ]; then
			echo "[!] No such file: '${f}'"
			return 1
		fi
	done

	for f in "$@"; do
		size=$(stat -c '%s' "$f")
		desc="${size} bytes"

		[ $size -ge 1000 ]       && desc="$[${size} / 1000 ] Kb, ${desc}"
		[ $size -ge 1000000 ]    && desc="$[${size} / 1000000 ] Mb, ${desc}"
		[ $size -ge 1000000000 ] && desc="$[${size} / 1000000000 ] Gb, ${desc}"

		[ $# -gt 1 ] && echo "${f}: ${desc}" || echo "${desc}"
	done
}


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

.path.slugify()
{
	if [[ "$1" =~ ^\-(h|\-help)$ || $# -eq 0 ]]; then
		echo "${FUNCNAME[0]} [string].."
		echo '└─ Convert [string].. into slug(s) (URL-friendly string)'

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for s in "$@"; do
		iconv -ct ascii//TRANSLIT <<< "$s" |
			sed -E -e 's/[^[:alnum:]]+/-/g' -e 's/^-+|-+$//g' | tr '[:upper:]' '[:lower:]'
	done
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
	local d b e

	if ! [[ "$1" =~ ^(md5|sha1|sha256)$ && -e "$2" ]]; then
		echo "${FUNCNAME[0]} [md5|sha1|sha224|sha256|sha384|sha512] [file].."
		echo "└─ Rename [file] to it's hash (preserving filename extensions)"

		[[ "$1" =~ ^\-(h|\-help)$ ]] && return 0 || return 1
	fi

	for f in "${@:2}"; do
		if ! [ -f "$f" ]; then
			if [ -d "$f" ]; then
				echo "[-] Skipping directory '${f}'"
			else
				echo "[-] No such file: '${f}'"
			fi

			continue
		fi

		d="$(dirname  "$f")"
		b="$(basename "$f")"
		e=".${b#*.}"

		[[ "$e" = ".${b}" ]] && e=''

		case "$1" in
			md5)    mv -vi "$f" "${d}/$(md5sum    "$f" | cut -d ' ' -f 1)${e}" ;;
			sha1)   mv -vi "$f" "${d}/$(sha1sum   "$f" | cut -d ' ' -f 1)${e}" ;;
			sha224) mv -vi "$f" "${d}/$(sha224sum "$f" | cut -d ' ' -f 1)${e}" ;;
			sha256) mv -vi "$f" "${d}/$(sha256sum "$f" | cut -d ' ' -f 1)${e}" ;;
			sha384) mv -vi "$f" "${d}/$(sha384sum "$f" | cut -d ' ' -f 1)${e}" ;;
			sha512) mv -vi "$f" "${d}/$(sha512sum "$f" | cut -d ' ' -f 1)${e}" ;;
		esac
	done
}
