# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Screenshots can now be taken by pressing <kbd>F12</kbd>.
- The game can now be started on a specific level by specifying `--level=N`
  on the command line, `N` being the number of the level starting from 1.

### Changed

- Godot 3.2 is now required to run the project from source.
- Switched to the GLES2 renderer for better compatibility with mobile/web platforms.

### Fixed

- Fixed stuttering when the paddle is moving on high refresh-rate displays
  by implementing physics interpolation.

## [1.2.0] - 2019-03-01

### Added

- Menu sliders now have an editable number field next to them.
- Menu sliders can now be reset to their default value by right-clicking them.

### Changed

- The GUI is now confined to a 16:9 rectangle when using an ultrawide
  aspect ratio.

### Fixed

- A ball's particle trail no longer disappears suddenly when it leaves
  the viewport.

## [1.1.0] - 2019-02-17

### Added

- Full controller support.

### Changed

- The pause menu now smoothly fades in and out when displaying.
- Updated the project structure for Godot 3.1 beta 5.

### Fixed

- Addressed all GDScript warnings in the project.

## 1.0.0 - 2018-12-01

- Initial versioned release.

[Unreleased]: https://github.com/Calinou/escape-space/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/Calinou/escape-space/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Calinou/escape-space/compare/v1.0.0...v1.1.0
