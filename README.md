## SSH Key Builder

This Bash script aids in building an SSH key and then importing it to your server. It first displays keys in your `~/.ssh` folder (common default location) so if you have old ones they aren't overwritten by user error. It then uses existing Linux packages/commands to build the key and send it to your server, even letting you test them directly after. The goal is to make the process easy and enable developers to build this in their software too.

### Prerequisites

1. An OpenSSH client on a Linux machine.
2. A server with Dropbear or OpenSSH server running and accessible on a port.

### Usage

1. Download this script to your client machine (PC, laptop, etc.).
2. Mark it executable: `chmod +x ssh-key-builder.sh`
3. Execute the script: `./ssh-key-builder`

* Quick deploy: `wget https://raw.githubusercontent.com/Trimble-tech/SSH-Key-Builder/main/ssh-key-builder.sh && chmod +x ssh-key-builder.sh && ./ssh-key-builder.sh`

### Terminology/Good Things to Know

* SSH, generally speaking, is the connection via a *client* system like a PC or laptop and a *server*. The server can be any device running Linux, but generally is continuously running an SSH server application. Clients are like customers, and servers are like businesses, to make an analogy.
* Currently this script supports 2 commonly known SSH servers, [OpenSSH](https://www.openssh.com/) and [Dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html). Additionally, it supports the OpenSSH client; in the future the Dropbear client may be supported via a separate script under this project.

###### There are two ways that a typical SSH connection is secured: 

* **Passwords** are the default. They are setup by default, but can be guessed and are not as secure against hacking as a result. Additionally, use cases like [Ansible](https://www.ansible.com/), virtual servers, and frequently connecting clients can make passwords inconvenient or impossible.
* **Keys**, or certificates, are encrypted or hashed files (commonly) that can be used instead of a password. They are typically unique to the client device for security, and can optionally use a password to load into SSH. 
  * __Setting a password:__ If you share a client device with others or are particularly paranoid, set a password when prompted to enable one. Otherwise, leave the password prompt blank and you could remotely login without any input needed. Network security would be the same, but someone with access to your client could use the key too.
  * __Location of keys:__ Keys can theoretically be placed anywhere on your client, but it is best practice to place it in a hidden folder in your home directory, *\~/.ssh*. This script will by default use *\~/.ssh* as it requires less configuration and is safest against accidents. Servers however need to have keys in the correct place with correct permissions; this script takes care of that differently depending on whether Dropbear or OpenSSH is used.

###### Ports

* [Ports](https://en.wikipedia.org/wiki/Port_\(computer_networking\)) are how computers can network with each other. Like loading docks in a shipping warehouse, ports define how network traffic interacts with your device. This script will ask you what port to use; the default for SSH is 22. However, SSH can be sent to any port if your client and server are configured correctly; this is typically done to hide SSH for better security. 
  * **The vast majority of people are fine using Port 22**, but you have the option to use something different. If you take this option, please configure everything before running this script, and only do so if you know what you are doing.

###### Questions?

If you are want to learn more about this script, email me at chris.trimble3.ct@gmail.com. For general advice about SSH setup, please refer to the forum or support group for your Linux distribution.

### License

**SSH Key Builder** is licensed by Chris Trimble under the GPL v3 Open Source license (2023). Refer to the file "LICENSE" for more information.
