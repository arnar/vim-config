My `.vim` directory.

Installation:

    git clone git://github.com/arnar/vim-config.git ~/.vim

Create symlinks:

    ln -s ~/.vim/vimrc ~/.vimrc

Open vim and install plugins:

    vim
    :PlugInstall

After plugins are installed, build the native parts of vimproc:

    cd ~/.vim/plugged/vimproc.vim
    make

That's it.
