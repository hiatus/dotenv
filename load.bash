if [ -z "$BASH_VERSION" ]; then
	echo '[!] load.bash: this shell is not bash'
	return 1
fi

# Source files
for src in "$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")/src"/**; do
	[ -f "$src" ] && . "$src"
done
