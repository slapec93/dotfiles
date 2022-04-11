ln -s ~/develop/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/develop/dotfiles/vimrc ~/.vimrc
ln -s ~/develop/dotfiles/vimrc.bundles ~/.vimrc.bundles
ln -s ~/develop/dotfiles/vim/ftplugin/ ~/.vim/ftplugin
ln -s ~/develop/dotfiles/alacritty.yml ~/.alacritty.yml
ln -s ~/develop/dotfiles/zshrc ~/.zshrc
ln -s ~/develop/dotfiles/zshenv ~/.zshenv
ln -s ~/develop/dotfiles/oh-my-zsh ~/.oh-my-zsh/custom/themes
ln -s ~/develop/dotfiles/oh-my-zsh ~/.oh-my-zsh/custom/plugins

mkdir -p ~/.config/nvim
ln -s ~/develop/dotfiles/vim/nvim_init.vim ~/.config/nvim/init.vim
ln -s ~/develop/dotfiles/vim/coc-settings.json ~/.config/nvim/coc-settings.json

# Resolves python issue
python3 -m pip install --user --upgrade pynvim