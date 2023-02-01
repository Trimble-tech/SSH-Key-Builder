## SSH Key Builder

This Bash script aids in building an SSH key and then importing it to your server. It first displays keys in your \~/.ssh folder (common default location) so if you have old ones they aren't overwritten by user error. It then uses existing Linux packages/commands to build the key and send it to your server, even letting you test them directly after. The goal is to make the process easy and enable developers to build this in their software too.

### Prerequisites

1. An OpenSSH client on a Linux machine.
2. A server with OpenSSH support.

### Usage

1. Download this script to your client machine (PC, laptop, etc.).
2. Mark it executable: **chmod +x ssh-key-builder.sh**
3. Execute the script: **./ssh-key-builder**

### License

**SSH Key Builder** is licensed by Chris Trimble under the GPL v3 Open Source license (2023). Refer to the file "LICENSE" for more information.
