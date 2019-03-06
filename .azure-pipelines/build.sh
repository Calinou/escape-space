#!/usr/bin/env bash
#
# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

set -euo pipefail
IFS=$'\n\t'

export DEBIAN_FRONTEND="noninteractive"
export WINEDEBUG="-all"

# Install packages
sudo apt-get install -qqq \
    apt-transport-https curl imagemagick make p7zip-full \
    software-properties-common xz-utils
curl -LO "https://dl.winehq.org/wine-builds/Release.key"
sudo apt-key add Release.key
sudo apt-add-repository "https://dl.winehq.org/wine-builds/ubuntu/"
sudo dpkg --add-architecture i386
sudo apt-get update -qq
sudo apt-get install --allow-unauthenticated -qqq winehq-devel

# Install Inno Setup using innoextract and create a launcher script
tmp="$(mktemp)"
curl -fsSLo "$tmp" \
    "http://constexpr.org/innoextract/files/snapshots/innoextract-1.8-dev-2018-09-09/innoextract-1.8-dev-2018-09-09-linux.tar.xz"
tar xf "$tmp"
sudo mv innoextract* /opt/innoextract/
curl -fsSLO "http://files.jrsoftware.org/is/5/innosetup-5.6.1-unicode.exe"
sudo /opt/innoextract/innoextract -md "/opt/innosetup/" "innosetup-5.6.1-unicode.exe"
echo "wine \"/opt/innosetup/app/ISCC.exe\" \"\$@\"" \
    | sudo tee "/usr/local/bin/iscc"
sudo chmod +x "/usr/local/bin/iscc"

# Install Godot headless editor
curl -fsSLO \
    "https://archive.hugo.pro/builds/godot/server/godot-linux-headless-nightly-x86_64.tar.xz"
tar xf godot-linux-headless-nightly-x86_64.tar.xz
sudo mv godot-headless /usr/local/bin/godot-headless

# Install Godot export templates
curl -fsSLO \
    "https://archive.hugo.pro/builds/godot/templates/godot-templates-android-html5-linux-windows-nightly.tpz"
curl -fsSLO \
    "https://archive.hugo.pro/builds/godot/templates/godot-templates-ios-macos-nightly.tpz"
mkdir -p "$HOME/.local/share/godot/templates/3.1.alpha/"

for tpz in *.tpz; do
  unzip -joqq "$tpz" -d "$HOME/.local/share/godot/templates/3.1.alpha/"
done

# Set up version information
sed -i \
    "s|config/version=\".*\"|config/version=\"continuous [$(git rev-parse HEAD | head -c8)]\"|" \
    project.godot
sed -i \
    "s|config/version_date=.*|config/version_date=$(date +%s)|" \
    project.godot

# Export to all platforms
make VERSION="continuous" OUTPUT_PATH="$SYSTEM_ARTIFACTSDIRECTORY"
