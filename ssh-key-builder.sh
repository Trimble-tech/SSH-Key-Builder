#   --Chris Trimble GNU GPLv3 2023--

##Script written for simplicity in integrating in larger project if needed
    ##Variables: filename, username, IP, identity, port

##Look at current keys
ls -a ~/.ssh
echo "Your current keys (if any) reside here."
echo "Pick a new name for your key so you don't overwrite an important one."
##Readability delay
sleep 2

##Create the keys, defining key as variable for script to automate import
echo "Creating key..."
read -p "Enter the name of your new key:" filename

##Makes sure key is built in correct folder
cd ~/.ssh
ssh-keygen -f $filename

##Define login string as variable to work with script
echo "Now that you have created a key it can be imported to the server."

read -p "Enter the username to use in SSH (like dietpi):" username
read -p "Enter the server IP Address (like 192.168.101.201):" IP

echo "The default port for SSH is 22."

##Added support for custom SSH ports
while true; do
    read -p "Are you using a port different than 22 on your server? [Y/N] " yn
        case $yn in
        [Yy]* ) read -p "Enter your port here:" port && break;;
        [Nn]* ) echo "Okay, we are using port 22 then." && port="22" && break ;;
        * ) echo "If you are unsure, you probably use port 22." ;;
    esac
done

identity="${username}@$IP"

##Import the key to the new system
echo "Copying your key to the server..."
ssh-copy-id -p $port $identity ##May import other keys, set "-i $filename" for strict import
echo "Done."

##Undos 'cd' from line 18
cd

##Ask user if new session is desired
while true; do
    read -p "Do you want to start an SSH session with your new key? [Y/N]" yn
        case $yn in
        [Yy]* ) echo "Logging in..." && ssh -p $port $identity && break ;;
        [Nn]* ) echo "Okay, not logging in now." && break;;
        * ) echo 'Yes or No?' ;;
    esac
done

echo "Enjoy the new keys."
exit