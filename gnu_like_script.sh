#!/bin/bash

# Function to display information about the current user and OS version
display_info() {
    neofetch
#  echo "Current User: $(whoami)"
 # echo "OS Version: $(cat /etc/os-release | grep "VERSION=" | awk -F '=' '{print $2}' | sed 's/"//g')"
}

# Function to display a list of files in the current user's home directory
list_files() {
  directory="$HOME"
  echo "Files in $directory:"
  ls -la "$directory"
}

help() {
  echo "Usage: {progname} [OPTION]... [URL] ... [FILE]"
  echo "Arguments:"
  echo "    -i | --info                         prints information about system"
  echo "    -l | --list                         displays a list of all files (including hidden ones)"
  echo "    -c | --create <file> <mod>          creates a file with specified file permissions"
  echo "    -p | --ping <destination> <amount>  prints information about system (default google.com 5 packets)"
}

# Function to create a file with specified permissions
create_file() {


  if [[ -z "$file" ]]; then
    echo "Filename field cannot be empty."
    exit 1
  fi

  touch "$file"

  if [[ -n "$mod" ]]; then
    chmod "$mod" "$file"
  fi
  echo "File created: $file with mod $mod"
}

# Function to send ping packets to specified resource
send_ping() {


  if [ -z "$resource" ] || [["$resource" = "."]]; then
    resource="google.com"
    echo "Using default addres: google.com"
  fi

  if [[ -z "$count" ]]; then
    echo "Using default number of packages: 10"
    count=10
  fi

  ping -c "$count" "$resource"
}

# Parsing command line arguments
if [[ -z "$1" ]]; then
    help
    exit 0
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
        help;;

    -i|--info)
      display_info
      ;;
    -l|--list)
      list_files
      ;;
    -c|--create)
        shift
        file=$1
        shift
        mod=$1
        create_file
      ;;
    -p|--ping)
        shift
        resource=$1
        shift
        count=$1
      send_ping
      ;;
    :) echo "no args";;
    *)
      echo "Invalid argument: $1"
      exit 1
      ;;
  esac
  shift
done
