#!/bin/bash
DOTFILES_DIR="$(pwd)"
set -e
clear

if ! command -v git &> /dev/null; then
    echo "Git no está instalado"
    exit 1
fi

echo "Starting installation..."
sudo pacman -S bspwm tmux polybar sxhkd open-vm-tools dunst rofi alacritty tmux ttf-jetbrains-mono-nerd alacritty git feh zsh
sleep 1
clear

echo "Configuring zsh..."
sleep 1
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
clear

echo "Configuring p10k..."
sleep 1
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
clear

echo "Configuring bspwm/polybar/alacritty/tmux..."
mkdir -p $HOME/.config
mkdir -p $HOME/Pictures
wget -O $HOME/Pictures/wallpaper.png https://raw.githubusercontent.com/dharmx/walls/refs/heads/main/weirdcore/a_cat_looking_at_the_camera.png

# Debug: mostrar qué hay en el directorio
echo "DOTFILES_DIR is: $DOTFILES_DIR"
echo "Contents:"
ls -la "$DOTFILES_DIR"
sleep 3

# Verificar que las carpetas existen antes de copiar
for dir in alacritty bspwm polybar sxhkd; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        echo "Copying $dir..."
        cp -rv "$DOTFILES_DIR/$dir" "$HOME/.config/"
    else
        echo "WARNING: $dir directory not found!"
    fi
done

cp "$DOTFILES_DIR/.tmux.conf" "$HOME/"
chmod +x "$HOME/.config/bspwm/bspwmrc"
chmod +x "$HOME/.config/polybar/launch.sh"
sleep 1

echo "Configuring blackarch repo..."
mkdir -p $HOME/blackarch
cd $HOME/blackarch
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
sleep 1
sudo pacman -Syu
sleep 1

echo "Configuring services..."
sudo systemctl enable vmtoolsd.service
sudo systemctl start vmtoolsd.service
sudo systemctl enable vmware-vmblock-fuse.service
sudo systemctl start vmware-vmblock-fuse.service
