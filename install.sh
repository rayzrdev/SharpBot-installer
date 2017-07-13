#!/bin/bash
clear
function fail {
    echo "$(tput setaf 1)$*$(tput sgr0)"
    echo -e "\nPlease check https://github.com/RayzrDev/SharpBot/blob/master/FAQ.md before asking for help.\n"
    exit 1
}

function say {
    echo -e "\n$(tput setaf 2)> $(tput sgr0)$*\n"
}

function detect_os {
	if [[ "$OSTYPE" == "linux"* ]]; then
        	os='GNU/Linux'
	elif [[ "$OSTYPE" == "darwin"* ]]; then # macOS (Mac OS X) identifies as darwin
        	os='macOS'
	elif [[ "$OSTYPE" == "cygwin" ]]; then # Having Cygwin installed does not confirm that apt or anything else that is required is present
        	fail "Due to the possibility of certain utilites not being present, install script failing out. Please see http://github.com/RayzrDev/SharpBot for help."
	elif [[ "$OSTYPE" == "msys" ]]; then # Having MinG installed does not confirm that apt or anything else that is required is present
        	fail "Due to the possibility of certain utilites not being present, install script failing out. Please see http://github.com/RayzrDev/SharpBot for help."
	elif [[ "$OSTYPE" == "win32" ]]; then # This script ain't compatiable with Windows, always fail out
        	fail "This install script is for Linux and macOS, please use install.bat."
	elif [[ "$OSTYPE" == "freebsd"* ]]; then
        	# os='freebsd'
		fail "Automated install of Yarn on FreeBSD is not feasible at the moment, check back in a bit for updates."
	else
        	fail "OS not compatiable or not detected. Please see http://github.com/RayzrDev/SharpBot for help."
	fi
}

function install_deps {
	say "Installing dependencies now!"
	say "Updating repo lists now!"
	if [ $os == "GNU/Linux" ]
	then
		sudo apt-get update
		sudo apt-get upgrade -y
		say "Installing Git!"
		sudo apt-get install git -y || fail "Failed to install Git."
		say "Git installed!"
		say "Installing Node.JS!"
		curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
		sudo apt-get install -y nodejs || fail "Failed to install Node.JS."
		say "Node.JS installed!"
		say "Installing Yarn!"
		curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
		echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
		sudo apt-get update
		sudo apt-get install yarn -y || fail "Failed to install Yarn."
		say "Yarn installed!"
		say "Dependencies are now installed! Continuing with setup!"
		return
	elif [ $os == "macOS" ]
	then
		say "Looks like you are running macOS! You must be informed of something first then, macOS does not come with a a package manager. You can install Homebrew as a package manager. Or you can install everything manually using the tools available at http://github.com/RayzrDev/SharpBot."
		read -r -p "What would you like to do? Homebrew = h, quit = q " mac_choice
		case $mac_choice in
			[Hh]* ) return;;
			[Qq]* ) fail "Quitting!";;
			* ) fail "Not a valid answer! Install failed!";;
		esac
		say "Installing Command Line Tools (CLT) for Xcode! This is a requirement of Homebrew."
		xcode-select --install
		say "Installing Homebrew!"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		say "Homebrew installed!"
		say "Installing Git!"
		brew install git || fail "Failed to install Git."
		say "Git installed!"
		say "Installing Node.JS!"
		brew install node || fail "Failed to install Node."
		say "Node.JS installed!"
		say "Installing Yarn!"
		brew install yarn || fail "Failed to install Yarn."
		say "Yarn installed!"
		return
	#elif [ $os == 'freebsd' ]
	#then
	#	pkg update
	#	say "Installing Git!"
	#	pkg install git || fail "Failed to install Git."
	#	say "Git installed!"
	#	say "Installing Node.JS!"
	#	pkg install node || fail "Failed to install Node."
	#	say "Node.JS installed!"
	#	say "Installing Yarn!"
	#	pkg install || fail "Failed to install Yarn."
	#	return
	fi
}

# OS detection and confirmation bit
say "Checking OS..."
detect_os
say "Your OS was detected as: " $os


say "Checking dependencies... "

for dep in node yarn git; do 
    if [[ ! "$(command -v $dep)" ]]; then
        say "Dependencies are not installed or not detected!"
	read -r -p "Would you like to install the dependencies now? " choice
	case $choice in
		[Yy]* ) install_deps; break;;
		[Nn]* ) fail "Dependencies not satisfied! Install failed!";;
		* ) fail "Not a valid answer! Install failed!";;
	esac
    fi
done

say "Downloading bot..."
git clone https://github.com/RayzrDev/SharpBot.git || fail "Failed to download bot!"

[[ -d SharpBot ]] || fail "Could not find SharpBot folder!"
cd SharpBot || fail "Could not enter SharpBot folder!"

say "Installing dependencies..."
yarn || fail "Failed to install dependencies!"

clear

say "Starting bot..."
/bin/bash -c "yarn start || fail "Failed to start bot!""
