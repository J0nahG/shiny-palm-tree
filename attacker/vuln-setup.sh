#!/bin/bash
# Simple bash script to configure the system for some privesc vulnerabilities
# Sp3ctre4
# October 07, 2026


script_dir=/usr/share/scripts

# sudo check
if [ $(id -u) -ne 0 ]; then
    echo "Error: script must be run as root." >&2
    exit 1
fi

# Add user accounts
# jeremy    appleseed
# jessamy   blueberry
# judah     123456

func_createuser() {
    id $1
    if [ $? -eq 0 ]; then
        echo "[*] User $1 already exists."
        return
    fi

    useradd -m -s /bin/bash "$1"
    if [ $? -ne 0 ]; then
        echo "[-] Failed to create user $1"
        return
    fi

    echo "$1:$2" | chpasswd
    if [ $? -ne 0 ]; then
        echo "[-] Failed to change password for $2"
        userdel -r "$1"
        return
    fi

    echo "[+] $1:$2 created successfully."
    exit 0
}

func_createuser jeremy appleseed
func_createuser jessamy blueberry
func_createuser judah 123456

# Setup vulnerable root script
if [[ ! -d $script_dir ]]; then
    mkdir $script_dir
    echo "[+] $script_dir created"
else
    echo "[*] $script_dir already exists"
fi

echo """IyEvYmluL2Jhc2gKCiMgU2hpbnkgUGFsbSBUcmVlIFJlc29ydHMgLSBOZXR3b3JrIFN0YXR1cyBD
aGVjawojIFBpbmdzIGVhY2ggbWFjaGluZSBvbmNlIGFuZCBsb2dzIHRoZSByZXN1bHQuCiMgU2Vw
dGVtYmVyIDE0LCAyMDA0CgpMT0dfRklMRT0iL3RtcC9zaGlueV9wYWxtX3RyZWVfcmVzb3J0c19w
aW5nLmxvZyIKCiMgTGlzdCBvZiBtYWNoaW5lcyB0byBjaGVjawpNQUNISU5FUz0oCiAgICAiMTky
LjE2OC4xLjEwIgogICAgIjE5Mi4xNjguMS4yMCIKICAgICIxOTIuMTY4LjEuMzAiCiAgICAicGFs
bURDIgogICAgInBhbG1TUUwiCikKCmVjaG8gIj09PT09IFNoaW55IFBhbG0gVHJlZSBSZXNvcnRz
IE5ldHdvcmsgU3RhdHVzIENoZWNrID09PT09IiA+ICIkTE9HX0ZJTEUiCmVjaG8gIkRhdGU6ICQo
ZGF0ZSkiID4+ICIkTE9HX0ZJTEUiCmVjaG8gPj4gIiRMT0dfRklMRSIKCmZvciBNQUNISU5FIGlu
ICIke01BQ0hJTkVTW0BdfSI7IGRvCiAgICBpZiBwaW5nIC1jIDEgLVcgMiAiJE1BQ0hJTkUiID4g
L2Rldi9udWxsIDI+JjE7IHRoZW4KICAgICAgICBlY2hvICIkTUFDSElORTogT05MSU5FIiA+PiAi
JExPR19GSUxFIgogICAgZWxzZQogICAgICAgIGVjaG8gIiRNQUNISU5FOiBPRkZMSU5FIiA+PiAi
JExPR19GSUxFIgogICAgZmkKZG9uZQoKZWNobyA+PiAiJExPR19GSUxFIgplY2hvICJDaGVjayBj
b21wbGV0ZWQ6ICQoZGF0ZSkiID4+ICIkTE9HX0ZJTEUiCgplY2hvICJOZXR3b3JrIGNoZWNrIGNv
bXBsZXRlLiBSZXN1bHRzIHNhdmVkIHRvICRMT0dfRklMRSIK""" > /tmp/tmp0756.txt
base64 -d /tmp/tmp0756.txt > $script_dir/db-backup.sh
rm /tmp/tmp0756.txt
echo "[+] db-backup.sh created"

chmod 777 $script_dir/db-backup.sh
echo "[+] script permissions modified"

# Edit Crontab
cat /etc/crontab | grep db-backup.sh
if [ $? -eq 1 ]; then
    echo "* * * * * root $script_dir/db-backup.sh" >> etc/crontab
    echo "[+] Crontab modified"
else
    echo "[*] Crontab already modified"
fi

# set desktop background
gsettings set org.gnome.desktop.background picture-uri "file:///home/user/bg-old.jpg"
#echo "[+] Desktop bg set?"

echo "[+] Complete!"
