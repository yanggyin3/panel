楤·Jᴇsᴛɪɴ℠, [2/16/2026 11:09 PM]
#!/bin/bash

# --- Color Definitions ---
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
purple='\033[0;35m'
cyan='\033[0;36m'
plain='\033[0m'
bold='\033[1m'

cur_dir=$(pwd)
xui_folder="${XUI_MAIN_FOLDER:=/usr/local/x-ui}"
xui_service="${XUI_SERVICE:=/etc/systemd/system}"

# --- 1. ဒီဇိုင်းလှလှလေးနဲ့ Password Lock အပိုင်း ---
MY_PASS="112233" # <--- ဒီမှာ Password ပြောင်းပါ

clear
echo -e "${cyan}==================================================${plain}"
echo -e "${purple}${bold}       3X-UI PREMIUM PANEL INSTALLER             ${plain}"
echo -e "${cyan}==================================================${plain}"
echo -e ""
echo -e "${yellow} [🔒] SECURITY CHECK: ADMIN ONLY${plain}"
echo -n -e "${blue} Enter Secret Access Key: ${plain}"
read -s input_pass
echo -e ""

if [[ "$input_pass" != "$MY_PASS" ]]; then
    echo -e "${red} [✘] Access Denied: Incorrect Password!${plain}"
    exit 1
fi

echo -e "${green} [✔] Identity Verified! Initializing...${plain}"
sleep 1

# --- 2. Root နဲ့ OS စစ်ဆေးခြင်း ---
[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error: ${plain} Please run this script with root privilege \n " && exit 1

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

# --- 3. Port စစ်ဆေးတဲ့ Function ---
is_port_in_use() {
    local port="$1"
    if command -v ss >/dev/null 2>&1; then
        ss -ltn 2>/dev/null | awk -v p=":${port}$" '$4 ~ p {exit 0} END {exit 1}'
        return
    fi
    netstat -lnt 2>/dev/null | awk -v p=":${port} " '$4 ~ p {exit 0} END {exit 1}'
}

# --- 4. Base Packages သွင်းခြင်း ---
install_base() {
    echo -e "${blue}Installing basic packages...${plain}"
    case "${release}" in
        ubuntu | debian) apt-get update && apt-get install -y -q curl tar tzdata socat ca-certificates ;;
        centos) yum install -y curl tar tzdata socat ca-certificates ;;
        *) apt-get update && apt-get install -y -q curl tar tzdata socat ca-certificates ;;
    esac
}

# --- 5. Panel Configuration (Port & Design) ---
config_after_install() {
    # Port ရွေးချယ်ခြင်း (Port လွတ်မလွတ်ပါ စစ်ပေးမည်)
    while true; do
        echo -e ""
        echo -e "${cyan}┌─────────────── NETWORK SETUP ───────────────┐${plain}"
        echo -n -e "${yellow} Enter Panel Port (Default 2053): ${plain}"
        read config_port
        [[ -z "${config_port}" ]] && config_port=2053
        
        if is_port_in_use "${config_port}"; then
            echo -e "${red} [!] Port ${config_port} is already in use! Try another.${plain}"
        else
            break
        fi
    done

    # Random Credentials ထုတ်ပေးခြင်း
    config_username=$(LC_ALL=C tr -dc 'a-z' </dev/urandom | fold -w 8 | head -n 1)
    config_password=$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | fold -w 12 | head -n 1)
    config_webBasePath=$(LC_ALL=C tr -dc 'a-z' </dev/urandom | fold -w 10 | head -n 1)

    # Panel ထဲသို့ သတ်မှတ်ချက်များ ထည့်ခြင်း
    ${xui_folder}/x-ui setting -username "${config_username}" -password "${config_password}" -port "${config_port}" -webBasePath "${config_webBasePath}"
    
    # IP ယူခြင်း
    server_ip=$(curl -s https://api4.ipify.org)

    # နောက်ဆုံး ပိတ် ဒီဇိုင်းလှလှလေးနဲ့ ပြသခြင်း
    clear
    echo -e "${green}┌──────────────────────────────────────────────────┐${plain}"
    echo -e "${green}│        🚀 3X-UI DEPLOYMENT SUCCESSFUL!           │${plain}"
    echo -e "${green}└──────────────────────────────────────────────────┘${plain}"
    echo -e ""
    echo -e "  ${bold}ADMIN PANEL DETAILS:${plain}"
    echo -e "  ${cyan}------------------------------------${plain}"
    echo -e "  ${blue}Username    :${plain} ${yellow}${config_username}${plain}"

楤·Jᴇsᴛɪɴ℠, [2/16/2026 11:09 PM]
echo -e "  ${blue}Password    :${plain} ${yellow}${config_password}${plain}"
    echo -e "  ${blue}Port        :${plain} ${yellow}${config_port}${plain}"
    echo -e "  ${blue}WebBasePath :${plain} ${yellow}/${config_webBasePath}${plain}"
    echo -e "  ${cyan}------------------------------------${plain}"
    echo -e ""
    echo -e "  ${bold}ACCESS URL:${plain}"
    echo -e "  ${blue}http://${server_ip}:${config_port}/${config_webBasePath}${plain}"
    echo -e ""
    echo -e "${red}  ⚠️  Please save this information safely!${plain}"
    echo -e "${cyan}==================================================${plain}"
}

# --- 6. Installation Main Logic ---
# (မူရင်း script ထဲက install_x-ui အပိုင်းကို ဒီမှာ အကျဉ်းချုပ် ထည့်ထားပါတယ်)
install_x-ui() {
    # ဒီနေရာမှာ သင့်ရဲ့ မူရင်း ဒေါင်းလုဒ်ဆွဲတဲ့ code တွေ ရှိပါမယ်
    echo -e "${blue}Downloading and Extracting 3x-ui...${plain}"
    # ... (မူရင်း script ထဲက binary ဒေါင်းတဲ့ code အပိုင်း) ...
    
    # ပြီးရင် config ကို ခေါ်ပါမယ်
    config_after_install
}

# စတင် Run ခြင်း
install_base
install_x-ui
