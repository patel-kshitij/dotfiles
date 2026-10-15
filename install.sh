#!/bin/zsh
# Set up a Mac from this repo. Safe to run again: it skips what's already done.
#   ~/Dotfiles/install.sh            everything
#   ~/Dotfiles/install.sh links      only (re)create the symlinks

set -e
DOTFILES=${0:A:h}
BACKUP=~/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)

# Everything that lives in this repo, as paths relative to $HOME
LINKS=(
  .zshrc .zprofile .profile .p10k.zsh
  .gitconfig .config/git
  .vimrc .gvimrc .config/nvim .vim/colors/matteblack.vim .vim/autoload/lightline/colorscheme/matteblack.vim
  .aerospace.toml .config/sketchybar
  .config/gh/config.yml .config/neofetch .config/mdless
  .config/lazygit .config/bat
)

step() { print -P "\n%F{magenta}==>%f %B$1%b" }

link_all() {
  step "Linking dotfiles"
  for p in $LINKS; do
    local src=$DOTFILES/$p dst=~/$p
    if [[ -L $dst && ${dst:A} == ${src:A} ]]; then
      continue                                  # already linked
    fi
    if [[ -e $dst || -L $dst ]]; then           # keep whatever was there
      mkdir -p $BACKUP/${p:h} && mv $dst $BACKUP/$p
      print "  backed up ~/$p"
    fi
    mkdir -p ${dst:h} && ln -s $src $dst
    print "  linked ~/$p"
  done
  [[ -d $BACKUP ]] && print "  old files are in $BACKUP"
  return 0
}

if [[ $1 == links ]]; then link_all; exit 0; fi

step "Xcode command line tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  print "Finish the installer window, then run this script again."; exit 1
fi

step "Homebrew"
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

link_all

step "Apps and tools from Brewfile"
brew bundle --file=$DOTFILES/Brewfile || print "  some Brewfile entries failed; run 'brew bundle' later to retry"

step "uv (Python tooling)"
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh

step "Neovim plugins, parsers, language servers"
nvim --headless "+Lazy! restore" +qa
nvim --headless -c "lua require('nvim-treesitter').install({'bash','c','cpp','css','diff','gitcommit','html','java','javascript','json','lua','luadoc','markdown','markdown_inline','python','query','regex','toml','tsx','typescript','vim','vimdoc','yaml'}):wait(600000)" -c qa
nvim --headless -c "MasonInstall basedpyright ruff vtsls eslint-lsp html-lsp css-lsp json-lsp jdtls clangd marksman lua-language-server prettierd stylua clang-format google-java-format debugpy codelldb" -c qa

step "Vim / MacVim plugins"
vim -es -u ~/.vimrc -i NONE -c "PlugInstall --sync" -c qa || true

step "iTerm2 preferences"
if pgrep -xq iTerm2; then
  print "  iTerm2 is running. Quit it, then run:"
  print "  defaults import com.googlecode.iterm2 $DOTFILES/iterm2/com.googlecode.iterm2.plist"
else
  defaults import com.googlecode.iterm2 $DOTFILES/iterm2/com.googlecode.iterm2.plist
  print "  imported"
fi
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
cp $DOTFILES/iterm2/matteblack.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/
print "  Matte Black profile added (iTerm2 > Settings > Profiles > Matte Black > Other Actions > Set as Default)"
bat cache --build >/dev/null && print "  bat theme built"

step "Background services"
brew services start sketchybar >/dev/null && print "  sketchybar started"
open -a AeroSpace 2>/dev/null && print "  AeroSpace opened (allow Accessibility when macOS asks)" || true

step "Done. A few things need you:"
print "  - gh auth login                      (GitHub CLI login)"
print "  - copy your SSH keys into ~/.ssh      (or make new ones: ssh-keygen -t ed25519)"
print "  - open a new terminal so zsh picks up everything"
