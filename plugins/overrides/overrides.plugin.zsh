# zsh-utils: overrides
# Zephyr defaults changed back. Load after the Zephyr modules.

# zephyr directory sets NO_clobber, so `cmd > file` fails if the file exists.
# Allow overwriting again; `>|` is not needed then.
setopt clobber
