#!/usr/bin/env zsh

chmod +x ~/learn-install/s4.zsh
chmod +x ~/learn-install/s5.zsh
chmod +x ~/learn-install/s6.zsh
chmod +x ~/learn-install/s7.zsh
chmod +x ~/learn-install/s8.zsh

installJDK() {
  try {
    sudo rm -rf /Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk /usr/local/Caskroom/corretto
    brew tap homebrew/cask-versions
    brew update 
    brew install --cask corretto11 &&
    echo '\nexport JAVA_HOME=$(/usr/libexec/java_home -v 11)' >> ~/.zshrc &&
    source ~/.zshrc
  } catch {
    echo "Error: Failed to install JDK or set JAVA_HOME." >> ~/install.log
    return 1
  }
}

installPostgres() {
    brew install postgresql@12
    echo '\nexport PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"' >> $HOME/.zshrc
    echo '\nexport PGDATA=/opt/homebrew/var/postgresql@12' >> $HOME/.zshrc
    brew tap homebrew/services
    brew tap homebrew/core
    source ~/.zshrc
    brew services start postgresql@12
    source ~/.zshrc
}

createUserAndChangePassword() {
    createuser -s -r postgres
    psql -U postgres -c "alter user postgres PASSWORD 'postgres'"
}

updateConfFiles() {
    sed -i '' 's/trust/password/g' /opt/homebrew/var/postgresql@12/pg_hba.conf
    sed -i '' 's/max_connections = 100/max_connections = 300/g' /opt/homebrew/var/postgresql@12/postgresql.conf
    brew services restart postgresql@12
}

setupPostgres() {
  try {  
    installPostgres &&
    createUserAndChangePassword &&
    updateConfFiles &&
    source ~/.zshrc
  } catch {
    echo "Error: Failed to postgres" >> ~/install.log
    return 1
  }
}

start() {
  try {
    chsh -s $(which zsh)
    mkdir $HOME/work && touch $HOME/.zshrc &&
    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &&
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile &&
    eval "$(/opt/homebrew/bin/brew shellenv)" &&
    echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc &&
    source ~/.zshrc
  } catch {
    echo "Error: Failed to install homebrew" >> ~/install.log
    return 1
  }
}


start
if [ $? -eq 0 ]; then
  installJDK
  setupPostgres
else
  echo "Error: Failed to start" >> ~/install.log
fi