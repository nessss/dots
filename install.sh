#!/bin/bash

if [ ! $TARGET ]; then
    TARGET=$HOME
    # TARGET=$HOME/dotfiletest
fi

echo "======= Homebrew ================================="
echo "*"
echo "*"

# homebrew

if ! which -s brew; then
    echo "*  brew not installed; installing"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "*  brew installed; updating"
    brew update
fi

echo "*"
echo "*"
echo "=================================================="
echo
echo "======= .dotfiles ================================"
echo "*"
echo "*"

# make folder for misc files
if [ ! -d $TARGET/.dotfiles ]; then
    echo "*  $TARGET/.dotfiles not found; creating"
    mkdir $TARGET/.dotfiles
else
    echo "*  $TARGET/.dotfiles found;"
fi
echo "*"
echo "*"

if [ -e $TARGET/.vimrc ] && [ ! -h $TARGET/.vimrc ]; then
    echo "*  $TARGET/.vimrc found; moving to $TARGET/.dotfiles/old_vimrc"
    mv $TARGET/.vimrc $TARGET/.dotfiles/old_vimrc
    echo "*"
fi

if [ -e $TARGET/.bashrc ] && [ ! -h $TARGET/.bashrc ]; then
    echo "*  $TARGET/.bashrc found; moving to $TARGET/.dotfiles/old_bashrc"
    mv $TARGET/.bashrc $TARGET/.dotfiles/old_bashrc
    echo "*"
fi

if [ ! -d $TARGET/.dotfiles/bash ]; then
    echo "*  creating symlink to bash files at $TARGET/.dotfiles/bash"
    ln -s $(realpath ./bash) $TARGET/.dotfiles/bash
else
    echo "*  $TARGET/.dotfiles/bash found"
fi

echo "*"
echo "*"
echo "=================================================="
echo
echo "======= vim ======================================"
echo "*"
echo "*"

if [ ! -e $TARGET/.vimrc ]; then
    echo "*  creating symlink to vimrc at $TARGET/.vimrc"
    ln -sv $(realpath ./vim/vimrc) $TARGET/.vimrc
fi
echo "*"
echo "*"

# link vim bundles
echo "*  updating submodules"
git submodule update
echo "*"
echo "*"

if [ ! -d $TARGET/.vim/bundle ]; then
    echo "*  $TARGET/.vim/bundle not found; creating"
    mkdir -p $TARGET/.vim/bundle
else
    echo "*  $TARGET/.vim/bundle found"
fi
echo "*"

for dir in ./vim/bundle/*/
do
    if [[ "greadlink -f $TARGET/.vim/bundle/$(basename $dir)" != `realpath $dir` ]]; then
        echo "*  creating symlink to $dir at $TARGET/.vim/bundle/$(basename $dir)"
        ln -s $(realpath $dir) $TARGET/.vim/bundle/$(basename $dir)
    fi
done

echo "*  vim bundle plugins installed"

echo "*"
echo "=================================================="
echo
echo "======= bash ====================================="
echo "*"

# set up bash

if [ ! -e $TARGET/.bashrc ]; then
    echo "*  creating symlink to bashrc at $TARGET/.bashrc"
    ln -s $(realpath ./bashrc) $TARGET/.bashrc
fi

echo "*"
echo "=================================================="
echo
echo
echo "dotfiles installed and up to date"

source $TARGET/.bashrc
