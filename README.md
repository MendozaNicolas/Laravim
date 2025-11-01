# Mis Dotfiles

Configuración personalizada para desarrollo en PHP (Laravel), C, C++ y C# (Unity).

## Stack

- **Terminal**: Alacritty + Zellij
- **Editor**: Neovim con LazyVim
- **Shell**: Zsh
- **Lenguajes**: PHP, C, C++, C#

## Instalación rápida
```bash
git clone https://github.com/TU_USUARIO/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Instalación manual

### Dependencias
```bash
sudo pacman -S neovim alacritty zellij git nodejs npm php composer clang cmake
yay -S ttf-meslo-nerd-font-powerlevel10k omnisharp-roslyn
sudo npm install -g intelephense
```

### Configuraciones
```bash
cp -r nvim ~/.config/
cp -r alacritty ~/.config/
cp -r zellij ~/.config/
```

## Keybindings principales

### Neovim
- `<leader>` = espacio
- `<leader>ff` - Buscar archivos
- `<leader>e` - File explorer
- `<leader>la` - Laravel Artisan

### Zellij
- `Ctrl+p c` - Nuevo panel
- `Ctrl+p n` - Nueva pestaña
- `Ctrl+q` - Salir

## Estructura
```
dotfiles/
├── nvim/           # Configuración de Neovim
├── alacritty/      # Configuración de Alacritty
├── zellij/         # Configuración de Zellij
├── scripts/        # Scripts útiles
├── install.sh      # Script de instalación automática
└── README.md       # Este archivo
```

## Actualizar dotfiles
```bash
cd ~/dotfiles
git pull
./install.sh
```
