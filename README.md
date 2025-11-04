# Mis Dotfiles

Configuración personalizada para desarrollo en PHP (Laravel), C, C++ y C# (Unity).

## Compatibilidad

✅ **Arch Linux**  
✅ **Ubuntu / Debian**

El script de instalación detecta automáticamente tu distribución y configura los paquetes apropiados.

## Stack

- **Terminal**: Alacritty + Zellij
- **Editor**: Neovim con LazyVim
- **Shell**: Zsh
- **Lenguajes**: PHP, C, C++, C#

## Instalación rápida
```bash
git clone https://github.com/nmendoza/laravim.git ~/laravim
cd ~/laravim
chmod +x install.sh
./install.sh
```

El script instalará automáticamente:
- Todas las dependencias necesarias según tu distribución
- LSPs (Intelephense, TypeScript, OmniSharp)
- Herramientas de desarrollo (LazyGit, Ripgrep, fd)
- Nerd Fonts para iconos en la terminal
- Configuraciones de Neovim, Alacritty y Zellij

## Instalación manual

### Dependencias en Arch Linux
```bash
sudo pacman -S neovim alacritty zellij git nodejs npm php composer clang cmake mono dotnet-sdk
yay -S ttf-meslo-nerd-font-powerlevel10k omnisharp-roslyn
sudo npm install -g intelephense typescript-language-server
```

### Dependencias en Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y build-essential git curl wget neovim alacritty ripgrep fd-find \
                    npm nodejs python3 python3-pip php composer clang cmake shellcheck unzip

# Instalar zellij
curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz
sudo mv zellij /usr/local/bin/

# Instalar lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz
sudo install lazygit /usr/local/bin

# Instalar .NET SDK y Mono
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-8.0 mono-devel mono-complete msbuild

# LSPs
sudo npm install -g intelephense typescript-language-server
```

### Configuraciones
```bash
cp -r nvim ~/.config/
cp -r alacritty ~/.config/
cp -r zellij ~/.config/
```

## Verificación post-instalación

Después de instalar, verifica que todo esté funcionando correctamente:
```bash
# Abre Neovim
nvim

# Dentro de Neovim, ejecuta:
:checkhealth
```

Esto verificará que todos los LSPs y dependencias estén correctamente instalados.

## Keybindings principales

### Neovim
- `<leader>` = espacio
- `<leader>ff` - Buscar archivos
- `<leader>e` - File explorer
- `<leader>la` - Laravel Artisan
- `<leader>lg` - LazyGit

### Zellij
- `Ctrl+p c` - Nuevo panel
- `Ctrl+p n` - Nueva pestaña
- `Ctrl+q` - Salir

## Estructura
```
laravim/
├── nvim/           # Configuración de Neovim + LazyVim
├── alacritty/      # Configuración de Alacritty
├── zellij/         # Configuración de Zellij
├── scripts/        # Scripts útiles
├── install.sh      # Script de instalación automática
└── README.md       # Este archivo
```

## Actualizar dotfiles
```bash
cd ~/laravim
git pull
./install.sh
```

**Nota:** El script hace un backup automático de tus configuraciones existentes en `~/.config_backup_[fecha]` antes de aplicar los cambios.

## Soporte para lenguajes

### PHP (Laravel)
- LSP: Intelephense
- Autocompletado inteligente
- Navegación de código
- Comandos Artisan integrados

### C/C++
- LSP: clangd
- CMake integration
- Debugging con GDB

### C# (Unity)
- LSP: OmniSharp
- Soporte para .NET 8.0
- Integración con Mono

## Solución de problemas

### El comando `fd` no funciona en Ubuntu
```bash
sudo ln -s $(which fdfind) /usr/local/bin/fd
```

### Neovim no muestra iconos correctamente
Asegúrate de que tu terminal esté usando la Nerd Font instalada (MesloLGS NF).

### LSP no funciona
```bash
# Dentro de Neovim
:Mason
# Reinstala los LSPs necesarios desde la interfaz de Mason
```

## Contribuir

Si encuentras algún problema o tienes sugerencias, no dudes en abrir un issue o pull request.

## Licencia

MIT
