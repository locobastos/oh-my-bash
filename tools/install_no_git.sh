#!/usr/bin/env bash

# Use colors, but only if connected to a terminal, and that terminal supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
set -e

# Checks the minimum version of bash (v4) installed,
# stops the installation if check fails
if [ -n $BASH_VERSION ]; then
    bash_major_version=$(echo $BASH_VERSION | cut -d '.' -f 1)
    if [ "${bash_major_version}" -lt "4" ]; then
        printf "Error: Bash 4 required for Oh My Bash.\n"
        printf "Error: Upgrade Bash and try again.\n"
        exit 1
     fi
fi

if [ ! -n "$OSH" ]; then
    OSH=$HOME/.oh-my-bash
fi

if [ -d "$OSH" ]; then
    printf "${YELLOW}You already have Oh My Bash installed.${NORMAL}\n"
    printf "You'll need to remove $OSH if you want to re-install.\n"
    exit
fi

# Prevent the cloned repository from having insecure permissions. Failing to do
# so causes compinit() calls to fail with "command not found: compdef" errors
# for users with insecure umasks (e.g., "002", allowing group writability). Note
# that this will be ignored under Cygwin by default, as Windows ACLs take
# precedence over umasks except for filesystems mounted with option "noacl".
umask g-w,o-w

printf "${BLUE}Downloading Oh My Bash...${NORMAL}\n"
curl -fsSLN https://github.com/locobastos/oh-my-bash/archive/master.zip -o $HOME/oh-my-bash-master.zip

# Checks the installed dependancies
hash unzip >/dev/null 2>&1 || {
    echo "Error: unzip is not installed"
    exit 1
}

cd $HOME
unzip -qq $HOME/oh-my-bash-master.zip
mv $HOME/oh-my-bash-master $OSH

printf "${BLUE}Looking for an existing bash config...${NORMAL}\n"
if [ -f $HOME/.bashrc ] || [ -h $HOME/.bashrc ]; then
    printf "${YELLOW}Found ~/.bashrc.${NORMAL} ${GREEN}Backing up to ~/.bashrc.pre-oh-my-bash${NORMAL}\n";
    mv $HOME/.bashrc $HOME/.bashrc.pre-oh-my-bash;
fi

printf "${BLUE}Using the Oh My Bash template file and adding it to ~/.bashrc${NORMAL}\n"
cp $OSH/templates/bashrc_no_git.osh-template $HOME/.bashrc

# MOTD message :)
printf '%s' "$GREEN"
printf '%s\n' '         __                          __               __  '
printf '%s\n' '  ____  / /_     ____ ___  __  __   / /_  ____ ______/ /_ '
printf '%s\n' ' / __ \/ __ \   / __ `__ \/ / / /  / __ \/ __ `/ ___/ __ \\'
printf '%s\n' '/ /_/ / / / /  / / / / / / /_/ /  / /_/ / /_/ (__  ) / / /'
printf '%s\n' '\____/_/ /_/  /_/ /_/ /_/\__, /  /_.___/\__,_/____/_/ /_/ '
printf '%s\n' '                        /____/                            .... is now installed!'
printf "%s\n" "Please look over the ~/.bashrc file to select plugins, themes, and options"
printf "${BLUE}${BOLD}%s${NORMAL}\n" "To keep up on the latest news and updates, follow us on GitHub: https://github.com/ohmybash/oh-my-bash"
rm $HOME/oh-my-bash-master.zip
exec bash; source $HOME/.bashrc
