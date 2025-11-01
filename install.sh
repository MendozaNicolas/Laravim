#!/bin/bash

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Instalador de Dotfiles ===${NC}\n"

# Función para imprimir mensajes
print_message() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Detectar si estamos en Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "Este script está diseñado para Arch Linux"
    exit 1
fi

# Actualizar sistema
print_message "Actualizando sistema..."
sudo pacman -Syu --noconfirm

# Instalar paquetes base
print_message "Instalando paquetes base..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    curl \
    wget \
    neovim \
    alacritty \
    zellij \
    ripgrep \
    fd \
    lazygit \
    npm \
    nodejs \
    python \
    python-pip \
    php \
    composer \
    clang \
    cmake \
    mono \
    mono-msbuild \
    dotnet-sdk \
    stylua \
    shellcheck

# Verificar si yay está instalado
if ! command -v yay &> /dev/null; then
    print_message "Instalando yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

# Instalar paquetes de AUR
print_message "Instalando paquetes de AUR..."
yay -S --needed --noconfirm \
    ttf-meslo-nerd-font-powerlevel10k \
    omnisharp-roslyn

# Instalar herramientas de Python
print_message "Instalando herramientas de Python..."
pip install --user pynvim

# Instalar herramientas de Node.js
print_message "Instalando LSPs y herramientas de Node.js..."
sudo npm install -g \
    intelephense \
    neovim \
    typescript \
    typescript-language-server

# Backup de configuraciones existentes
print_message "Haciendo backup de configuraciones existentes..."
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for dir in nvim alacritty zellij; do
    if [ -d "$HOME/.config/$dir" ]; then
        print_warning "Respaldando $dir..."
        mv "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
done

# Crear directorios de configuración
print_message "Creando directorios de configuración..."
mkdir -p ~/.config/{nvim,alacritty,zellij}
mkdir -p ~/.local/share/nvim

# Copiar configuraciones
print_message "Copiando configuraciones..."
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp -r "$DOTFILES_DIR/nvim/"* ~/.config/nvim/
cp -r "$DOTFILES_DIR/alacritty/"* ~/.config/alacritty/
cp -r "$DOTFILES_DIR/zellij/"* ~/.config/zellij/

# Copiar zshrc si existe
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    print_message "Copiando configuración de zsh..."
    cp "$DOTFILES_DIR/.zshrc" ~/.zshrc
fi

# Instalar LazyVim si no existe
if [ ! -d "$HOME/.config/nvim/lua/lazy.nvim" ]; then
    print_message "Instalando LazyVim..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
fi

# Dar permisos de ejecución a scripts personalizados si existen
if [ -d "$DOTFILES_DIR/scripts" ]; then
    print_message "Configurando scripts personalizados..."
    chmod +x "$DOTFILES_DIR/scripts/"*.sh 2>/dev/null || true
fi

print_message "Instalación completada!"
echo -e "\n${GREEN}Siguiente paso:${NC}"
echo "1. Abre Neovim con 'nvim' y espera a que se instalen los plugins"
echo "2. Ejecuta :checkhealth para verificar la instalación"
echo "3. Tus configuraciones antiguas están en: $BACKUP_DIR"
echo -e "\n${YELLOW}Nota:${NC} Puede que necesites reiniciar la terminal para que algunos cambios tomen efecto"
