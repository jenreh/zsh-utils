#!/usr/bin/env zsh
# Smoke test: loads Zephyr and the zsh-utils modules in the documented order in a
# clean interactive zsh and checks what the modules are responsible for.
#   zsh tests/run.zsh            # clones Zephyr into a temp folder
#   ZEPHYR_DIR=~/src/zephyr zsh tests/run.zsh

emulate -L zsh
setopt err_return
ROOT=${0:A:h:h}
TMP=$(mktemp -d)
trap 'command rm -rf -- "${TMP:?}"' EXIT

if [[ -z $ZEPHYR_DIR ]]; then
  git clone -q --depth 1 https://github.com/mattmc3/zephyr.git $TMP/zephyr
  ZEPHYR_DIR=$TMP/zephyr
fi

# A fake tool that prints a completion, for the completion generator
mkdir -p $TMP/bin $TMP/home
print -r -- '#!/bin/sh
printf "#compdef faketool\n_faketool() { _arguments --help }\n"' > $TMP/bin/faketool
chmod +x $TMP/bin/faketool

cat > $TMP/zshrc <<EOF
zstyle ':zsh-utils:completion' generate 'faketool completion'
for p in $ROOT/plugins/zephyr-config \
         $ZEPHYR_DIR/plugins/{environment,history,directory,color,editor,utility} \
         $ROOT/plugins/overrides $ROOT/plugins/completion \
         $ZEPHYR_DIR/plugins/completion $ZEPHYR_DIR/plugins/history-search \
         $ZEPHYR_DIR/plugins/prompt $ROOT/plugins/transient-prompt $ROOT/plugins/tools; do
  source \$p/\${p:t}.plugin.zsh
done
run_post_zshrc 2>/dev/null   # what the first prompt would trigger
EOF

checks=(
  'clobber is on (overrides)'                '[[ -o clobber ]]'
  'history file is ~/.zsh_history'           '[[ $HISTFILE == $HOME/.zsh_history ]]'
  '~/.zfunc is on fpath'                     '(( ${fpath[(Ie)$HOME/.zfunc]} ))'
  'tool completion generated'                '[[ -s $HOME/.zfunc/_faketool ]]'
  'compinit ran (completion registered)'     '[[ ${_comps[faketool]} == _faketool ]]'
  'fzf-tab styles set after Zephyr styles'   '[[ $(zstyle -L ":completion:*:*:*:*:*" menu) == *"menu no"* ]]'
  'transient prompt hooked into Enter'       '(( ${accept_line_hook[(Ie)transient-prompt]} ))'
)

typeset -i failed=0
for name check in $checks; do
  if HOME=$TMP/home PATH=$TMP/bin:$PATH TERM=xterm-256color \
     zsh -f -i -c "source $TMP/zshrc; $check" &>/dev/null; then
    print -P "%F{green}ok%f    $name"
  else
    print -P "%F{red}FAIL%f  $name"; failed+=1
  fi
done

for f in $ROOT/plugins/*/*.plugin.zsh; do
  zsh -n $f || { print -P "%F{red}FAIL%f  syntax: ${f#$ROOT/}"; failed+=1 }
done
(( failed )) && { print "$failed check(s) failed"; return 1 }
print "all checks passed"
