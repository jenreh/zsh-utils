# zsh-utils: tools
# Shell integration of pyenv, fzf, iTerm2 and zoxide. Load last: fzf after fzf-tab
# (Tab without ** falls back to it), zoxide at the very end (it checks its hook).
# Uses Zephyr's cached-eval (cache refreshed every 20 hours).

# pyenv: `pyenv shell` and completions. Not cached: its output contains the versioned
# Homebrew path, which disappears after an upgrade. The shims are on PATH via ~/.zprofile.
(( $+commands[pyenv] )) && eval "$(pyenv init - --no-push-path --no-rehash zsh)"

# fzf: Ctrl-R fuzzy history, Ctrl-T file picker, **<Tab> fuzzy completion
(( $+commands[fzf] )) && cached-eval fzf --zsh

# iTerm2 shell integration (installed by iTerm2 or install_apps.zsh)
[[ -r ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

# zoxide: `z <part of a path>`, `zi` picks with fzf
(( $+commands[zoxide] )) && cached-eval zoxide init zsh
