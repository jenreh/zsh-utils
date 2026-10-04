# zsh-utils: overrides
# Zephyr defaults changed back. Load after the Zephyr modules.

# zephyr directory sets NO_clobber, so `cmd > file` fails if the file exists.
# Allow overwriting again; `>|` is not needed then.
setopt clobber

# zephyr history removes older duplicates of a command from the history file
# (hist_ignore_all_dups, hist_save_no_dups). That shrinks a long history to its
# unique commands and loses the timestamps of earlier runs. Keep every entry;
# consecutive duplicates are still skipped (hist_ignore_dups).
unsetopt hist_ignore_all_dups hist_save_no_dups
setopt hist_ignore_dups
