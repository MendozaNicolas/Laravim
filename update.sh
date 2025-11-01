#!/bin/bash

set -e

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}=== Actualizando dotfiles desde sistema ===${NC}\n"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copiar configuraciones actuales al repo
echo "Copiando configuraciones..."
cp -r ~/.config/nvim/* "$DOTFILES_DIR/nvim/" 2>/dev/null || true
cp -r ~/.config/alacritty/* "$DOTFILES_DIR/alacritty/" 2>/dev/null || true
cp -r ~/.config/zellij/* "$DOTFILES_DIR/zellij/" 2>/dev/null || true
cp ~/.zshrc "$DOTFILES_DIR/.zshrc" 2>/dev/null || true

echo -e "\n${GREEN}Dotfiles actualizados!${NC}"
echo "Ahora puedes hacer commit y push:"
echo "  cd $DOTFILES_DIR"
echo "  git add ."
echo "  git commit -m 'Update dotfiles'"
echo "  git push"
