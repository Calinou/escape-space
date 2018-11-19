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

# Run before all export targets
dist:
	mkdir -p "dist/"

# Export and package for Linux
dist-linux: dist
	mkdir -p "dist/.linux/$(PKG_NAME)-linux-x86_64/"
	"$(GODOT)" --export "Linux 64-bit" "dist/.linux/$(PKG_NAME)-linux-x86_64/$(NAME).x86_64"

	# Create Linux .tar.xz archive
	(cd "dist/.linux/" && tar cfJ "../$(PKG_NAME)-linux-x86_64.tar.xz" "$(PKG_NAME)-linux-x86_64/")

	# Clean up temporary files
	rm -rf "dist/.linux/"

# Export and package for macOS
dist-macos: dist
	"$(GODOT)" --export "macOS 64-bit" "dist/$(PKG_NAME)-macos.zip"

# Export and package for Windows
dist-windows: dist
	convert "icon.png" -define icon:auto-resize=256,128,64,48,32,16 "icon.ico"
	mkdir -p "dist/.windows/$(PKG_NAME)-windows-x86_64/" "dist/.windows/$(PKG_NAME)-windows-x86/"
	"$(GODOT)" --export "Windows 64-bit" "dist/.windows/$(PKG_NAME)-windows-x86_64/$(NAME).exe" &
	"$(GODOT)" --export "Windows 32-bit" "dist/.windows/$(PKG_NAME)-windows-x86/$(NAME).exe"

	# Create Windows ZIP archive
	(cd "dist/.windows/" && 7z a -r -mx9 "../$(PKG_NAME)-windows-x86_64.zip" "$(PKG_NAME)-windows-x86_64/") &
	(cd "dist/.windows/" && 7z a -r -mx9 "../$(PKG_NAME)-windows-x86.zip" "$(PKG_NAME)-windows-x86/")

	# Clean up temporary files
	rm -rf "dist/.windows/"

# Clean up build artifacts
clean:
	rm -rf "dist/" "icon.ico"
