#!/bin/bash
#
# Perform backups of user-HP-ProBook-450-G1 files via rsync and send them via home network to server

# global variables
declare -r PRIVATE_KEY_PATH="/home/user/.ssh/ubuntu-server-key-rsa"
declare -r SERVER_PRIVATE_IP="192.168.0.100"
declare -r SERVER_USER="server-user" # name of the account on server with which you want to sync
declare -r CLIENT_NAME="my-pc-name" # name of your local machine



#######################################
# Sync files from ~/Documents to backup directory named after the client machine
# Globals:
#   SERVER_PRIVATE_IP
#   SERVER_USER
#   CLIENT_NAME
# Arguments:
#   Name of the directory located in ~/Documents to sync
# Returns:
#   None
#######################################
function clientDocumentsSync()
{
	rsync --archive --compress --progress --verbose -e "ssh -i $PRIVATE_KEY_PATH" /home/user/Documents/$1/ $SERVER_USER@$SERVER_PRIVATE_IP:~/backups/$CLIENT_NAME/$1/
}



#######################################
# Sync files from ~/Desktop to backup directory named after the client machine
# Globals:
#   SERVER_PRIVATE_IP
#   SERVER_USER
#   CLIENT_NAME
# Arguments:
#   Name of the directory located in ~/Desktop to sync
# Returns:
#   None
#######################################
function clientDesktopSync()
{
	rsync --archive --compress --progress --verbose -e "ssh -i $PRIVATE_KEY_PATH" /home/user/Desktop/$1/ $SERVER_USER@$SERVER_PRIVATE_IP:~/backups/$CLIENT_NAME/$1/
}



#######################################
# Sync files from ~/Documents to backup directory named after the client machine and exclude unwanted files
# Globals:
#   SERVER_PRIVATE_IP
#   SERVER_USER
#   CLIENT_NAME
# Arguments:
#   Name of the directory located in ~/Documents to sync
#   Name of the list with the files to exclude from syncing 
# Returns:
#   None
#######################################
function clientDocumentsExcludeSync()
{
	rsync --archive --compress --progress --verbose -e "ssh -i $PRIVATE_KEY_PATH" --exclude-from "$2" /home/user/Documents/$1/ $SERVER_USER@$SERVER_PRIVATE_IP:~/backups/$CLIENT_NAME/$1/
}



#######################################
# Sync files from client  directory to backup directory on server
# Globals:
#   SERVER_PRIVATE_IP
#   SERVER_USER
# Arguments:
#   Name (or path) of the directory located in client computer to sync
#   Name (or path) of the directory located in server computer to sync
# Returns:
#   None
#######################################
function sync()
{
	rsync --archive --compress --progress --verbose -e "ssh -i $PRIVATE_KEY_PATH" /$1/ $SERVER_USER@$SERVER_PRIVATE_IP:~/backups/$2/
}



#######################################
# Sync files from client  directory to backup directory on server and exclude unwanted files
# Globals:
#   SERVER_PRIVATE_IP
#   SERVER_USER
# Arguments:
#   Name (or path) of the directory located in client computer to sync
#   Name (or path) of the directory located in server computer to sync
#   Name of the list with the files to exclude from syncing 
# Returns:
#   None
#######################################
function excludeSync()
{
	rsync --archive --compress --progress --verbose -e "ssh -i $PRIVATE_KEY_PATH" --exclude-from "$3" /$1/ $SERVER_USER@$SERVER_PRIVATE_IP:~/backups/$2/
}



function main()
{
	# header
	date
	printf '#####################################################################\n'
	
	# normal
	clientDocumentsSync C
	clientDocumentsSync GitHub
	clientDocumentsSync tests
	clientDocumentsSync Bash
	clientDesktopSync z_manuals
	sync ~/arduino-1_8_5/my-projects $CLIENT_NAME/arduino-projects
	sync ~/Documents/web-development web-development
	sync opt/lampp/htdocs $CLIENT_NAME/htdocs
	
	# exclude
	clientDocumentsExcludeSync Python exclude-list-python.txt
	excludeSync ~/Sync Sync exclude-list-sync.txt	

	# footer
	printf '#####################################################################\n'
}



main
