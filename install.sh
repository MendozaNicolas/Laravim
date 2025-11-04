#!/bin/bash
set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Detectar distribución
detect_distro() {
    if [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/lsb-release ]; then
        source /etc/lsb-release
        if [[ "$DISTRIB_ID" == "Ubuntu" ]]; then
            echo "ubuntu"
        else
            echo "unknown"
        fi
    elif [ -f /etc/debian_version ]; then
        echo "ubuntu"  # Tratar Debian como Ubuntu
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

if [ "$DISTRO" == "unknown" ]; then
    print_error "Distribución no soportada. Este script funciona en Arch Linux y Ubuntu."
    exit 1
fi

print_info "Distribución detectada: $DISTRO"

# Función para instalar en Arch
install_arch() {
    print_message "Actualizando sistema (Arch)..."
    sudo pacman -Syu --noconfirm
    
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
    
    print_message "Instalando paquetes de AUR..."
    yay -S --needed --noconfirm \
        ttf-meslo-nerd-font-powerlevel10k \
        omnisharp-roslyn
}

# Función para instalar en Ubuntu
install_ubuntu() {
    print_message "Actualizando sistema (Ubuntu)..."
    sudo apt update && sudo apt upgrade -y
    
    print_message "Instalando paquetes base..."
    sudo apt install -y \
        build-essential \
        git \
        curl \
        wget \
        neovim \
        alacritty \
        ripgrep \
        fd-find \
        npm \
        nodejs \
        python3 \
        python3-pip \
        php \
        composer \
        clang \
        cmake \
        shellcheck \
        unzip
    
    # Instalar zellij manualmente
    print_message "Instalando zellij..."
    if ! command -v zellij &> /dev/null; then
        curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C /tmp
        sudo mv /tmp/zellij /usr/local/bin/
        sudo chmod +x /usr/local/bin/zellij
    fi
    
    # Instalar lazygit
    print_message "Instalando lazygit..."
    if ! command -v lazygit &> /dev/null; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp
        sudo install /tmp/lazygit /usr/local/bin
    fi
    
    # Instalar .NET SDK
    print_message "Instalando .NET SDK..."
    if ! command -v dotnet &> /dev/null; then
        wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
        sudo dpkg -i /tmp/packages-microsoft-prod.deb
        sudo apt update
        sudo apt install -y dotnet-sdk-8.0
    fi
    
    # Instalar Mono
    print_message "Instalando Mono..."
    if ! command -v mono &> /dev/null; then
        sudo apt install -y gnupg ca-certificates
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
        echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
        sudo apt update
        sudo apt install -y mono-devel mono-complete msbuild
    fi
    
    # Instalar stylua
    print_message "Instalando stylua..."
    if ! command -v stylua &> /dev/null; then
        curl -Lo /tmp/stylua.zip https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip
        unzip /tmp/stylua.zip -d /tmp
        sudo install /tmp/stylua /usr/local/bin
    fi
    
    # Instalar Nerd Font
    print_message "Instalando Nerd Font..."
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    if [ ! -f "MesloLGS_NF_Regular.ttf" ]; then
        curl -fLo "MesloLGS_NF_Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
        curl -fLo "MesloLGS_NF_Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
        curl -fLo "MesloLGS_NF_Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
        curl -fLo "MesloLGS_NF_Bold_Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
        fc-cache -fv
    fi
    cd ~
    
    # Crear enlace simbólico para fd si es necesario
    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
        sudo ln -s $(which fdfind) /usr/local/bin/fd
    fi
}

# Ejecutar instalación según la distribución
if [ "$DISTRO" == "arch" ]; then
    install_arch
elif [ "$DISTRO" == "ubuntu" ]; then
    install_ubuntu
fi

# Instalar herramientas de Python (común para ambas distros)
print_message "Instalando herramientas de Python..."
python3 -m pip install --user pynvim

# Instalar herramientas de Node.js (común para ambas distros)
print_message "Instalando LSPs y herramientas de Node.js..."
sudo npm install -g \
    intelephense \
    neovim \
    typescript \
    typescript-language-server

# Instalar OmniSharp si no está disponible en Ubuntu
if [ "$DISTRO" == "ubuntu" ] && ! command -v omnisharp &> /dev/null; then
    print_message "Instalando OmniSharp..."
    mkdir -p ~/.local/share/omnisharp
    cd ~/.local/share/omnisharp
    curl -L https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-linux-x64-net6.0.tar.gz | tar xz
    sudo ln -sf ~/.local/share/omnisharp/OmniSharp /usr/local/bin/omnisharp
    cd ~
fi

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
