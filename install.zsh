#!/usr/bin/env zsh
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
echo $password | sudo -S -v

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

# Define the function to prompt the user and capture input
prompt_continue() {
  echo -e "\e[1;33m$1\e[0m"  
  read continue_key
}

install_Learn() {
  echo $password |  sudo -S -v
  source $HOME/.zshrc &&

  echo -e "\e[33m Installing Learn ... \e[0m"

  cd $HOME/work &&
  if [ -d learn ]; then
    cd learn &&
    echo "\a \a \a \a"
    prompt_continue "Turn off zscalar and please Press Enter to continue..."
    if [ -z "$continue_key" ]; then
    gdl installLearn &&
    echo -e "\e[33m Starting Learn Application... \e[0m"
    gdl startLearn
    open "https://mylearn.int.bbpd.io"
    print_congrats
    fi
  else
    echo -e "\e[33m There is no Learn Folder ... \e[0m"
  fi
}

install_ultra_router() {
  echo $password |  sudo -S -v
  source $HOME/.zshrc &&
  echo "Starting ultra_router..."
  cd $HOME/work &&
    if [ -d ultra-router ]; then
        cd ultra-router &&
         echo -e "\e[33m Starting Ultra Router... \e[0m"
        yes '' | ./start >> ~/install.log 2>&1 &
    fi

}

install_ultra() {
  echo $password |  sudo -S -v
  source $HOME/.zshrc &&
  echo "Installing Ultra..."
  cd $HOME/work &&
  if [ -d ultra ]; then
    cd ultra &&
    ./update.sh &&
    cd $HOME/work &&
    cd $HOME/work/ultra/apps/ultra-ui &&
    echo -e "\e[33m Starting Ultra Application... \e[0m"
    yarn start
  fi
  $BBHOME/tools/admin/UpdateUltraUIDecision.sh --on

  echo "\e[33m ********** To see the Ultra front end ********** \e[0m "
  echo "\n 1. Go to the System Admin panel and enable Ultra by clicking on the \e[1;32m Enable! \e[0m button under -- > The Ultra experience is here! ."
  echo "\n 2. You will be redirected--from then on--to the Ultra UI at https://mylearn.int.bbpd.io/ultra."

}

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $START_TIME"

# Check if the user pressed Enter (continue_key will be empty)
if [ -z "$continue_key" ]; then
install_Learn || error "Failed to install Learn"
install_ultra_router || error "Failed to install Learn"
else
  echo "Install Learn aborted due to no input from the user."
fi

# if [ $? -eq 0 ];
# then

#   install_ultra || { error "Error: Failed to install Ultra."; exit 1; }
# else
#   error "Error: Failed to start"
# fi

 END_TIME=$(date +"%Y-%m-%d %H:%M:%S")
  echo "Script ended at: $END_TIME"

  # Optional: Calculate duration
  START_SEC=$(date -j -f "%Y-%m-%d %H:%M:%S" "$START_TIME" "+%s")
  END_SEC=$(date -j -f "%Y-%m-%d %H:%M:%S" "$END_TIME" "+%s")
  DURATION=$(($END_SEC - $START_SEC))
  echo "Duration: $DURATION seconds"
