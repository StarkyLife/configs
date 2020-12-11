# How to configure from start

1. Install [Homebrew](https://brew.sh/).
2. Install [iTerm2](https://iterm2.com/).
3. Install `zsh` if needed (macOS already has zsh as default shell) - `brew install zsh`.
4. Install [oh-my-zsh](https://ohmyz.sh/#install) and set `ZSH_THEME="apple"`.
5. Install oh-my-zsh plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
6. Install tmux - `brew install tmux`.
7. Run tmux (just type `tmux` in commandLine) and type `:source-file ~/.tmux.conf` to link configuration file from this repo.
8. Install plugin manager for Vim [Plug](https://github.com/junegunn/vim-plug#installation), move `.vimrc` to HOME directory, run `vim` and type `:PlugInstall` to install all plugins from `.vimrc`.

[tmux cheatsheet](https://gist.github.com/MohamedAlaa/2961058)

[vim plugins](https://vimawesome.com/)
