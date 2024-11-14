#!/bin/bash
# ███████╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ 
# ██╔════╝╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
# █████╗   ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
# ██╔══╝    ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
# ██║        ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
# ╚═╝        ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
# script by furcom (https://github.com/furcom)

source ./files/hypr/scripts/FYPR_VARS

########################################
##                                    ##
##  The main script is at the bottom! ##
##                                    ##
########################################

##### yay #####
check_yay_health() {
    if ! yay -V &> /dev/null; then
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

##### bluetooth #####
BLUETOOTH() {
    sudo pacman -S --needed --noconfirm bluez bluez-utils
    yay -S --needed --noconfirm bluetui
    systemctl enable bluetooth.service
    systemctl start bluetooth.service
}

##### cliphist #####
CLIPHIST() {
    sudo pacman -S --needed --noconfirm cliphist xdg-utils
}

##### fastfetch #####
FASTFETCH() {
    sudo pacman -S --needed --noconfirm fastfetch
    cp -rf ./files/fastfetch/ "$CFGDIR"
}

##### fusuma #####
add_user_to_group_if_needed() {
    if ! groups "$USER" | grep &>/dev/null '\binput\b'; then
        sudo gpasswd -a "$USER" input
    fi
}
FUSUMA() {
    sudo pacman -S --needed --noconfirm libinput ruby
    yay -S --needed --noconfirm ruby-fusuma
    cp -rf ./files/fusuma/ "$CFGDIR"
    add_user_to_group_if_needed
}

##### Hypr Ecosystem #####
HYPR() {
    # Hyprland
    sudo pacman -S --needed --noconfirm hyprland
    cp -rf ./files/hypr/* "$CFGDIR"
    
    #Hyprlock
    sudo pacman -S --needed --noconfirm hyprlock

    # Fonts
    sudo pacman -S --needed --noconfirm extra/ttf-0xproto-nerd
    
    # Hyprcursor
    sudo pacman -S --needed --noconfirm hyprcursor
    mkdir -p $HOME/.icons/
    cp -rf ./files/cursors/* "$HOME/.icons/"
    hyprctl setcursor Bibata-Modern-Ice 32

    # Hyprpaper + Extras
    sudo pacman -S --needed --noconfirm hyprpaper
    yay -S --needed --noconfirm waypaper
    yay -S --needed --noconfirm wallust
    cp -rf ./files/wallust/ "$CFGDIR"
    cp -rf ./files/waypaper/ "$CFGDIR"
    waypaper --backend hyprpaper --wallpaper $HyprWallpapersDir/Mountain.png

    # Hyprpicker
    yay -S --needed --noconfirm hyprpicker

    # Hyprshot
    yay -S --needed --noconfirm hyprshot
    mkdir -p $HOME/Pictures/Screenshots

    # Hypridle
    sudo pacman -S --needed --noconfirm hypridle

    # END
    echo -e "\n${GREEN}Hyprland installed.${NC}"
}

##### GTK #####
GTK() {
    sudo pacman -S --needed --noconfirm nwg-look gtk3 gtk4
    sudo cp -r ./files/icons/kora/* /usr/share/icons/
    sudo cp -r ./files/icons/tela/* /usr/share/icons/
}

##### kitty #####
KITTY() {
    sudo pacman -S --needed --noconfirm kitty
    cp -rf ./files/kitty/ "$CFGDIR"
}

##### mako #####
MAKO() {
    sudo pacman -S --needed --noconfirm mako
    cp -rf ./files/mako/ "$CFGDIR"
}

##### nvim / neovim #####
NVIM() {
    sudo pacman -S --needed --noconfirm neovim ripgrep npm
    cp -rf ./files/nvim/ "$CFGDIR"
}

##### Pipewire / Wireplumber #####
PIPEWIRE() {
    sudo pacman -S --needed --noconfirm pipewire wireplumber
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

##### sddm #####
SDDM() {
    sudo pacman -S --needed --noconfirm sddm
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -rf ./files/sddm/* /etc/sddm.conf.d/
    sudo sed -i '/^#%PAM/a auth sufficient pam_succeed_if.so user ingroup nopasswdlogin' /etc/pam.d/sddm
    sudo groupadd -r nopasswdlogin
    sudo gpasswd -a "$USER" nopasswdlogin
}

##### waybar #####
WAYBAR() {
    sudo pacman -S --needed --noconfirm waybar noto-fonts-emoji python python-pyquery
    yay -S --needed --noconfirm wttrbar
    cp -rf ./files/waybar/ "$CFGDIR"
}

##### wlogout #####
WLOGOUT() {
    yay -S --needed --noconfirm wlogout
    cp -rf ./files/wlogout/ "$CFGDIR"
}

##### zsh  & oh-my-posh #####
ZSH() {
    sudo pacman -S --needed --noconfirm zsh fzf zoxide
    cp -f ./files/.zshrc "$HOME"
    cp -rf ./files/oh-my-posh/ "$CFGDIR"
    sudo chsh -s /bin/zsh $USER
    sudo chsh -s /bin/zsh root
}

#####################
#####################
###               ###
###  MAIN SCRIPT  ###
###               ###
#####################
#####################

YAY

BLUETOOTH
CLIPHIST
FASTFETCH
FUSUMA
HYPR
GTK
KITTY
MAKO
NVIM
PIPEWIRE
ROFI
SDDM
WAYBAR
WLOGOUT
ZSH

exit
