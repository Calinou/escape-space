# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
#
# This Makefile is used to export and package the project to various platforms.
# The path to the Godot editor/headless binary can be specified by adding
# `GODOT=<path to Godot binary>` to the `make` command line.
# ImageMagick, Inno Setup and 7-zip must also be available in the PATH
# for this Makefile to work.

MAKEFLAGS += --silent
.PHONY: all
all: dist-linux dist-macos dist-windows

NAME = escape-space
VERSION = 1.2.0

# The full package name with version
PKG_NAME := $(NAME)-$(VERSION)

# The path of the project to deploy to on itch.io
# Translates into an URL of the form <https://[user].itch.io/[name]>
ITCHIO_PROJECT = calinou/$(NAME)

# Path to the Godot binary (can be just the name if it's in the PATH)
GODOT = godot-headless

# Destination path for build artifacts
OUTPUT_DIR = dist

# Workaround for <https://github.com/godotengine/godot/issues/23044>
TIMEOUT = 30

# Clean up build artifacts
.PHONY: clean
clean:
	rm -rf "$(OUTPUT_DIR)/" "icon.ico"

# Deploy to itch.io (requires `butler` in PATH)
# See <https://itch.io/docs/butler/login.html> for authentication
.PHONY: deploy
deploy:
	butler push --userversion "$(VERSION)" "dist/$(PKG_NAME)-setup-x86_64.exe" "$(ITCHIO_PROJECT):windows-installer-x86_64"
	butler push --userversion "$(VERSION)" "dist/$(PKG_NAME)-setup-x86.exe" "$(ITCHIO_PROJECT):windows-installer-x86"
	butler push --userversion "$(VERSION)" "dist/$(PKG_NAME)-windows-x86_64.zip" "$(ITCHIO_PROJECT):windows-zip-x86_64"
	butler push --userversion "$(VERSION)" "dist/$(PKG_NAME)-windows-x86.zip" "$(ITCHIO_PROJECT):windows-zip-x86"
	butler push --userversion "$(VERSION)" "dist/$(PKG_NAME)-macos.zip" "$(ITCHIO_PROJECT):macos-x86_64"
	butler push --userversion "$(VERSION)" "dist/$(PKG_NAME)-linux-x86_64.tar.xz" "$(ITCHIO_PROJECT):linux-x86_64"

# Run before all export targets
.PHONY: dist
dist:
	# Create directories needed for headless exporting
	# Workaround for <https://github.com/godotengine/godot/issues/16949>
	mkdir -p "$(OUTPUT_DIR)/" "$(HOME)/.config/godot/" "$(HOME)/.cache/godot/" "$(HOME)/.local/share/godot/"

# Export and package for Linux
.PHONY: dist-linux
dist-linux: dist
	mkdir -p "$(OUTPUT_DIR)/.linux/$(PKG_NAME)-linux-x86_64/"
	timeout "$(TIMEOUT)" "$(GODOT)" --export "Linux 64-bit" "$(OUTPUT_DIR)/.linux/$(PKG_NAME)-linux-x86_64/$(NAME).x86_64" || true

	# Create Linux .tar.xz archive
	(cd "$(OUTPUT_DIR)/.linux/" && tar cfJ "../$(PKG_NAME)-linux-x86_64.tar.xz" "$(PKG_NAME)-linux-x86_64/")

	# Clean up temporary files
	rm -rf "$(OUTPUT_DIR)/.linux/"

# Export and package for macOS
.PHONY: dist-macos
dist-macos: dist
	# Workaround for <https://github.com/godotengine/godot/issues/23073>
	timeout "$(TIMEOUT)" "$(GODOT)" --export "macOS 64-bit" "$(OUTPUT_DIR)/$(PKG_NAME)-macos.app" || true
	mv "$(OUTPUT_DIR)/$(PKG_NAME)-macos.app" "$(OUTPUT_DIR)/$(PKG_NAME)-macos.zip"

# Export and package for Windows
.PHONY: dist-windows
dist-windows: dist
	convert "icon.png" -define icon:auto-resize=256,128,64,48,32,16 "icon.ico"
	mkdir -p "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86_64/" "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86/"
	timeout "$(TIMEOUT)" "$(GODOT)" --export "Windows 64-bit" "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86_64/$(NAME).exe" || true
	timeout "$(TIMEOUT)" "$(GODOT)" --export "Windows 32-bit" "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86/$(NAME).exe" || true

	# Create Windows installers
	# The path given to ISCC must be globalized for WINE by prepending `Z:`
	cp "misc/$(NAME).iss" "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86_64/" &
	cp "misc/$(NAME).iss" "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86/"
	iscc "Z:$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86_64/$(NAME).iss" "/DMyAppVersion=$(VERSION)" &
	iscc "Z:$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86/$(NAME).iss" "/DMyAppVersion=$(VERSION)" /DApp32Bit
	rm "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86_64/$(NAME).iss" "$(OUTPUT_DIR)/.windows/$(PKG_NAME)-windows-x86/$(NAME).iss"

	# Create Windows ZIP archives
	(cd "$(OUTPUT_DIR)/.windows/" && 7z a -r -mx9 "../$(PKG_NAME)-windows-x86_64.zip" "$(PKG_NAME)-windows-x86_64/") &
	(cd "$(OUTPUT_DIR)/.windows/" && 7z a -r -mx9 "../$(PKG_NAME)-windows-x86.zip" "$(PKG_NAME)-windows-x86/")

	# Clean up temporary files
	rm -rf "$(OUTPUT_DIR)/.windows/"
