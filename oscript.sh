homebrew_install_path=""
if $(sysctl -a | grep -q  "Apple"); then
  # Case Apple M1 CPU
  export homebrew_install_path="/opt/homebrew"
else
  # Case Intel CPU
  export homebrew_install_path="/usr/local"
fi

# Get the current logged in user excluding loginwindow, _mbsetupuser, and root
current_user=$(/usr/sbin/scutil <<<"show State:/Users/ConsoleUser" |
    /usr/bin/awk '/Name :/ && ! /loginwindow/ && ! /root/ && ! /_mbsetupuser/ { print $3 }' |
    /usr/bin/awk -F '@' '{print $1}')

/usr/bin/su - "$current_user" -c 

#Install homebrew
sudo -u $current_user NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(${homebrew_install_path}/bin/brew shellenv)"
sudo -u $current_user brew install osquery
sudo -u $current_user brew install clamav
