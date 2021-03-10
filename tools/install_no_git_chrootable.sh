#!/usr/bin/env bash

if [ ! -n "$OSH" ]; then
    OSH=$HOME/.oh-my-bash
fi

if [ -d "$OSH" ]; then
    printf "You already have Oh My Bash installed.\n"
    printf "You'll need to remove $OSH if you want to re-install.\n"
    exit
fi

printf "Downloading Oh My Bash...\n"
curl -fsSLN https://github.com/locobastos/oh-my-bash/archive/master.zip -o $HOME/oh-my-bash-master.zip

# Checks the installed dependancies
hash unzip >/dev/null 2>&1 || {
    echo "Error: unzip is not installed"
    exit 1
}

cd $HOME
unzip -qq $HOME/oh-my-bash-master.zip -d $HOME
mv $HOME/oh-my-bash-master $OSH

printf "Looking for an existing bash config...\n"
if [ -f $HOME/.bashrc ] || [ -h $HOME/.bashrc ]; then
    printf "Found ~/.bashrc. Backing up to ~/.bashrc.pre-oh-my-bash\n";
    mv $HOME/.bashrc $HOME/.bashrc.pre-oh-my-bash;
fi

printf "Using the Oh My Bash template file and adding it to ~/.bashrc\n"
cp $OSH/templates/bashrc_no_git.osh-template $HOME/.bashrc

# MOTD message :)
printf '%s\n' '         __                          __               __  '
printf '%s\n' '  ____  / /_     ____ ___  __  __   / /_  ____ ______/ /_ '
printf '%s\n' ' / __ \/ __ \   / __ `__ \/ / / /  / __ \/ __ `/ ___/ __ \\'
printf '%s\n' '/ /_/ / / / /  / / / / / / /_/ /  / /_/ / /_/ (__  ) / / /'
printf '%s\n' '\____/_/ /_/  /_/ /_/ /_/\__, /  /_.___/\__,_/____/_/ /_/ '
printf '%s\n' '                        /____/                            .... is now installed!'
printf "%s\n" "Please look over the ~/.bashrc file to select plugins, themes, and options"
printf "%s\n" "To keep up on the latest news and updates, follow us on GitHub: https://github.com/ohmybash/oh-my-bash"
rm $HOME/oh-my-bash-master.zip
