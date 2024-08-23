#!/usr/bin/env zsh

# Get the operating system name
os_name=$(uname -s)

# Get the machine hardware name (processor architecture)
arch_name=$(uname -m)

if [[ "$os_name" == "Darwin" ]]; then
    if [[ "$arch_name" != "arm64" ]]; then
        echo "This script is only intended to run on an Apple Silicon processor."
        exit 1
    fi
else
    echo "This script is not running on a Mac."
    exit 1
fi

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $START_TIME"

chmod +x ~/learn-install/main.zsh

# Define the file to store the inputs
input_file="$HOME/learn_install_input.txt"

# Check if the file exists
if [ -f "$input_file" ]; then
    # Read the inputs from the file
    lines=()
    while IFS= read -r line; do
        lines+=("$line")
    done < "$input_file"
    password=${lines[1]}
    userEmail=${lines[2]}
    userName=${lines[3]}
else
    # Ask the user for the inputs
    echo "Enter your System password: "
    read -s password

    echo "Enter your email (Anthology email): "
    read userEmail

    echo "Enter your user name that will be used/configured with you local Git : "
    read userName

    # Write the inputs to the file
    echo "$password" > "$input_file"
    echo "$userEmail" >> "$input_file"
    echo "$userName" >> "$input_file"
fi

# Updating to extent the sudo timeout to 180 minutes
echo $password | sudo -S -v
echo 'Defaults        timestamp_timeout=180' | sudo tee /etc/sudoers.d/timeout

# This script is used to check and generate SSH key for the user. This is a pre-requisite script that should be ran before running the main script.
# Check if SSH key is present
echo -e "\e[33mChecking SSH key\e[0m"
if [  ! -f ~/.ssh/id_ed25519 ]; then

  ssh-keygen -t ed25519 -C "$userEmail" -N "" -f ~/.ssh/id_ed25519

  # Start SSH agent
  eval "$(ssh-agent -s)" &&

  # Configure SSH
  touch $HOME/.ssh/config &&
  echo -e 'Host github.com
  \nAddKeysToAgent yes
  \nUseKeychain yes
  \nIdentityFile ~/.ssh/id_ed25519' >> $HOME/.ssh/config &&

  # Add SSH key to agent
  ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519 &&
  open "https://github.com/settings/ssh/new"

else
  echo "\n SSH key already present."
  open "https://github.com/settings/ssh" 
fi
  pbcopy < ~/.ssh/id_ed25519.pub
  echo "\a \a \a \a"
  echo -e "\e[33m*******************  Read the Below Notes Carefully*********************\e[0m"
  echo -e "\n \e[33m 1. Your public SSH key Highlighted in Green Colour and is already copied:\e[0m" &&
  echo -e "\n \e[32m$(cat ~/.ssh/id_ed25519.pub)\e[0m"
  pbcopy < ~/.ssh/id_ed25519.pub
  echo "\n 2. You can see there is a GiHub URL opened in your default browser."
  echo "\n 3. Ignore this step if you already have the SSH Key in you GitHub Account else Press "command + v" to paste the SSH into the value box."
  echo "\n 4. click on \e[1;32mconfigure sso\e[0m button and authorize all the projects."
  echo -e "\n"
  echo -e "For more details Refer: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account. Proceed with the next steps once done."


# Define the function to prompt the user and capture input
prompt_continue() {
  echo -e "\e[1;33m$1\e[0m"  
  read continue_key
}

# Example usage: Prompt the user and capture input
prompt_continue "After adding the ssh key please Press Enter to continue..."

# Check if the user pressed Enter (continue_key will be empty)
if [ -z "$continue_key" ]; then


END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script ended at: $END_TIME"

# Calculate duration of the script
START_SEC=$(date -j -f "%Y-%m-%d %H:%M:%S" "$START_TIME" "+%s")
END_SEC=$(date -j -f "%Y-%m-%d %H:%M:%S" "$END_TIME" "+%s")
DURATION=$(($END_SEC - $START_SEC))
echo "Duration: $DURATION seconds" > ~/pre_script_duration.txt

~/learn-install/main.zsh "$password" "$userEmail" "$userName"
else
  echo "Continuation aborted."
fi