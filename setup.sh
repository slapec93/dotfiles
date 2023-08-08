ln -s ~/develop/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/develop/dotfiles/vimrc ~/.vimrc
ln -s ~/develop/dotfiles/vimrc.bundles ~/.vimrc.bundles
ln -s ~/develop/dotfiles/vim/ftplugin/ ~/.vim/ftplugin
ln -s ~/develop/dotfiles/alacritty.yml ~/.alacritty.yml
ln -s ~/develop/dotfiles/zshrc ~/.zshrc
ln -s ~/develop/dotfiles/zshenv ~/.zshenv
ln -s ~/develop/dotfiles/github-co-author-list ~/.vim/github-co-author-list
ln -s ~/develop/dotfiles/oh-my-zsh ~/.oh-my-zsh/custom/themes
ln -s ~/develop/dotfiles/oh-my-zsh ~/.oh-my-zsh/custom/plugins

mkdir -p ~/.config/nvim/ftplugin
ln -s ~/develop/dotfiles/nvim/ftplugin ~/.config/nvim/ftplugin
ln -s ~/develop/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/nvim/lua
ln -s ~/develop/dotfiles/nvim/lua ~/.config/nvim/lua
mkdir -p ~/.config/nvim/snippets
ln -s ~/develop/dotfiles/snippets ~/.config/nvim/snippets

brew install ripgrep
brew install fd
