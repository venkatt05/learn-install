#!/usr/bin/env zsh
password="$1"
echo $password |  sudo -v

print_congrats() {
echo -e "\e[1m \e[32m ********* Congratulations!!! ********  \e[0m" 
echo -e "\e[1m \e[36m Your Learn Application is Up !!! and opened in your default browser\e[0m"  
echo -e "\e[36m  Userid/password: administrator/changeme .  \e[0m"                                  
}

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
    open "https://mylearn.int.bbpd.io"
    print_congrats
    
  else
    echo -e "\e[33m There is no Learn Folder ... \e[0m"
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
  $BBHOME/tools/admin/UpdateUltraUIDecision.sh --on

  echo "\e[33m ********** To see the Ultra front end ********** \e[0m "
  echo "\n 1. Go to the System Admin panel and enable Ultra by clicking on the \e[1;32m Enable! \e[0m button under -- > The Ultra experience is here! ."
  echo "\n 2. You will be redirected--from then on--to the Ultra UI at https://mylearn.int.bbpd.io/ultra."

}

install_Learn || error "Failed to install Learn"

if [ $? -eq 0 ];
then
install_ultra || { error "Error: Failed to install Ultra."; exit 1; }
else
  error "Error: Failed to start"
fi

