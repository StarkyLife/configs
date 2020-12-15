# How to configure from start

1. Install [Homebrew](https://brew.sh/).
2. Install [iTerm2](https://iterm2.com/).
3. Install `zsh` if needed (macOS already has zsh as default shell) - `brew install zsh`.
4. Install [oh-my-zsh](https://ohmyz.sh/#install) and set `ZSH_THEME="apple"`.
5. Install oh-my-zsh plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
6. Install tmux - `brew install tmux`.
7. Run tmux (just type `tmux` in commandLine) and type `:source-file ~/.tmux.conf` to link configuration file from this repo.
8. Install FZF (for better find experience)
	- `brew install fzf`
	- `$(brew --prefix)/opt/fzf/install`
	-  add to .zshrc `export FZF_DEFAULT_OPTS='--height=40% --preview="cat {}" --preview-window=right:60%:wrap'`
9. Move `.vimrc` to HOME directory, run `vim`, wait for plugin manager to be installed, then type `:PlugInstall` to install all plugins from `.vimrc`.

[TMUX cheatsheet](https://gist.github.com/MohamedAlaa/2961058)

[VIM cheatsheet](https://vim.rtorr.com/)
[VIM plugins](https://vimawesome.com/)
