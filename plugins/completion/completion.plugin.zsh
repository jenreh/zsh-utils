# zsh-utils: completion
# Own completion files and fzf-tab styles around Zephyr's completion module.
# Load before mattmc3/zephyr path:plugins/completion (which runs compinit).

0=${(%):-%N}

# Completion files in ~/.zfunc (also where Typer-based CLIs install theirs).
# -g: plugin managers source plugins inside a function, where typeset would be local.
typeset -gU fpath
fpath=(~/.zfunc $fpath)

# Completions printed by tools themselves, written to ~/.zfunc and refreshed when the
# tool is updated. Override with:  zstyle ':zsh-utils:completion' generate 'cmd args' ...
() {
  local -a generators
  zstyle -a ':zsh-utils:completion' generate generators || generators=('ngrok completion')
  local gen cmd file
  for gen in $generators; do
    cmd=${gen%% *} file=~/.zfunc/_${gen%% *}
    (( $+commands[$cmd] )) || continue
    [[ -s $file && $file -nt $commands[$cmd] ]] && continue
    mkdir -p ~/.zfunc && ${=gen} >| $file
  done
}

# fzf-tab shows the list itself and uses the description format for group headers.
# Set after Zephyr's completion styles, at the end of .zshrc.
function zsh-utils-fzf-tab-styles {
  zstyle ':completion:*' menu no
  zstyle ':completion:*:*:*:*:*' menu no
  zstyle ':completion:*:descriptions' format '[%d]'
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 -G $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -1 -G $realpath'
}
if (( $+functions[add-post-zshrc-hook] )); then
  add-post-zshrc-hook zsh-utils-fzf-tab-styles
else
  zsh-utils-fzf-tab-styles
fi
