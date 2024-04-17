#!/usr/bin/env zsh
password="$1"
echo $password |  sudo -v

error() {
  local input_message="$1"
  echo -e "\e[31mError: $input_message\e[0m" >> ~/install.log
  tail -10f ~/install.log && exit
  return 1
}

install_Learn() {
echo $password |  sudo -v
  echo "Installing Learn..."
  cd $HOME/work &&
  if [ -d learn ]; then
    cd learn &&
    gdl installLearn &&
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
        ./start 
    fi
    cd $HOME/work/ultra/apps/ultra-ui &&
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
