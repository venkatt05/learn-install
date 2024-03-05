#!/usr/bin/env zsh

chmod +x ~/learn-install/s4.zsh
chmod +x ~/learn-install/s5.zsh
chmod +x ~/learn-install/s6.zsh
chmod +x ~/learn-install/s7.zsh
chmod +x ~/learn-install/s8.zsh

echo "Enter your userid: "
read userid
echo "Enter your password: "
read -s password

echo "Enter your GitHubEmail: "
read  $userEmail

echo "Enter your computer_name: "
read  $computer_name

error() {
  local input_message="$1"
  echo -e "\e[31mError: $input_message\e[0m" >> ~/install.log
  return 1
}

install_corretto() {
echo -e "\e[33m# Remove existing Corretto installations and tap cask-versions\e[0m"
 echo $password |  sudo -S rm -rf /Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk /usr/local/Caskroom/corretto

  echo -e "\e[33m# Tap homebrew/cask-versions\e[0m"
  brew tap homebrew/cask-versions

  echo -e "\e[33m# Update Homebrew\e[0m"
  brew update

  echo -e "\e[33m# Install Corretto 11\e[0m"
  brew install --cask corretto11 &&

  echo -e "\e[33m# Add JAVA_HOME to .zshrc and source it\e[0m"
  echo '\nexport JAVA_HOME=$(/usr/libexec/java_home -v 11)' >> ~/.zshrc &&
  source ~/.zshrc
}

installPostgres() {
echo -e "\e[33m# Install PostgreSQL 12\e[0m"
  brew install postgresql@12

  echo -e "\e[33m# Add PostgreSQL 12 to PATH in .zshrc\e[0m"
  echo '\nexport PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"' >> $HOME/.zshrc

  echo -e "\e[33m# Set PGDATA for PostgreSQL 12 in .zshrc\e[0m"
  echo '\nexport PGDATA=/opt/homebrew/var/postgresql@12' >> $HOME/.zshrc

  echo -e "\e[33m# Tap homebrew/services and homebrew/core\e[0m"
  brew tap homebrew/services
  # brew tap homebrew/core // Removing this as it is no longer needed on Homebrew 2.0.0 

  echo -e "\e[33m# Source .zshrc to apply changes\e[0m"
  source ~/.zshrc

  echo -e "\e[33m# Start PostgreSQL 12 as a service\e[0m"
  brew services start postgresql@12

  echo -e "\e[33m# Source .zshrc again to ensure changes are applied\e[0m"
  source ~/.zshrc
}

createUserAndChangePassword() {
  echo -e "\e[33m# Create superuser and createuser roles in PostgreSQL\e[0m"
  PGPASSWORD=postgres createuser -s -r postgres

  echo -e "\e[33m# Set password for the 'postgres' user in PostgreSQL\e[0m"
  psql -U postgres -c "alter user postgres PASSWORD 'postgres'"
}

updateConfFiles() {
  echo -e "\e[33m# Update authentication method in pg_hba.conf\e[0m"
  sed -i '' 's/trust/password/g' /opt/homebrew/var/postgresql@12/pg_hba.conf

  echo -e "\e[33m# Update max_connections in postgresql.conf\e[0m"
  sed -i '' 's/max_connections = 100/max_connections = 300/g' /opt/homebrew/var/postgresql@12/postgresql.conf

  echo -e "\e[33m# Restart PostgreSQL 12 service\e[0m"
  brew services restart postgresql@12
}

setupPostgres() {

    installPostgres &&
    createUserAndChangePassword &&
    updateConfFiles &&
    source ~/.zshrc
  }



start() {
  echo -e "\e[33m# Change the default shell to zsh\e[0m"
  echo $password | sudo -S chsh -s $(which zsh)

  echo -e "\e[33m# Create a 'work' directory and an empty .zshrc file\e[0m"
  mkdir $HOME/work && touch $HOME/.zshrc

  echo -e "\e[33m# Install Xcode command line tools\e[0m"
  xcode-select --install

  echo -e "\e[33m# Allow the specified user to run Homebrew install without a password\e[0m"
  echo "$USER ALL=(ALL) NOPASSWD: /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\"" | sudo EDITOR="tee -a" visudo

  echo -e "\e[33m# Install Homebrew with the specified username and password\e[0m"
  echo | /bin/bash -c "$(curl -fsSLu sthoomati:$password https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  echo -e "\e[33m# Add Homebrew shell initialization to .zprofile\e[0m"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile

  echo -e "\e[33m# Set up Homebrew environment\e[0m"
  eval "$(/opt/homebrew/bin/brew shellenv)"

  echo -e "\e[33m# Add Homebrew bin directory to PATH in .zshrc\e[0m"
  echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc

  echo -e "\e[33m# Reload the .zshrc file\e[0m"
  source ~/.zshrc
}


#start || error "Failed to install homebrew"
#
#if [ $? -eq 0 ]; then
#  install_corretto || error "Error: Failed to install JDK or set JAVA_HOME."
  setupPostgres || error "Error: Failed to postgres"
# else
  # echo "Error: Failed to start" >> ~/install.log
#fi
