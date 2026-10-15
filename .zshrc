# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# pnpm
export PNPM_HOME="/Users/kshitij/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Matte Black colors for fzf and lazygit (bat reads ~/.config/bat/config)
export FZF_DEFAULT_OPTS="--color=bg:#121212,bg+:#262626,fg:#BEBEBE,fg+:#FFFFFF,hl:#F59E0B,hl+:#F59E0B,border:#333333,header:#8A8A8D,info:#8A8A8D,marker:#10B981,pointer:#F59E0B,prompt:#F59E0B,spinner:#F59E0B,query:#EAEAEA,gutter:#121212"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
