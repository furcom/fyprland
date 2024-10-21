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

yay() {
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

HYPRLAND() {
    sudo pacman -S --needed --noconfirm hyprland
    cp -rf ./files/hypr/hyprland.conf "$CFGDIR"/hypr/
    cp -rf ./files/hypr/configs/ "$CFGDIR"/hypr/
    cp -rf ./files/hypr/images/ "$CFGDIR"/hypr/
    cp -rf ./files/hypr/scripts/ "$CFGDIR"/hypr/
    echo -e "\n${GREEN}Hyprland installed.${NC}"
}

HYPRCURSOR() {
    sudo pacman -S --needed --noconfirm hyprcursor
    cp -rf ./files/cursors/* "$HOME/.icons/"
    hyprctl setcursor Bibata-Modern-Ice 32
}

HYPRLOCK() {
    sudo pacman -S --needed --noconfirm hyprlock
    cp -rf ./files/hypr/hyprlock.conf "$CFGDIR"/hypr/
}

HYPRPAPER() {
    sudo pacman -S --needed --noconfirm hyprpaper
    cp -rf ./files/hypr/hyprpaper.conf "$CFGDIR"/hypr/
    cp -rf $HyprWallpapersDir/Mountain.png $HyprImagesDir/wallpaper.png
}

HYPRPICKER() {
    yay -S --needed --noconfirm hyprpicker
}

HYPRPLUGINS() {
    sudo pacman -S --needed --noconfirm cmake meson cpio
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm disable hyprbars
    hyprpm enable hyprexpo
}

install_hyprshot() {
    yay -S --needed --noconfirm hyprshot
    mkdir -p $HOME/Pictures/Screenshots
}

HYPRIDLE() {
    sudo pacman -S --needed --noconfirm hypridle
}

##### wallust #####

WALLUST() {
    yay -S --needed --noconfirm wallust
    cp -rf ./files/wallust/ "$CFGDIR"
    wallust run $HyprpaperCache/wallpaper.png
}

##### waybar #####

WAYBAR() {
    sudo pacman -S --needed --noconfirm waybar noto-fonts-emoji
    yay -S --needed --noconfirm wttrbar
    cp -rf ./files/waybar/ "$CFGDIR"
}

##### rofi & rofimoji #####

ROFIMOJI() {
    sudo pacman -S --needed --noconfirm rofimoji
    cp -rf ./files/rofimoji.rc "$CFGDIR"
}

ROFI() {
    sudo pacman -S --needed --noconfirm rofi-wayland
    cp -rf ./files/rofi/ "$CFGDIR"
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

##### kitty #####

KITTY() {
    sudo pacman -S --needed --noconfirm kitty
    cp -rf ./files/kitty/ "$CFGDIR"
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

##### zsh  & oh-my-posh #####

OH-MY-POSH() {
    cp -rf ./files/oh-my-posh/ "$CFGDIR"
}

ZSH() {
    sudo pacman -S --needed --noconfirm zsh fzf zoxide
    cp -f ./files/.zshrc "$HOME"
    sudo chsh -s /bin/zsh $USER
    sudo chsh -s /bin/zsh root
}

##### mako #####

MAKO() {
    sudo pacman -S --needed --noconfirm mako
    cp -rf ./files/mako/ "$CFGDIR"
}

##### fastfetch #####

FASTFETCH() {
    sudo pacman -S --needed --noconfirm fastfetch
    cp -rf ./files/fastfetch/ "$CFGDIR"
}

##### WirePlumber #####

PIPEWIRE() {
    sudo pacman -S --needed --noconfirm pipewire wireplumber
}

##### Persistent clipboard #####

CLIPHIST() {
    sudo pacman -S --needed --noconfirm cliphist xdg-utils
}

##### bluetooth #####

BLUETOOTH() {
    sudo pacman -S --needed --noconfirm bluez bluez-utils
    yay -S --needed --noconfirm bluetui
    systemctl enable bluetooth.service
    systemctl start bluetooth.service
}

##### Fonts #####
FONTS() {
    sudo pacman -S --needed --noconfirm extra/ttf-0xproto-nerd
}

###################
##               ##
##  MAIN SCRIPT  ##
##               ##
###################

#!/bin/bash

# Function for colored output
color_output() {
    local text=$1
    local color=$2
    case $color in
        red) echo -e "\033[31m$text\033[0m" ;;
        yellow) echo -e "\033[33m$text\033[0m" ;;
        blue) echo -e "\033[34m$text\033[0m" ;;
        *) echo "$text" ;;
    esac
}

# Function to prompt and execute
prompt_execute() {
    local function_name=$1
    local category=$2
    local color=$3
    local category_text=$(color_output "($category)" $color)
    
    if [[ "$auto_execute" != "n" && "$auto_execute" != "no" ]]; then
        echo "Executing $function_name..."
        $function_name
    else
        echo -n "Do you want to install $function_name $category_text? (Y/n): "
        read -r response
        response=${response,,} # Convert to lowercase
        if [[ "$response" != "n" && "$response" != "no" ]]; then
            echo "Executing $function_name..."
            $function_name
        else
            echo "Skipping $function_name."
        fi
    fi
}

# Main script
echo -n "Do you want to install everything without confirmation? (Y/n): "
read -r auto_execute
auto_execute=${auto_execute,,} # Convert to lowercase

# Needed packages
needed_packages=(
    YAY
    FONTS
    KITTY
    HYPRLAND
    WALLUST
)

# Recommended packages
recommended_packages=(
    WAYBAR
    ROFI
    ZSH
    OH-MY-POSH
    CLIPHIST
    MAKO
    PIPEWIRE
    HYPRPAPER
    HYPRCURSOR
)

# Optional packages
optional_packages=(
    SDDM
    HYPRLOCK
    HYPRIDLE
    HYPRPICKER
    ROFIMOJI
    FASTFETCH
    BLUETOOTH
    FUSUMA
)

# Loop through needed functions
for func in "${needed_packages[@]}"; do
    prompt_execute "$func" "needed" "red"
done

# Loop through recommended functions
for func in "${recommended_packages[@]}"; do
    prompt_execute "$func" "recommended" "yellow"
done

# Loop through optional functions
for func in "${optional_packages[@]}"; do
    prompt_execute "$func" "optional" "blue"
done
