#!/bin/bash

sudo echo " 
[custom] 
SigLevel = Optional TrustAll
Server = file:///home/sento/hyprthreds/Pkgs" >> /etc/pacman.conf

cat /etc/pacman.conf

sudo pacman -Syyu

sudo pacman -S swww grimblast-git hyprdots-ctl-git hyprpicker oh-my-zsh-git wlogout swaylock-effects-git pokemon-colorscripts-git python-pyamdgpuinfo rofi-lbonn-wayland-git zsh-theme-powerlevel10k

/home/sento/hyprthreds/Hyprdots/Scripts/install.sh
