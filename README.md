# 🔧 Dotfiles

**Configuration files for linux and windows environment.**
This repository hosts my personal setup for **Kali Linux (WSL)** | **Kali VMs** ** and **Windows (PowerShell )**.

![Badge](https://img.shields.io/badge/OS-Linux%20%7C%20Windows-blue) ![Badge](https://img.shields.io/badge/Shell-Zsh%20%7C%20PowerShell-green)

![Demo](/media/PS7.png)

## 📂 What's inside?

* **🐧 Linux / WSL:**
    * Optimized `.zshrc` for Kali Linux.
    * Aliases for pentesting tools (nmap, ip, extraction).
    * Hybrid integration with Windows apps (Explorer, Clip, Gemini).
* **🪟 Windows:**
    * PowerShell 7 (`$PROFILE`) configuration.
    * Nerd Fonts & Terminal Icons integration.
    * Legacy support for PowerShell 5.1.
* **⚡ Automation:**
    * Scripts to deploy the environment in seconds.

---

## 🚀 Quick Install (Automated)

### 1. For Kali Linux / WSL / VM
Installs Zsh, plugins (autosuggestions/syntax-highlighting), and essential tools (fzf, bat, zoxide).

```bash
# Clone & Install
git clone [https://github.com/VillaArreola/dotfiles.git](https://github.com/VillaArreola/dotfiles.git) ~/.dotfiles
cd ~/.dotfiles
chmod +x start.sh
./start.sh

2. For Windows (PowerShell 7)
Copy the content of windows_profile.ps1 to your PowerShell profile:

PowerShell

notepad $PROFILE
# Paste content from this repo