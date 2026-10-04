# zsh-utils

Small zsh modules that complete [Zephyr](https://github.com/mattmc3/zephyr) for my
setup: a [starship](https://starship.rs) prompt with a powerlevel10k-like transient
prompt, fzf-tab, and shell integration for pyenv, fzf, zoxide and iTerm2.
Zephyr provides the basics (options, history, key bindings, completion, prompt);
these modules only add what Zephyr doesn't have.

## Modules

| Module | What it does | Load |
|---|---|---|
| `zephyr-config` | Settings for the Zephyr modules: history file `~/.zsh_history`, compinit right away (needed by fzf-tab), starship as prompt | before Zephyr |
| `overrides` | Zephyr defaults changed back: `>` may overwrite files again (`clobber`) | after Zephyr's `directory` |
| `completion` | `~/.zfunc` on `fpath`; completions printed by tools (default: `ngrok completion`) written there and refreshed after updates; fzf-tab styles | before Zephyr's `completion` |
| `transient-prompt` | After Enter, the prompt collapses to `❯ command` (red after an error) | after Zephyr's `editor` and `prompt` |
| `tools` | pyenv shell integration, fzf (Ctrl-R, Ctrl-T, `**<Tab>`), iTerm2 shell integration, zoxide | last |

## Usage with antidote

The order matters; comments say why.

```text
# ~/.zsh_plugins.txt
jenreh/zsh-utils path:plugins/zephyr-config

mattmc3/zephyr path:plugins/environment
mattmc3/zephyr path:plugins/history
mattmc3/zephyr path:plugins/directory
mattmc3/zephyr path:plugins/color
mattmc3/zephyr path:plugins/editor
mattmc3/zephyr path:plugins/utility
jenreh/zsh-utils path:plugins/overrides

# everything that adds completions to fpath, then compinit
zsh-users/zsh-completions path:src kind:fpath
jenreh/zsh-utils path:plugins/completion
mattmc3/zephyr path:plugins/completion

# fzf-tab after compinit, before the plugins that wrap line-editor widgets
Aloxaf/fzf-tab
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
mattmc3/zephyr path:plugins/history-search

mattmc3/zephyr path:plugins/prompt
jenreh/zsh-utils path:plugins/transient-prompt

# fzf after fzf-tab, zoxide last
jenreh/zsh-utils path:plugins/tools
```

## Configuration

```zsh
# Completions to generate into ~/.zfunc (command and arguments that print one)
zstyle ':zsh-utils:completion' generate 'ngrok completion' 'mytool completions zsh'

# Colors (256-color numbers) of the collapsed prompt character
ZSH_UTILS_TRANSIENT_OK_COLOR=76
ZSH_UTILS_TRANSIENT_ERROR_COLOR=196
```

## Tests

```sh
zsh tests/run.zsh                          # clones Zephyr into a temp folder
ZEPHYR_DIR=~/src/zephyr zsh tests/run.zsh  # or uses a local copy
```

## License

MIT
