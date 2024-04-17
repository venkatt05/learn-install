#!/usr/bin/env zsh
password="$1"
echo $password |  sudo -v

error() {
  local input_message="$1"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "\e[31mError at $timestamp: $input_message\e[0m" >> ~/install.log
  return 1
}

install_Learn() {
echo $password |  sudo -v
  echo -e "\e[33m Installing Learn ... \e[0m"
  cd $HOME/work &&
  if [ -d learn ]; then
    cd learn &&
    gdl installLearn &&
    echo -e "\e[33m Starting Learn Application... \e[0m"
    gdl startLearn
  fi
}

install_ultra() {
  echo $password |  sudo -v
  echo "Installing Ultra..."
  cd $HOME/work &&
  if [ -d ultra ]; then
    cd ultra &&
    ./update.sh &&
    cd $HOME/work &&
    if [ -d ultra-router ]; then
        cd ultra-router &&
         echo -e "\e[33m Starting Ultra Router... \e[0m"
        ./start 
    fi
    cd $HOME/work/ultra/apps/ultra-ui &&
    echo -e "\e[33m Starting Ultra Application... \e[0m"
    yarn start
  fi
}

install_Learn || error "Failed to install Learn"

if [ $? -eq 0 ];
then
install_ultra || { error "Error: Failed to install Ultra."; exit 1; }
else
  error "Error: Failed to start"
fi
