# How to configure from start

1. Install [Homebrew](https://brew.sh/).
2. (optional) Install [iTerm2](https://iterm2.com/).
3. Install `zsh` if needed (macOS already has zsh as default shell) - `brew install zsh`.
4. Install [oh-my-zsh](https://ohmyz.sh/#install) and set `ZSH_THEME="apple"`.
5. Install oh-my-zsh plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
6. Install [nvm](https://github.com/nvm-sh/nvm#installing-and-updating)
7. Install FZF (for better find experience)
	- `brew install fzf`
	- `brew install ripgrep`
	- `$(brew --prefix)/opt/fzf/install`
	-  add to .zshrc 
```
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 50% --border'
```
8. Install tmux - `brew install tmux`.
9. Run tmux (just type `tmux` in commandLine) and type <C-b> `:source-file ~/.tmux.conf` to link configuration file from this repo.
10. Move `.vimrc` to HOME directory, run `vim`, wait for plugin manager to be installed, then type `:PlugInstall` to install all plugins from `.vimrc`.
11. Move `.gitignore_global` to home directory and type `git config --global core.excludesfile ~/.gitignore_global`
12. Add aliases to .zshrc (in the bottom) - and call `source ~/.zshrc`
```
alias gamt='git add . && git commit -m "temp"'
```

[TMUX cheatsheet](https://gist.github.com/MohamedAlaa/2961058)

[VIM cheatsheet](https://vim.rtorr.com/)\
[VIM plugins](https://vimawesome.com/)\
[vimrc Дани Волкова](https://github.com/ziimir/dotfiles/blob/master/roles/tui/files/vimrc)

