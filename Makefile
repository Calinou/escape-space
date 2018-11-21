# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
#
# This Makefile assists in exporting and packaging the project for
# various platforms.
# Godot, ImageMagick and 7-zip must be available in the PATH for
# this Makefile to function correctly.
# The project's assets must also have been imported first by opening
# the project using the editor for exporting to be possible.

MAKEFLAGS += --silent
all: dist-linux dist-macos dist-windows
.PHONY: all

NAME = game-off-2018
VERSION = 0.0.1

# The full package name with version
PKG_NAME := $(NAME)-$(VERSION)

# The Godot binary path (can be just the name if it's in the PATH)
# This can be overridden using `make GODOT=<path to Godot binary>`
GODOT = godot-headless

# Destination path for build artifacts
OUTPUT_PATH = dist

# Workaround for <https://github.com/godotengine/godot/issues/23044>
TIMEOUT = 20

# Run before all export targets
dist:
	# Create directories needed for headless exporting
	# Workaround for <https://github.com/godotengine/godot/issues/16949>
	mkdir -p "$(OUTPUT_PATH)/" "$HOME/.config/godot/" "$HOME/.cache/godot/" "$HOME/.local/share/godot/"

# Export and package for Linux
dist-linux: dist
	mkdir -p "$(OUTPUT_PATH)/.linux/$(PKG_NAME)-linux-x86_64/"
	timeout "$(TIMEOUT)" "$(GODOT)" --export "Linux 64-bit" "$(OUTPUT_PATH)/.linux/$(PKG_NAME)-linux-x86_64/$(NAME).x86_64" || true

	# Create Linux .tar.xz archive
	(cd "$(OUTPUT_PATH)/.linux/" && tar cfJ "../$(PKG_NAME)-linux-x86_64.tar.xz" "$(PKG_NAME)-linux-x86_64/")

	# Clean up temporary files
	rm -rf "$(OUTPUT_PATH)/.linux/"

# Export and package for macOS
dist-macos: dist
	# Workaround for <https://github.com/godotengine/godot/issues/23073>
	timeout "$(TIMEOUT)" "$(GODOT)" --export "macOS 64-bit" "$(OUTPUT_PATH)/$(PKG_NAME)-macos.app" || true
	mv "$(OUTPUT_PATH)/$(PKG_NAME)-macos.app" "$(OUTPUT_PATH)/$(PKG_NAME)-macos.zip"

# Export and package for Windows
dist-windows: dist
	convert "icon.png" -define icon:auto-resize=256,128,64,48,32,16 "icon.ico"
	mkdir -p "$(OUTPUT_PATH)/.windows/$(PKG_NAME)-windows-x86_64/" "$(OUTPUT_PATH)/.windows/$(PKG_NAME)-windows-x86/"
	timeout "$(TIMEOUT)" "$(GODOT)" --export "Windows 64-bit" "$(OUTPUT_PATH)/.windows/$(PKG_NAME)-windows-x86_64/$(NAME).exe" || true &
	timeout "$(TIMEOUT)" "$(GODOT)" --export "Windows 32-bit" "$(OUTPUT_PATH)/.windows/$(PKG_NAME)-windows-x86/$(NAME).exe" || true

	# Create Windows ZIP archive
	(cd "$(OUTPUT_PATH)/.windows/" && 7z a -r -mx9 "../$(PKG_NAME)-windows-x86_64.zip" "$(PKG_NAME)-windows-x86_64/") &
	(cd "$(OUTPUT_PATH)/.windows/" && 7z a -r -mx9 "../$(PKG_NAME)-windows-x86.zip" "$(PKG_NAME)-windows-x86/")

	# Clean up temporary files
	rm -rf "$(OUTPUT_PATH)/.windows/"

# Clean up build artifacts
clean:
	rm -rf "$(OUTPUT_PATH)/" "icon.ico"
