#!/bin/bash
function fail {
    echo "$(tput setaf 1)$@$(tput sgr0)"
    echo -e "\nPlease check https://github.com/RayzrDev/SharpBot/blob/master/FAQ.md before asking for help.\n"
    exit 1
}

function say {
    echo -e "\n$(tput setaf 2)> $(tput sgr0)$@\n"
}

say "Checking depedencies... "

for dep in node yarn git; do 
    if [[ ! "$(command -v $dep)" ]]; then
        fail "$dep is not installed! Please see http://github.com/RayzrDev/SharpBot for instructions on how to install SharpBot."
    fi
done

say "Downloading bot..."
git clone https://github.com/RayzrDev/SharpBot.git || fail "Failed to download bot!"

[[ -d SharpBot ]] || fail "Could not find SharpBot folder!"
cd SharpBot || fail "Could not enter SharpBot folder!"

say "Installing dependencies..."
yarn || fail "Failed to install dependencies!"

say "Starting bot..."
yarn start || fail "Failed to start bot!"
