#!/bin/bash
# hello world in network sniffing by ChillerDragon
# this script is used to track wrong passwords of tees who connect to a teeworlds server running on localhost:$port
# it displays the random network datat and the password in plaintext (some seconds delay)

port=8303

if [ $# -eq 1 ]
then
    port=$1
fi

function install_brew() {
    command -v brew >/dev/null 2>&1 || {
        echo "to install figlet you need brew"
        echo "do you want to install brew? [y/N]"
        read -r -n 1 yn
        echo ""
        if [[ "$yn" =~ [yY] ]]
        then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        echo "Error: brew not found."
        exit 1
    }
}

function install_tcpdump() {
    if [[ "$OSTYPE" == "linux-gnu" ]]
    then
        echo "do you want to install tcpdump? [y/N]"
        read -r -n 1 yn
        echo ""
        if [[ "$yn" =~ [yY] ]]
        then
            sudo apt install tcpdump
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]
    then
        echo "do you want to install tcpdump? [y/N]"
        read -r -n 1 yn
        echo ""
        if [[ "$yn" =~ [yY] ]]
        then
            install_brew
            brew install tcpdump
        fi
    fi
    command -v tcpdump >/dev/null 2>&1 || {
        echo "Error: tcpdump not found."
        exit 1
    }
}

tcpdp=tcpdump

function check_tcp() {
    command -v $tcpdp >/dev/null 2>&1 || {
        command -v sudo $tcpdp >/dev/null 2>&1 || {
            install_tcpdump
        }
        tcpdp="sudo $tcpdp"
    }
}

check_tcp

echo "============ teeworlds net sniffing ============"
echo " tool by ChillerDragon"
echo "================================================"
echo "waiting for wrong password attempts on $port..."
echo "================================================"

# $tcpdp -vvnnXSs 1514 -p udp $port | grep -B 10 "Wrong.password."
$tcpdp -A -p udp port $port | grep "...0.6.626fce9a7"
