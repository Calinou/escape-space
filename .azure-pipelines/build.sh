#!/usr/bin/env bash
#
# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

set -euo pipefail
IFS=$'\n\t'

export DEBIAN_FRONTEND="noninteractive"

# Install packages
sudo apt-get update -qq
sudo apt-get install -qqq curl imagemagick make p7zip-full xz-utils

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
