楤·Jᴇsᴛɪɴ℠, [2/16/2026 11:29 PM]
#!/bin/bash

# --- အရောင်နှင့် ဒီဇိုင်း Toolkit ---
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
purple='\033[0;35m'
cyan='\033[0;36m'
plain='\033[0m'
bold='\033[1m'

# --- ၁။ Password Lock & Header ဒီဇိုင်း ---
MY_PASS="112233" # <--- သင်ထားချင်တဲ့ Password ကို ဒီမှာ ပြောင်းပါ

clear
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
echo -e "${purple}${bold}       3X-UI PREMIUM PANEL INSTALLER v2.0            ${plain}"
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
echo -e ""
echo -e "${yellow} [🔒] SECURITY CHECK: AUTHORIZED ACCESS ONLY${plain}"
echo -n -e "${blue} Enter Secret Access Key: ${plain}"
read -s input_pass
echo -e ""

if [[ "$input_pass" != "$MY_PASS" ]]; then
    echo -e ""
    echo -e "${red} [✘] Access Denied: Incorrect Password!${plain}"
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
    exit 1
fi

echo -e "${green} [✔] Identity Verified! Initializing...${plain}"
sleep 1

# --- ၂။ ပတ်ဝန်းကျင် စစ်ဆေးခြင်း ---
cur_dir=$(pwd)
xui_folder="${XUI_MAIN_FOLDER:=/usr/local/x-ui}"
xui_service="${XUI_SERVICE:=/etc/systemd/system}"

# root check
[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error: ${plain} Please run this script with root privilege \n " && exit 1

# Check OS
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    release=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    release=$ID
else
    echo "Failed to check the system OS!" >&2
    exit 1
fi

arch() {
    case "$(uname -m)" in
        x86_64 | x64 | amd64) echo 'amd64' ;;
        i*86 | x86) echo '386' ;;
        armv8* | armv8 | arm64 | aarch64) echo 'arm64' ;;
        armv7* | armv7 | arm) echo 'armv7' ;;
        *) echo -e "${red}Unsupported CPU architecture!${plain}" && exit 1 ;;
    esac
}

# Port Check Function
is_port_in_use() {
    local port="$1"
    if command -v ss >/dev/null 2>&1; then
        ss -ltn 2>/dev/null | awk -v p=":${port}$" '$4 ~ p {exit 0} END {exit 1}'
        return
    fi
    netstat -lnt 2>/dev/null | awk -v p=":${port} " '$4 ~ p {exit 0} END {exit 1}'
}

# --- ၃။ Base Installation ---
install_base() {
    echo -e "${blue}Installing basic packages...${plain}"
    case "${release}" in
        ubuntu | debian) apt-get update && apt-get install -y -q curl tar tzdata socat ca-certificates ;;
        centos | rocky | almalinux) dnf install -y -q curl tar tzdata socat ca-certificates ;;
        *) apt-get update && apt-get install -y -q curl tar tzdata socat ca-certificates ;;
    esac
}

# --- ၄။ Configuration & UI Details ---
config_after_install() {
    echo -e ""
    echo -e "${cyan}┌─────────────── CONFIGURATION ───────────────┐${plain}"
    
    # Port Selection with Checker
    while true; do
        echo -n -e "${yellow} ➤ Enter Panel Port (Default 2053): ${plain}"
        read config_port
        [[ -z "${config_port}" ]] && config_port=2053
        
        if is_port_in_use "${config_port}"; then
            echo -e "${red} [!] Port ${config_port} is already in use! Try another.${plain}"
        else
            echo -e "${green} [✔] Port ${config_port} is available.${plain}"
            break
        fi
    done

    # Random Credentials
    config_username=$(LC_ALL=C tr -dc 'a-z' </dev/urandom | fold -w 8 | head -n 1)
    config_password=$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | fold -w 12 | head -n 1)
    config_webBasePath=$(LC_ALL=C tr -dc 'a-z' </dev/urandom | fold -w 10 | head -n 1)

    # Apply Settings
    ${xui_folder}/x-ui setting -username "${config_username}" -password "${config_password}" -port "${config_port}" -webBasePath "${config_webBasePath}"
    
    # Get IP
    server_ip=$(curl -s https://api4.ipify.org)

    # FINAL BEAUTIFUL UI
    clear

楤·Jᴇsᴛɪɴ℠, [2/16/2026 11:29 PM]
echo -e "${green}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${plain}"
    echo -e "${green}┃        🚀 3X-UI DEPLOYMENT SUCCESSFUL!             ┃${plain}"
    echo -e "${green}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${plain}"
    echo -e ""
    echo -e "  ${bold}PANEL ACCESS DETAILS:${plain}"
    echo -e "  ${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
    echo -e "  ${blue}Username    :${plain} ${yellow}${config_username}${plain}"
    echo -e "  ${blue}Password    :${plain} ${yellow}${config_password}${plain}"
    echo -e "  ${blue}Port        :${plain} ${yellow}${config_port}${plain}"
    echo -e "  ${blue}Web Path    :${plain} ${yellow}/${config_webBasePath}${plain}"
    echo -e "  ${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
    echo -e ""
    echo -e "  ${bold}ACCESS URL:${plain}"
    echo -e "  ${blue}${bold}http://${server_ip}:${config_port}/${config_webBasePath}${plain}"
    echo -e ""
    echo -e "${red}  ⚠️  Please save these details securely!${plain}"
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
}

# --- ၅။ Installation Main Logic ---
install_x-ui() {
    cd /usr/local/
    tag_version=$(curl -Ls "https://api.github.com/repos/MHSanaei/3x-ui/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    echo -e "Latest version: ${tag_version}. Downloading..."
    
    curl -4fLRo x-ui-linux-$(arch).tar.gz https://github.com/MHSanaei/3x-ui/releases/download/${tag_version}/x-ui-linux-$(arch).tar.gz
    
    if [[ -e ${xui_folder}/ ]]; then
        systemctl stop x-ui 2>/dev/null
        rm ${xui_folder}/ -rf
    fi
    
    tar zxvf x-ui-linux-$(arch).tar.gz
    rm x-ui-linux-$(arch).tar.gz -f
    cd x-ui
    chmod +x x-ui bin/xray-linux-$(arch)
    
    # Setup Systemd Service
    curl -4fLRo ${xui_service}/x-ui.service https://raw.githubusercontent.com/MHSanaei/3x-ui/main/x-ui.service.debian
    systemctl daemon-reload
    systemctl enable x-ui
    systemctl start x-ui
    
    config_after_install
}

# Run
install_base
install_x-ui
