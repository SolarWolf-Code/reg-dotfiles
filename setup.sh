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

## Install Starship
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' > ~/.bashrc

## Install alacritty
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt update -y
sudo apt install alacritty

## Install discord (needs to be through .deb file)


## IntelliJ Ultimate IDEA (get .tar.gz then run the following)

### https://www.jetbrains.com/help/idea/installation-guide.html#9bddc0c
### sudo tar -xzf jetbrains-toolbox-1.17.7391.tar.gz -C /opt


## Install lutris
sudo apt install lutris -y

## Install qView
sudo add-apt-repository ppa:jurplel/qview -y
sudo apt update -y
sudo apt install qview -y

## Install Rustdesk (needs to be through .deb file)

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

## vlc
sudo apt install vlc -y

## github-copilot-cli
sudo apt install npm -y
sudo npm install -g @githubnext/github-copilot-cli

## Install noto-fonts
sudo apt install noto-fonts -y

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
