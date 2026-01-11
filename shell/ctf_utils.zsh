# ==========================================
#  Inicio y configuración de entornos CTF

# --- CONFIGURATION (EDIT THIS) ---
# Define tus rutas absolutas aquí
VPN_PATH_HTB="$HOME/MEGA/VPN/HTBVPN.ovpn"
VPN_PATH_CYBER="$HOME/MEGA/VPN/CyberVPN.ovpn"
VPN_PATH_THM="$HOME/MEGA/VPN/THMVPN.ovpn"

# Carpeta base donde guardarás los archivos de los CTFs
BASE_WORK_DIR="$HOME/MEGA"

# ------------------------------------------
# 1. setear y mostrar Target en el panel de kali
# ------------------------------------------
function ip-target() {
    local TARGET_FILE="$HOME/.config/target_ip"  #necesaria para mostrar en el panel de kali

    if [ "$1" = "clear" ]; then
        unset TARGET
        rm -f "$TARGET_FILE" # eliminar archivo si existe
        echo "[-] Target eliminado."
    elif [ -z "$1" ]; then
        if [ -z "$TARGET" ]; then
            echo "[!] No hay target configurado."
        else
            echo "[*] $TARGET"
        fi
    else
        export TARGET=$1
        echo "[+] Target fijado a: $TARGET"
        echo "$TARGET" > "$TARGET_FILE"  # Guardar en archivo para mostrar en el panel de kali
    fi
}

# ------------------------------------------
# 2. Iniciar/Detener VPN
# ------------------------------------------
function vpn() {
    local ACTION=$1
    local PLATFORM=$2
    local TARGET_FILE=""
    local NAME=""

    # --- OFF ---
    if [ "$ACTION" = "off" ]; then
        echo "[*] Matando procesos OpenVPN..."
        sudo killall openvpn
        echo "[-] VPN detenida."
        return
    fi

    # --- ON ---
    if [ "$ACTION" = "on" ]; then
        case "$PLATFORM" in
            "htb")   TARGET_FILE="$VPN_PATH_HTB"; NAME="Hack The Box" ;;
            "cyber") TARGET_FILE="$VPN_PATH_CYBER"; NAME="Cyber" ;;
            "thm")   TARGET_FILE="$VPN_PATH_THM"; NAME="TryHackMe" ;;
            *) echo "[!] Error: Usa 'htb', 'cyber' o 'thm'"; return ;;
        esac

        if [ ! -f "$TARGET_FILE" ]; then
            echo "[!] No encuentro el archivo: $TARGET_FILE"
            echo "    Revisa la configuración al inicio del script."
            return
        fi

        echo "[*] Conectando a $NAME..."
        sudo openvpn --config "$TARGET_FILE" --daemon

        # Bucle de espera
        echo -n "[*] Esperando asignación de IP"
        for i in {1..15}; do
            if ip addr show tun0 > /dev/null 2>&1; then
                break
            fi
            echo -n "."
            sleep 1
        done
        echo "" 

        # Verificación
        if ip addr show tun0 > /dev/null 2>&1; then
            local MY_IP=$(ip -f inet addr show tun0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
            
            echo "========================================"
            echo " [+] CONEXIÓN EXITOSA"
            echo "========================================"
            echo " -> Interfaz:   tun0"
            echo " -> Tu IP:      $MY_IP"
            echo "========================================"
            
            if command -v xclip &> /dev/null; then
                echo -n "$MY_IP" | xclip -selection clipboard
                echo " (IP copiada al portapapeles)"
            fi
        else
            echo "[!] Error: OpenVPN arrancó, pero tun0 no responde."
        fi
        return
    fi
    
    echo "Uso: vpn on [htb|cyber|thm] | vpn off"
}

# ------------------------------------------
# 3. ALIAS ÚTILES
# ------------------------------------------
alias png="ping -c 3 \$TARGET"

# ------------------------------------------
# 4. Satrt CTF version anterior 
# ------------------------------------------
function startctf() {
    local PLATFORM=$1
    local NAME=$2
    local IP=$3

    if [[ -z "$PLATFORM" || -z "$NAME" || -z "$IP" ]]; then
        echo "Uso: startctf <plataforma> <nombre> <IP>"
        echo "Ej:  startctf htb Sherlock 10.10.11.123"
        return 1
    fi

    echo "[*] Verificando conectividad..."
    if ! ping -c 1 -W 2 "$IP" &>/dev/null; then
        echo -e "\e[1;31m❌ El Target $IP no responde. (¿VPN encendida?)\e[0m"
        return 1
    fi

    # Llama a la función ip-target
    ip-target $IP

    local CTF_DIR="$BASE_WORK_DIR/$PLATFORM/$NAME"
    echo "[*] Creando estructura en: $CTF_DIR"
    mkdir -p "$CTF_DIR"/{files,scripts,nmap}
    
    touch "$CTF_DIR/notes.md" "$CTF_DIR/users.txt" "$CTF_DIR/passwd.txt"

    echo -e "🛰 Lanzando Nmap (Background)... \e[1;36m$CTF_DIR/nmap/scan\e[0m"
    (nmap -sC -sV -T4 -oA "$CTF_DIR/nmap/scan" "$IP" &>/dev/null && echo -e "\n\e[1;32m✅ Escaneo Nmap completado para $NAME\e[0m" &) &

    echo -e "\e[1;32m✅ Entorno listo.\e[0m"
    
    echo -n "$CTF_DIR/nmap" | xclip -selection clipboard
    echo "📋 Ruta de nmap copiada al portapapeles."
    
    cd "$CTF_DIR"
    tree --noreport "$CTF_DIR" 2>/dev/null || ls -R "$CTF_DIR"
}