# zsh-utils: transient-prompt
# When you press Enter, the full prompt collapses to "❯ command", colored like the
# prompt character (red after an error), as in powerlevel10k. Starship has no
# transient prompt for zsh.
# Needs mattmc3/zephyr path:plugins/editor (accept-line hooks); load after it.

# Color of the collapsed prompt character after success / after an error
: ${ZSH_UTILS_TRANSIENT_OK_COLOR:=76} ${ZSH_UTILS_TRANSIENT_ERROR_COLOR:=196}

function transient-prompt {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0      # not for continuation lines (PS2)
  local saved_prompt=$PROMPT saved_rprompt=$RPROMPT color
  # STARSHIP_CMD_STATUS: exit status of the previous command, set by starship
  (( ${STARSHIP_CMD_STATUS:-0} )) && color=$ZSH_UTILS_TRANSIENT_ERROR_COLOR || color=$ZSH_UTILS_TRANSIENT_OK_COLOR
  PROMPT=$'\n%F{'$color$'}❯%f '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt RPROMPT=$saved_rprompt
}

if (( $+functions[add-accept-line-hook] )); then
  add-accept-line-hook transient-prompt
else
  print -u2 "zsh-utils transient-prompt: needs mattmc3/zephyr path:plugins/editor loaded first"
fi
