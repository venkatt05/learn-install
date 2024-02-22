#!/usr/bin/env zsh

userEmail="$1"

computer_name=$(scutil --get ComputerName) &&

sudo scutil --set HostName $computer_name &&

sudo sed -i '' 's/127.0.0.1	localhost/127.0.0.1	mylearn.int.bbpd.io/g' /etc/hosts &&

echo "127.0.0.1   localhost localhost:localdomain $computer_name mylearn.int.bbpd.io" | sudo tee -a  /etc/hosts

if [ $? -eq 0 ]; then
  ~/learn-install/s6.zsh "$userEmail" &&
  ~/learn-install/s7.zsh &&
  ~/learn-install/s8.zsh &

  wait
else
  echo "Failure"
fi