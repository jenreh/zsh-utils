# zsh-utils: zephyr-config
# Settings for the Zephyr modules (mattmc3/zephyr). Load before them.

# history: keep the usual ~/.zsh_history (Zephyr's default is ~/.local/share/zsh/zsh_history)
zstyle ':zephyr:plugin:history' histfile "${ZDOTDIR:-$HOME}/.zsh_history"

# completion: run compinit when the module loads, not at the first prompt, because
# fzf-tab must be loaded after compinit. Cached dump; no security audit on every start.
zstyle ':zephyr:plugin:completion' immediate yes
zstyle ':zephyr:plugin:completion' use-cache yes
zstyle ':zephyr:plugin:completion' disable-compfix yes

# prompt: starship (config: ~/.config/starship.toml)
zstyle ':zephyr:plugin:prompt' theme starship
