#!/usr/bin/env bash
#|---/ /+-------------------------------------+---/ /|#
#|--/ /-| Script to apply pre install configs |--/ /-|#
#|-/ /--| Prasanth Rangan                     |-/ /--|#
#|/ /---+-------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

# grub
if pkg_installed grub && [ -f /boot/grub/grub.cfg ]; then
    echo -e "\033[0;32m[BOOTLOADER]\033[0m detected // grub"

    if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]; then
        echo -e "\033[0;32m[BOOTLOADER]\033[0m configuring grub..."
        sudo cp /etc/default/grub /etc/default/grub.t2.bkp
        sudo cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp

        fi

        echo -e "Select grub theme:\n[1] Retroboot (dark)\n[2] Pochita (light)"
        read -p " :: Press enter to skip grub theme <or> Enter option number : " grubopt
        case ${grubopt} in
            1) grubtheme="Retroboot" ;;
            2) grubtheme="Pochita" ;;
            *) grubtheme="None" ;;
        esac

        if [ "${grubtheme}" == "None" ]; then
            echo -e "\033[0;32m[BOOTLOADER]\033[0m Skippinng grub theme..."
            sudo sed -i "s/^GRUB_THEME=/#GRUB_THEME=/g" /etc/default/grub
        else
            echo -e "\033[0;32m[BOOTLOADER]\033[0m Setting grub theme // ${grubtheme}"
            sudo tar -xzf ${cloneDir}/Source/arcs/Grub_${grubtheme}.tar.gz -C /usr/share/grub/themes/
            sudo sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
            /^GRUB_GFXMODE=/c\GRUB_GFXMODE=1280x1024x32,auto
            /^GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/${grubtheme}/theme.txt\"
            /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub
        fi

        sudo grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo -e "\033[0;33m[SKIP]\033[0m grub is already configured..."
    fi

# systemd-boot
        echo -e "\033[0;33m[SKIP]\033[0m systemd-boot is already configured..."

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]; then
    echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    sudo pacman -Syyu
    sudo pacman -Fy

else
    echo -e "\033[0;33m[SKIP]\033[0m pacman is already configured..."
fi
