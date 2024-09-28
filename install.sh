#!/bin/bash
# ███████╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ 
# ██╔════╝╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
# █████╗   ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
# ██╔══╝    ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
# ██║        ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
# ╚═╝        ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
# script by furcom (https://github.com/furcom)

source ./files/hypr/scripts/HYPR_VARS

########################################
##                                    ##
##  The main script is at the bottom! ##
##                                    ##
########################################

##### YAY #####

check_yay_health() {
    if ! yay -V &> /dev/null; then
        echo -e "\n${RED}yay is not functioning properly. Please fix the issue with yay before proceeding.${NC}"
        exit 1
    fi
}

install_yay() {
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

##### Hypr Ecosystem #####

install_hyprland() {
    sudo pacman -S --needed --noconfirm hyprland
    cp -rf ./files/hypr/hyprland.conf "$CFGDIR"/hypr/
    cp -rf ./files/hypr/configs/ "$CFGDIR"/hypr/
    cp -rf ./files/hypr/images/ "$CFGDIR"/hypr/
    cp -rf ./files/hypr/scripts/ "$CFGDIR"/hypr/
    echo -e "\n${GREEN}Hyprland installed.${NC}"
}

install_hyprcursor() {
    sudo pacman -S --needed --noconfirm hyprcursor
    cp -rf ./files/cursors/* "$HOME/.icons/"
    hyprctl setcursor Bibata-Modern-Ice 32
}

install_hyprlock() {
    sudo pacman -S --needed --noconfirm hyprlock
    cp -rf ./files/hypr/hyprlock.conf "$CFGDIR"/hypr/
}

install_hyprpaper() {
    sudo pacman -S --needed --noconfirm hyprpaper
    cp -rf ./files/hypr/hyprpaper.conf "$CFGDIR"/hypr/
    cp -rf $HyprWallpapersDir/Hyprland.png $HyprImagesDir/wallpaper.png
}

install_hyprpicker() {
    yay -S --needed --noconfirm hyprpicker
}

install_hyprbars() {
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm enable hyprbars
}

install_hypridle() {
    sudo pacman -S --needed --noconfirm hypridle
}

##### wallust #####

install_wallust() {
    yay -S --needed --noconfirm wallust
    cp -rf ./files/wallust/ "$CFGDIR"
    wallust run $HyprpaperCache/wallpaper.png
}

##### waybar #####

install_waybar() {
    sudo pacman -S --needed --noconfirm waybar noto-fonts-emoji
    yay -S --needed --noconfirm wttrbar
    cp -rf ./files/waybar/ "$CFGDIR"
    sudo cp -rf ./files/services/waybar.service /etc/systemd/user/waybar.service
    sudo systemctl --user daemon-reload
    sudo systemctl --user enable waybar.service
}

##### rofi & rofimoji #####

install_rofimoji() {
    sudo pacman -S --needed --noconfirm rofimoji
    cp -rf ./files/rofimoji.rc "$CFGDIR"
}

install_rofi() {
    sudo pacman -S --needed --noconfirm rofi-wayland
    cp -rf ./files/rofi/ "$CFGDIR"
}

##### fusuma #####

add_user_to_group_if_needed() {
    if ! groups "$USER" | grep &>/dev/null '\binput\b'; then
        sudo gpasswd -a "$USER" input
    fi
}

install_fusuma() {
    sudo pacman -S --needed --noconfirm libinput ruby
    yay -S --needed --noconfirm ruby-fusuma
    cp -rf ./files/fusuma/ "$CFGDIR"
    add_user_to_group_if_needed
}

##### kitty #####

install_kitty() {
    sudo pacman -S --needed --noconfirm kitty
    cp -rf ./files/kitty/ "$CFGDIR"
}

##### sddm #####

install_sddm() {
    sudo pacman -S --needed --noconfirm sddm
    sudo mkdir -p /etc/sddm.conf.d
    sudo cp -rf ./files/sddm/* /etc/sddm.conf.d/
    sudo sed -i '/^#%PAM/a auth sufficient pam_succeed_if.so user ingroup nopasswdlogin' /etc/pam.d/sddm
    sudo groupadd -r nopasswdlogin
    sudo gpasswd -a "$USER" nopasswdlogin
}

##### zsh #####

install_omp() {
    cp -rf ./files/oh-my-posh/ "$CFGDIR"
}

install_zsh() {
    sudo pacman -S --needed --noconfirm zsh fzf zoxide
    cp -f ./files/.zshrc "$HOME"
    sudo chsh -s /bin/zsh $USER
    sudo chsh -s /bin/zsh root
    install_omp
}

##### mako #####

install_mako() {
    sudo pacman -S --needed --noconfirm mako
    cp -rf ./files/mako/ "$CFGDIR"
}

##### fastfetch #####

install_fastfetch() {
    sudo pacman -S --needed --noconfirm fastfetch
    cp -rf ./files/fastfetch/ "$CFGDIR"
}

##### WirePlumber #####

install_audio() {
    sudo pacman -S --needed --noconfirm pipewire wireplumber
}

##### Persistent clipboard #####

install_wl-clip-persist() {
    sudo pacman -S --needed --noconfirm wl-clip-persist
}

##### bluetooth #####

install_bluetooth() {
    sudo pacman -S --needed --noconfirm bluez bluez-utils
    yay -S --needed --noconfirm bluetui
    systemctl enable bluetooth.service
    systemctl start bluetooth.service
}

##### Fonts #####
install_fonts() {
    sudo pacman -S --needed --noconfirm extra/ttf-0xproto-nerd
}

###################
##               ##
##  MAIN SCRIPT  ##
##               ##
###################

# Needed packages
install_yay
install_fonts
install_kitty
install_hyprland
install_hyprpaper
install_hyprcursor
install_hyprlock
install_wallust

# Recommended packages
install_hypridle
install_mako
install_audio
install_wl-clip-persist
install_waybar
install_rofi

# Optional packages
install_hyprbars
install_hyprpicker
install_rofimoji
install_fusuma
install_bluetooth
install_fastfetch
install_sddm
install_zsh

echo -e "\n${RED}!!!! IT IS RECOMMENDED TO REBOOT YOUR SYSTEM !!!!${NC}\n"
read -p "Press ENTER key to continue or CTRL+C to cancel installation..."
