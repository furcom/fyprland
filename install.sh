#!/bin/bash
# ███████╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ 
# ██╔════╝╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
# █████╗   ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
# ██╔══╝    ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
# ██║        ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
# ╚═╝        ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
# script by furcom (https://github.com/furcom)

CFGDIR="$HOME/.config"

########################################
##                                    ##
##  The main script is at the bottom! ##
##                                    ##
########################################

##### yay #####
check_yay_health() {
    if ! yay -V &> /dev/null; then
        NC='\033[0m'
        RED='\e[31m'
        echo -e "\n${RED}yay is not functioning properly. Please fix the issue with yay before proceeding.${NC}"
        exit 1
    fi
}
YAY() {
    if ! pacman -Q yay &> /dev/null; then
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay-install
        cd /tmp/yay-install
        makepkg -si
        cd -
        rm -rf /tmp/yay-install/
        check_yay_health
    fi
}

##### fusuma #####
FUSUMA() {
    sudo pacman -S --needed --noconfirm libinput ruby
    yay -S --needed --noconfirm ruby-fusuma
    cp -rf ./files/fusuma/ "$CFGDIR"
    add_user_to_group_if_needed

    # Add user to input-group
    if ! groups "$USER" | grep &>/dev/null '\binput\b'; then
        sudo gpasswd -a "$USER" input
    fi
}

##### Hypr Ecosystem #####
HYPR() {
    # Hyprland
    sudo pacman -S --needed --noconfirm hyprland
    yay -S --needed --noconfirm hyprland-qtutils
    cp -rf ./files/hypr/ "$CFGDIR"
    
    #Hyprlock
    sudo pacman -S --needed --noconfirm hyprlock

    # Fonts
    sudo pacman -S --needed --noconfirm extra/ttf-0xproto-nerd
    
    # Hyprcursor
    sudo pacman -S --needed --noconfirm hyprcursor
    mkdir -p $HOME/.icons/
    cp -rf ./files/THEME/cursors/* "$HOME/.icons/"
    hyprctl setcursor Bibata-Modern-Ice 32

    # Hyprpaper
    sudo pacman -S --needed --noconfirm hyprpaper

    # wallust
    yay -S --needed --noconfirm wallust
    cp -rf ./files/wallust/ "$CFGDIR"

    # waypaper
    yay -S --needed --noconfirm waypaper
    cp -rf ./files/waypaper/ "$CFGDIR"
    waypaper --backend hyprpaper --wallpaper $CFGDIR/hypr/images/wallpapers/Mountain.png

    # Hyprpicker
    yay -S --needed --noconfirm hyprpicker

    # Hyprshot
    yay -S --needed --noconfirm hyprshot
    mkdir -p $HOME/Pictures/Screenshots

    # Hypridle
    sudo pacman -S --needed --noconfirm hypridle
}

##### Theme: GTK, Icons, etc #####
THEME() {
    sudo pacman -S --needed --noconfirm nwg-look gtk3 gtk4
    sudo cp -r ./files/THEME/icons/kora/* /usr/share/icons/
    sudo cp -r ./files/THEME/icons/tela/* /usr/share/icons/
    sudo cp -r ./files/THEME/gtk/* /usr/share/themes/
}

##### nvim / neovim #####
NVIM() {
    sudo pacman -S --needed --noconfirm neovim ripgrep npm
    cp -rf ./files/nvim/ "$CFGDIR"
}

##### rofi & rofimoji #####
ROFI() {
    # Rofi
    sudo pacman -S --needed --noconfirm rofi-wayland
    cp -rf ./files/rofi/ "$CFGDIR"

    # Rofimoji
    sudo pacman -S --needed --noconfirm rofimoji
    cp -rf ./files/rofimoji.rc "$CFGDIR"
}

##### hyprpanel #####
HYPRPANEL() {
    sudo pacman -S --needed --noconfirm brightnessctl power-profiles-daemon
    yay -S --needed --noconfirm bluetui ags-hyprpanel-git
    cp -rf ./files/hyprpanel/ "$CFGDIR"
}

##### login / logout #####
LOGINOUT() {
    # greetd (with autologin)
    sudo pacman -S --needed --noconfirm greetd
    sudo cp -rf ./files/greetd/config.toml /etc/greetd/config.toml
    sudo sed -i "s/furcom/$(whoami)/g" /etc/greetd/config.toml
}

#### Needed packages #####
NEEDED(){
    # btop
    sudo pacman -S --needed --noconfirm btop

    # Cliphist & wl-clip-persist
    sudo pacman -S --needed --noconfirm cliphist wl-clip-persist xdg-utils

    # Network
    sudo pacman -S --needed --noconfirm networkmanager network-manager-applet

    # Bluetooth
    sudo pacman -S --needed --noconfirm bluez bluez-utils
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service

    # Audio
    sudo pacman -S --needed --noconfirm pipewire wireplumber

    # Nemo (File Browser)
    sudo pacman -S --needed --noconfirm nemo nemo-fileroller nemo-preview nemo-seahorse nemo-share nemo-terminal android-file-transfer gvfs-mtp
    yay -S --needed --noconfirm nemo-compare

}

##### Terminal #####
TERMINAL() {
    # kitty
    sudo pacman -S --needed --noconfirm kitty
    cp -rf ./files/kitty/ "$CFGDIR"

    # fastfetch
    sudo pacman -S --needed --noconfirm fastfetch
    cp -rf ./files/fastfetch/ "$CFGDIR"

    # zsh
    sudo pacman -S --needed --noconfirm fzf zoxide zsh
    cp -rf ./files/.zshrc "$HOME"
    sudo chsh -s /bin/zsh $USER
    sudo chsh -s /bin/zsh root

    # oh-my-posh
    cp -rf ./files/oh-my-posh/ "$CFGDIR"
}

#####################
#####################
###               ###
###  MAIN SCRIPT  ###
###               ###
#####################
#####################

YAY
THEME
HYPR
HYPRPANEL
LOGINOUT
NEEDED
NVIM
ROFI
TERMINAL
FUSUMA
exit
