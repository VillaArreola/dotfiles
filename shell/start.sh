#!/bin/bash

# ==========================================
#  KALI LINUX SETUP SCRIPT (WSL & VM READY)
#  By: Gemini for Villa
# ==========================================

echo -e "\e[1;32m[+] Iniciando configuración del entorno Hacking/Dev...\e[0m"

# 1. Actualizar repositorios e instalar dependencias BASE
echo -e "\e[1;34m[*] Instalando paquetes esenciales ...\e[0m"
sudo apt update && sudo apt install -y \
    zsh \
    git \
    curl \
    wget \
    unzip \
    zoxide \
    fzf \
    plocate \
    fd-find \
    bat \
    lsd \
    net-tools \
    iproute2 \
    python3-pip

# 2. Instalar Plugins de ZSH (Autosuggestions & Syntax Highlighting)
echo -e "\e[1;34m[*] Instalando plugins de ZSH...\e[0m"
ZSH_PLUGINS="/usr/share"

# Autosuggestions
if [ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]; then
    sudo git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS/zsh-autosuggestions
else
    echo "  -> zsh-autosuggestions ya instalado."
fi

# Syntax Highlighting
if [ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting
else
    echo "  -> zsh-syntax-highlighting ya instalado."
fi

# 3. Detección de Entorno (WSL vs VM)
if grep -q "Microsoft" /proc/version; then
    echo -e "\e[1;33m[!] Entorno WSL detectado.\e[0m"
    echo "    -> Saltando instalación de fuentes (Linux usa las de Windows)."
    echo "    -> Recuerda configurar 'Hack Nerd Font' en Windows Terminal."
else
    echo -e "\e[1;33m[!] Entorno VM/Nativo detectado.\e[0m"
    echo "    -> Descargando e instalando Hack Nerd Font..."
    
    mkdir -p ~/.local/share/fonts
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip -O Hack.zip
    unzip -o -q Hack.zip -d Hack_Font
    mv Hack_Font/*.ttf ~/.local/share/fonts/
    rm -rf Hack_Font Hack.zip
    
    echo "    -> Actualizando caché de fuentes..."
    fc-cache -fv > /dev/null
    echo "    -> Fuentes instaladas."
fi

# 4. Cambiar Shell a ZSH
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "zsh" ]; then
    echo -e "\e[1;34m[*] Cambiando shell por defecto a ZSH...\e[0m"
    chsh -s $(which zsh)
else
    echo "  -> Ya estás usando ZSH."
fi

# 5. Mensaje Final
echo -e "\e[1;32m[OK] Instalación completada.\e[0m"
echo -e "\e[1;37m--------------------------------------------------------\e[0m"
echo -e "PASOS SIGUIENTES:"
echo -e "1. Copia tu archivo .zshrc correspondiente (WSL o VM) a ~/.zshrc"
echo -e "2. Ejecuta: source ~/.zshrc"
echo -e "\e[1;37m--------------------------------------------------------\e[0m"