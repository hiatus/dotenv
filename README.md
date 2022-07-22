dotenv
======
A set of bash functions to help the CLI workflow. All functions are prefixed with `.` such as
`.dump.hex`, a function that dumps input to the standard output as a hexadecimal string. To display
all available functions, just type `.<Tab><Tab>` after sourcing `load.bash` and shell completion
should do the job. You can also extend `dotenv` by creating a folder named `local` inside `src` and
storing your files there (this folder is already ignored in `.gitignore`).


Installation
------------
Simply source `load.bash` from within a bash session.
```
user@host:~$ git clone https://github.com/hiatus/dotenv
user@host:~$ . dotenv/load.bash
```
