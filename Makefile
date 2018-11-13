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

name = game-off-2018
version = 0.0.1

# The full package name with version
pkg_name := $(name)-$(version)

# The Godot binary path (can be just the name if it's in the PATH)
godot = godot-headless

# Run before all export targets
dist:
	mkdir -p "dist/"

# Export and package for Linux
dist-linux: dist
	mkdir -p "dist/.linux/$(pkg_name)-linux-x86_64/"
	"$(godot)" --export "Linux 64-bit" "dist/.linux/$(pkg_name)-linux-x86_64/$(name).x86_64"

	# Create Linux .tar.xz archive
	(cd "dist/.linux/" && tar cfJ "../$(pkg_name)-linux-x86_64.tar.xz" "$(pkg_name)-linux-x86_64/")

	# Clean up temporary files
	rm -rf "dist/.linux/"

# Export and package for macOS
dist-macos: dist
	godot-headless --export "macOS 64-bit" "dist/$(pkg_name)-macos.zip"

# Export and package for Windows
dist-windows: dist
	convert "icon.png" -define icon:auto-resize=256,128,64,48,32,16 "icon.ico"
	mkdir -p "dist/.windows/$(pkg_name)-windows-x86_64/" "dist/.windows/$(pkg_name)-windows-x86/"
	"$(godot)" --export "Windows 64-bit" "dist/.windows/$(pkg_name)-windows-x86_64/$(name).exe" &
	"$(godot)" --export "Windows 32-bit" "dist/.windows/$(pkg_name)-windows-x86/$(name).exe"

	# Create Windows ZIP archive
	(cd "dist/.windows/" && 7z a -r -mx9 "../$(pkg_name)-windows-x86_64.zip" "$(pkg_name)-windows-x86_64/") &
	(cd "dist/.windows/" && 7z a -r -mx9 "../$(pkg_name)-windows-x86.zip" "$(pkg_name)-windows-x86/")

	# Clean up temporary files
	rm -rf "dist/.windows/"

# Clean up build artifacts
clean:
	rm -rf "dist/" "icon.ico"
