# Dotfiles

Configs for my Mac: zsh + powerlevel10k, Neovim and Vim/MacVim (IDE setup),
AeroSpace, SketchyBar, git, iTerm2, and every Homebrew app in `Brewfile`.

On a set-up Mac this folder lives at `~/Dotfiles`, and each file here is symlinked
into `~`, so editing `~/.zshrc` edits the copy in this folder.

## New Mac

1. Copy this folder to `~/Dotfiles` (it has to stay there: the symlinks point into it).
2. In Terminal:

```sh
xcode-select --install          # compilers; wait for it to finish
~/Dotfiles/install.sh
```

The script installs Homebrew, links the dotfiles (moving anything already there to
`~/.dotfiles-backup-*`), installs the Brewfile, uv, Neovim/Vim plugins and language
servers, imports iTerm2 settings, and starts SketchyBar and AeroSpace.
It's safe to run again.

## Keeping it current

| After you…                      | Run                                                   |
|---------------------------------|-------------------------------------------------------|
| install or remove a brew app    | `brew bundle dump --file=~/Dotfiles/Brewfile --force` |
| change iTerm2 settings          | `defaults export com.googlecode.iterm2 ~/Dotfiles/iterm2/com.googlecode.iterm2.plist && plutil -convert xml1 ~/Dotfiles/iterm2/com.googlecode.iterm2.plist` |
| add a new config to keep        | move it into this folder, add its path to `LINKS` in `install.sh`, run `~/Dotfiles/install.sh links` |

## Not in here (on purpose)

SSH keys, `gh` login (`.config/gh/hosts.yml`), shell history, Claude settings.
Back those up separately before wiping a Mac.
