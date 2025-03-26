#!/bin/bash

#   --Chris Trimble GNU GPLv3 2023--

##Run this on your client (PC), and refer to README.md for details
##Help/options function
Help()
{
    echo ""
    echo "Syntax: ./ssh-key-builder.sh [-h|-l|-v]"
    echo "Options:"
    echo "l     Display license."
    echo "h     Print this Help."
#    echo "n    Name of SSH Key."
#    echo "d    Don't export key to server, only create."
#    echo ""
    echo "v     Print software version and exit."
#    echo ""
}

License()
{
    echo "This program is licensed under GNU GPL v3."
    echo "The license can be read in full here:"
    echo "https://github.com/Trimble-tech/SSH-Key-Builder/blob/main/LICENSE"
    echo ""
}

Version()
{
    echo "Version 1.2"
}

##Handle the Help options so they work...
while getopts ":hlv" option; do
    case $option in
        h) # display Help
            Help
            exit;;

            l) # display licensing
            License
            exit;;

            v) #display version
            Version
            exit;;

            \?) ##Catch all other options/statements
            echo "Error: Invalid option."
            echo "Consult help with: './ssh-key-builder.sh -h'"
            exit;;
        esac
done

##Look at current keys
ls -a ~/.ssh
echo "Your current keys (if any) reside here."
echo "Pick a new name for your key so you don't overwrite an important one."
##Readability delay
sleep 2

##Create the keys, defining key as variable for script to automate import
echo "Creating key..."
read -r -p "Enter the name of your new key:" filename

##Makes sure key is built in correct folder
ssh-keygen -f ~/.ssh/"${filename}"

##Define login string as variable to work with script
echo "Now that you have created a key it can be imported to the server."

read -r -p "Enter the username to use in SSH (like dietpi):" username
read -r -p "Enter the server IP Address (like 192.168.101.201):" IP

echo "The default port for SSH is 22."

##Added support for custom SSH ports
while true; do
    read -r -p "Are you using a port different than 22 on your server? [Y/N] " yn
        case $yn in
        [Yy]* ) read -r -p "Enter your port here:" port && break;;
        [Nn]* ) echo "Okay, we are using port 22 then." && port="22" && break ;;
        * ) echo "If you are unsure, you probably use port 22." ;;
    esac
done

identity="${username}@$IP"

##Added support for Dropbear servers
##OpenSSH uses ssh-copy-id, Dropbear is manual since ssh-copy-id on Dropbear uses OpenWRT defaults
while true; do
    read -r -p "Is your server using OpenSSH or Dropbear? [O/D] " od
        case $od in
        [Oo]* ) 
                echo "Copying your key to the server..."
                ##Copies key with set parameters
                ssh-copy-id -i ~/.ssh/"${filename}".pub -p "$port" "$identity"
                echo "Done."

                ##Extra check for correct permissions, creates extra login prompt but worth it...
                echo "Configuring host server..."
                ssh -p "$port" "$identity" "sudo chmod 700 ~/.ssh; sudo chmod 600 ~/.ssh/authorized_keys; sudo chown ${username}:${username} ~/.ssh/authorized_keys"
                echo "Done."

                ##Creates/adds to client ssh config file so key is correctly used
                echo "Configuring client..."
                echo "Host ${IP}">>~/.ssh/config
                echo "IdentityFile ~/.ssh/${filename}">>~/.ssh/config
                echo "Port ${port}">>~/.ssh/config
                echo "Done."
                break;;

        [Dd]* )
                ##I could use ssh -p *once* here, but then troubleshooting/reading would be rather difficult...
                ##End result is clean but requires 2 connections to be made
                ##Thanks to Dietpi's Joulinar & trendy for support

                ##Move public key to Dropbear server
                ssh -p "$port" "$identity" "mkdir -p ~/.ssh; tee -a ~/.ssh/authorized_keys" < ~/.ssh/"${filename}".pub

                ##Set the correct permissions for Dropbear server to accept keys as valid
                ssh -p "$port" "$identity" "sudo chmod 700 ~/.ssh; sudo chmod 600 ~/.ssh/authorized_keys; sudo chown ${username}:${username} ~/.ssh/authorized_keys"

                ##Make config file so OpenSSH client can use correct key for Dropbear server
                echo "Host ${IP}">>~/.ssh/config
                echo "IdentityFile ~/.ssh/${filename}">>~/.ssh/config
                echo "Port ${port}">>~/.ssh/config

                echo "Done"
                break;;
    
        * ) echo "O selects OpenSSH, D selects Dropbear.";;
    esac
done

##Ask user if new session is desired
while true; do
    read -r -p "Do you want to start an SSH session with your new key? [Y/N]" yn
        case $yn in
        [Yy]* ) echo "Logging in..." && ssh -p "$port" "$identity" && break ;;
        [Nn]* ) echo "Okay, not logging in now." && break;;
        * ) echo 'Yes or No?' ;;
    esac
done

echo "Enjoy the new keys."
exit
