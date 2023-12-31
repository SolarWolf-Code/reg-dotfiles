## Create symbolic links to .config
for file in *; do
  if [[ "$file" == ".git" || "$file" == "README.md" || "$file" == "setup.sh" || "$file" == "Packages" ]]; then
    continue
  fi  
  ln -s "$(pwd)/$file" ~/.config/"$file"
done

## Install CURL
sudo apt install curl -y

## Install wget
sudo apt install wget -y

## Install make
sudo apt install make -y

## Install Starship (requires confirmation)
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' > ~/.bashrc

## Install noto-fonts
sudo apt install fonts-noto -y

## Install Fira Code Mono Nerd Font
mkdir FiraMono
wget $(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep "browser_download_url.*FiraMono.*\.tar\.xz" | cut -d '"' -f 4)
tar -xvf FiraMono.tar.xz -C FiraMono
cd FiraMono
sudo cp *.otf /usr/share/fonts
cd 
sudo rm -r ~/reg-dotfiles/FiraMono

## Install blesh (bash auto complete)
sudo apt install gawk -y
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc

cd reg-dotfiles

## Install Regolith themes
sudo apt install regolith-look-* -y
regolith-look set blackhole

## Add Universal libs
sudo add-apt-repository universe -y
sudo apt update -y

## Install Steam
sudo apt install steam -y

## Install Librewolf
sudo apt update && sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates

distro=$(if echo " una vanessa focal jammy bullseye vera uma" | grep -q " $(lsb_release -sc) "; then echo $(lsb_release -sc); else echo focal; fi)

wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg

sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

sudo apt update

sudo apt install librewolf -y

## Install Libreoffice
sudo apt install libreoffice -y

## Install alacritty
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt update -y
sudo apt install alacritty -y

## Install Discord (needs to be through .deb file)
wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
sudo apt install ./discord*.deb -y

## Install qView
wget $(curl -s https://api.github.com/repos/jurplel/qView/releases/latest | grep "browser_download_url" | grep "amd64.deb" | cut -d '"' -f 4)
sudo apt install ./qview*.deb -y

## Install Rustdesk (needs to be through .deb file)
wget $(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | grep "browser_download_url" | grep ".deb" | grep -v "armhf" | cut -d '"' -f 4)
sudo apt install ./rustdesk*-x86_64.deb -y

## Install Spotify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-get update && sudo apt-get install spotify-client -y

## Flameshot
sudo apt install flameshot -y

## Micro
sudo apt install micro -y

## nnn
sudo apt install nnn -y

## htop
sudo apt install htop -y

## r2modman (need to grab appimage and use --no-sandbox flag. Requires use to make custom .desktop file)
wget $(curl -s https://api.github.com/repos/ebkr/r2modmanPlus/releases/latest | grep "browser_download_url.*deb" | cut -d '"' -f 4)
sudo apt install ./r2modman*.deb -y
sudo sed -i 's/^Exec=.*/& --no-sandbox/' /usr/share/applications/r2modman.desktop

## vlc
sudo apt install vlc -y

## github-copilot-cli
sudo apt install npm -y
sudo npm install -g @githubnext/github-copilot-cli
echo 'eval "$(github-copilot-cli alias -- "$0")"' >> ~/.bashrc

## Install wormhole
sudo apt install magic-wormhole -y

## Install obs
sudo apt install obs-studio -y

## Install virt-manager
sudo apt install virt-manager -y

## Install github-cli
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

## Insert keybinds
sudo sh -c 'echo "
# Steam -> allows for games to update in background
exec steam -silent

# Flameshot (screenshot tool)
bindsym \$mod+Shift+s exec flameshot gui

# Ruskdesk
assign [class=\"Rustdesk\"] \$ws3
exec --no-startup-id rustdesk" >> /usr/share/regolith/i3/config.d/90_user-programs'

## Configure OpenVPN
mkdir ~/ovpn
touch ~/ovpn/credentials.txt
sudo mkdir /etc/openvpn/surfshark/
sudo cp us-slc.prod.surfshark.com_udp.ovpn /etc/openvpn/surfshark/us-slc.prod.surfshark.com_udp.ovpn
sudo sh -c 'echo "[Unit]
Description=Surfshark OpenVPN service
After=network.target

[Service]
ExecStart=/usr/sbin/openvpn --config /etc/openvpn/surfshark/us-slc.prod.surfshark.com_udp.ovpn
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/surfshark.service'


sudo systemctl enable surfshark.service
sudo systemctl start surfshark.service

## Fix Bluetooth (requires reboot)
sudo touch /usr/share/pipewire/media-session.d/with-pulseaudio
sudo apt install gstreamer1.0-pipewire -y
killall pipewire
pulseaudio --start
sudo chown -R $USER:$USER $HOME/
sudo apt-get --purge --reinstall install pulseaudio-module-bluetooth alsa-base pulseaudio -y
mv ~/.config/pulse ~/.config/pulse.old

## Enable and start libvirtd for virt-manager (requires reboot)
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

## Install Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update -y
sudo apt-get install tailscale -y

## Comment out uneeded keybinds
sudo sed -i '/## Session \/\/ Sleep \/\/ /,$ s/^/#/' /usr/share/regolith/i3/config.d/55_session_keybindings

## Jetbrains Toolbox (get .tar.gz then run the following).
TOOLBOX_VERSION_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
wget "$TOOLBOX_VERSION_URL" 
tar -xzf jetbrains-toolbox-*.tar.gz -C ~/
mv ~/jetbrains-toolbox-* ~/jetbrains-toolbox
wget -O ~/jetbrains-toolbox/jetbrains-toolbox.png https://logon-int.com/wp-content/uploads/2019/01/toolbox_logo_300x300.png
sudo sh -c 'echo "[Desktop Entry]
Name=Jetbrain Toolbox
Exec=/home/wolf/jetbrains-toolbox/jetbrains-toolbox
Terminal=false
Type=Application
Icon=/home/wolf/jetbrains-toolbox/jetbrains-toolbox.png
StartupWMClass=Jetbrains Toolbox" >> /usr/share/applications/jetbrains-toolbox.desktop'



## Remove the files we needed earlier
rm *.deb
rm *.tar.gz
rm *.tar.xz
rm builder-debug.yml
