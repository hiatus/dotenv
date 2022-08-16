.random.bytes()
{
	if [[ ! "$1" =~ ^[1-9][0-9]*$ || $# -gt 1 ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo '└─ Write [n] random bytes to stdout'
	fi

	dd if=/dev/urandom bs=1 count=$1 2> /dev/null
}

.random.alpha()
{
	if [[ ! "$1" =~ ^[1-9][0-9]*$ || $# -gt 1 ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo '└─ Write [n] random alphabet characters to stdout'
	fi

	tr -dc '[:alpha:]' < /dev/urandom | head -c $1
	echo
}

.random.digit()
{
	if [[ ! "$1" =~ ^[1-9][0-9]*$ || $# -gt 1 ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo '└─ Write [n] random decimal characters to stdout'
	fi

	tr -dc '[:digit:]' < /dev/urandom | head -c $1
	echo
}

.random.alnum()
{
	if [[ ! "$1" =~ ^[1-9][0-9]*$ || $# -gt 1 ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo '└─ Write [n] random alphanumeric characters to stdout'
	fi

	tr -dc '[:alnum:]' < /dev/urandom | head -c $1
	echo
}

.random.punct()
{
	if [[ ! "$1" =~ ^[1-9][0-9]*$ || $# -gt 1 ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo '└─ Write [n] random punctuation characters to stdout'
	fi

	tr -dc '[:punct:]' < /dev/urandom | head -c $1
	echo
}

.random.text()
{
	if [[ ! "$1" =~ ^[1-9][0-9]*$ || $# -gt 1 ]]; then
		echo "${FUNCNAME[0]} [n]"
		echo '└─ Write [n] random text characters to stdout'
	fi

	tr -dc '[:alpha:][:xdigit:][:punct:]' < /dev/urandom | head -c $1
	echo
}
