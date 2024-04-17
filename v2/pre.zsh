#!/usr/bin/env zsh

chmod +x ~/learn-install/v2/main.zsh

echo "Enter your System password: "
read -s password

echo "Enter your email (Anthology email): "
read userEmail

echo "Enter your user name that will be used/configured with you local Git : "
read userName

echo "Enter password to Authenticate sudo access : "
echo $password |  sudo -v

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

  echo "\a \a \a \a"
  echo -e "\e[33m*******************  Read the Below Notes Carefully*********************\e[0m"
  echo -e "\n \e[33mYour public SSH key Highlighted in Green Colour and is already copied:\e[0m" &&
  echo -e "\n \e[32m$(cat ~/.ssh/id_ed25519.pub)\e[0m"
  echo "\n 1. You can see there is a GiHub URL opened in your default browser."
  echo "\n 2. press "command + v" to paste the SSH into the value box."
  echo "\n 3. click on \e[1;32mconfigure sso\e[0m button and authorize all the projects."
  echo -e "\n"
  echo -e "For more details Refer: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account. Proceed with the next steps once done."

  pbcopy < ~/.ssh/id_ed25519.pub
  open "https://github.com/settings/ssh/new"

else
  echo "SSH key already present. Add to your github account(https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and then configure the SSH. Once done proceed with next steps."
fi

# Define the function to prompt the user and capture input
prompt_continue() {
  echo "$1"
  read continue_key
}

# Example usage: Prompt the user and capture input
prompt_continue "After adding the ssh key please Press Enter to continue..."

# Check if the user pressed Enter (continue_key will be empty)
if [ -z "$continue_key" ]; then
~/learn-install/v2/main.zsh "$password" "$userEmail" "$userName"
else
  echo "Continuation aborted."
fi