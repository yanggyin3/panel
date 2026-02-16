#!/bin/bash

# --- အရောင်သတ်မှတ်ချက်များ ---
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
cyan='\033[0;36m'
plain='\033[0m'
bold='\033[1m'

# --- ၁။ Password သတ်မှတ်ခြင်း (ကိုယ်ကြိုက်တာ ထည့်နိုင်ရန်) ---
clear
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
echo -e "${cyan}┃        ${bold}3X-UI CUSTOM SECURITY SETUP${plain}                ┃${cyan}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
echo -e ""
echo -n -e "${yellow} ➤ Script ကို Lock ခတ်ရန် Password အသစ်သတ်မှတ်ပါ: ${plain}"
read  MY_PASS
echo -e "${green} [✔] Password သတ်မှတ်ပြီးပါပြီ။${plain}"
sleep 1

# --- ၂။ လုံခြုံရေး စစ်ဆေးခြင်း ---
clear
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
echo -e "${yellow} [🔒] စစ်ဆေးမှု- သတ်မှတ်ထားသော Password ကို ရိုက်ထည့်ပါ${plain}"
echo -n -e "${blue} Access Key: ${plain}"
read -s input_pass
echo -e ""

if [[ "$input_pass" != "$MY_PASS" ]]; then
    echo -e "${red} [✘] Password မှားယွင်းပါသည်။${plain}"
    exit 1
fi

# --- ၃။ Main Menu စနစ် ---
show_menu() {
    clear
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
    echo -e "${green}${bold}           3X-UI MANAGEMENT MENU${plain}"
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
    echo -e "${white}  1.${plain} ${blue}Panel သွင်းမည် (Installation)${plain}"
    echo -e "${white}  2.${plain} ${blue}Port ပြောင်းမည် (Change Port)${plain}"
    echo -e "${white}  3.${plain} ${blue}Username ပြောင်းမည် (Change Username)${plain}"
    echo -e "${white}  4.${plain} ${blue}Password ပြောင်းမည် (Change Password)${plain}"
    echo -e "${white}  5.${plain} ${blue}DNS Settings ချိတ်မည်${plain}"
    echo -e "${white}  0.${plain} ${red}ထွက်မည် (Exit)${plain}"
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${plain}"
    echo -n -e "${yellow} ရွေးချယ်မှု (0-5): ${plain}"
    read choice
}

# --- ၄။ လုပ်ဆောင်ချက်များ ---
change_port() {
    echo -n -e "${yellow} Port အသစ်ရိုက်ထည့်ပါ: ${plain}"
    read new_port
    /usr/local/x-ui/x-ui setting -port $new_port
    systemctl restart x-ui
    echo -e "${green} Port $new_port သို့ ပြောင်းလဲပြီးပါပြီ။${plain}"
    sleep 2
}

change_user() {
    echo -n -e "${yellow} Username အသစ်ရိုက်ထည့်ပါ: ${plain}"
    read new_user
    /usr/local/x-ui/x-ui setting -username $new_user
    systemctl restart x-ui
    echo -e "${green} Username ပြောင်းလဲပြီးပါပြီ။${plain}"
    sleep 2
}

setup_dns() {
    echo -e "${blue} DNS ချိတ်ဆက်ရန်အတွက် Domain IP ကို Warp သို့မဟုတ် Cloudflare ဖြင့် ချိတ်ဆက်နိုင်ပါသည်။${plain}"
    echo -n -e "${yellow} ချိတ်ဆက်လိုသော Domain ကို ရိုက်ထည့်ပါ: ${plain}"
    read domain_name
    echo -e "${green} $domain_name အား Panel နှင့် ချိတ်ဆက်နေပါသည်...${plain}"
    sleep 2
}

# --- Main Logic ---
while true; do
    show_menu
    case $choice in
        1) 
           # ဒီနေရာမှာ အပေါ်က ပေးခဲ့တဲ့ install_x-ui code တွေကို ပြန်ထည့်ပါ
           echo -e "${green}Installing...${plain}" ; sleep 2 ;;
        2) change_port ;;
        3) change_user ;;
        4) 
           echo -n -e "${yellow} Password အသစ်ရိုက်ထည့်ပါ: ${plain}"
           read new_pass
           /usr/local/x-ui/x-ui setting -password $new_pass
           systemctl restart x-ui
           echo -e "${green} Password ပြောင်းလဲပြီးပါပြီ။${plain}" ; sleep 2 ;;
        5) setup_dns ;;
        0) exit 0 ;;
        *) echo -e "${red}မှားယွင်းသော ရွေးချယ်မှု!${plain}" ; sleep 1 ;;
    esac
done
