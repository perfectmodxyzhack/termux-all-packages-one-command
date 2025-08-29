#!/data/data/com.termux/files/usr/bin/bash

# Colors
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;34m'
cyan='\033[1;36m'
reset='\033[0m'

clear

# Animation Function (progress bar)
loading () {
    bar="████████████████████████████████████████"
    barlength=${#bar}
    i=0
    while [ $i -lt $barlength ]; do
        printf "\r${cyan}[%-${barlength}s] ${yellow}%d%%" "${bar:0:$i}" $(( (i+1)*100/barlength ))
        sleep 0.02
        ((i++))
    done
    echo -e "\n"
}

# Package install function
install_pkg() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${yellow}➡ Installing $1 ...${reset}"
        pkg install -y $2 > /dev/null 2>&1
        echo -e "${green}✔ $1 installed.${reset}\n"
    else
        echo -e "${green}✔ $1 already installed.${reset}\n"
    fi
}

# Special installer for lolcat
install_lolcat() {
    if ! command -v lolcat &> /dev/null; then
        echo -e "${yellow}➡ Installing lolcat ...${reset}"
        pkg install -y ruby > /dev/null 2>&1
        gem install lolcat > /dev/null 2>&1
        echo -e "${green}✔ lolcat installed.${reset}\n"
    else
        echo -e "${green}✔ lolcat already installed.${reset}\n"
    fi
}

# Asking for name
echo -e "${yellow}Please enter your name:${reset}"
read username

echo -e "\n${cyan}🔄 Updating system packages...${reset}\n"
pkg update -y && pkg upgrade -y

# Packages to install
basic_tools=(
  git:git curl:curl wget:wget python:python python2:python2 python3:python3
  php:php nodejs:nodejs vim:vim nano:nano unzip:unzip zip:zip tar:tar
  clang:clang make:make cmake:cmake ruby:ruby perl:perl openssh:ssh
  net-tools:ifconfig nmap:nmap hydra:hydra figlet:figlet toilet:toilet
  cowsay:cowsay neofetch:neofetch sox:play termux-api:termux-vibrate
)

echo -e "${blue}📦 Installing required tools...${reset}\n"

for pair in "${basic_tools[@]}"; do
    cmd="${pair%%:*}"
    pkgname="${pair##*:}"
    install_pkg "$cmd" "$pkgname"
    loading
done

# Install lolcat separately (Ruby gem)
install_lolcat

clear

# Stylish banner with lolcat
echo -e "${green}All tools installed successfully!${reset}\n"
echo -e "${red}=================================================${reset}" | lolcat
figlet -f slant "$username" | lolcat
echo -e "${red}=================================================${reset}" | lolcat

# Extras
echo -e "${cyan}🚀 Setup complete! Enjoy hacking, $username 😎${reset}\n" | lolcat
neofetch | lolcat
cowsay "Welcome $username!" | lolcat

# Play a sound effect (success tone)
play -nq -t alsa synth 0.4 sine 800 2>/dev/null

# Vibrate for 500ms
termux-vibrate -d 500
