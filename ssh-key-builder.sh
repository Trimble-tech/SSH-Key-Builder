#   --Chris Trimble GNU GPLv3 2023--

##Script written for simplicity in integrating in larger project if needed
##Note variables filename, username, IP, and identity

##Look at current keys
ls -a ~/.ssh
echo "Your current keys (if any) reside here."
echo "Pick a new name for your key so you don't overwrite an important one."
##Readability delay
sleep 2

##Create the keys, defining key as variable for script to automate import
echo "Creating key..."
read -p "Enter the name of your new key:" filename

cd ~/.ssh

ssh-keygen -f $filename

##Define login string as variable to work with script
echo "Now that you have created a key it can be imported to the server."

read -p "Enter the username to use in SSH (like dietpi):" username
read -p "Enter the server IP Address (like 192.168.101.201):" IP
identity="${username}@$IP"

##Import the key to the new system
echo "Copying your key to the server..."
ssh-copy-id $identity ##May import other keys, set "-i $filename" for strict import
echo "Done."

##Undos 'cd' from line 18
cd

##Ask user if new session is desired
while true; do
    read -p "Do you want to start an SSH session with your new key? [Y/N]" yn
        case $yn in
        [Yy]* ) echo "Logging in..." && ssh $identity && break ;;
        [Nn]* ) echo "Okay, not logging in now." && break;;
        * ) echo 'Yes or No?' ;;
    esac
done

echo "Enjoy the new keys."
exit