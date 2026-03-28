<p align="center">
  <img src="assets/icon.png" width="128" height="128" alt="CleanBar icon">
  <h1 align="center">CleanBar</h1>
  <p align="center">A lightweight macOS utility to hide menu bar icons and keep your desktop clean.</p>
</p>

<p align="center">
  <a href="https://github.com/bzantium/cleanbar/releases/latest">
    <img src="https://img.shields.io/badge/download-latest-brightgreen.svg" alt="download">
  </a>
  <img src="https://img.shields.io/badge/platform-macOS-blue.svg" alt="platform">
  <img src="https://img.shields.io/badge/requirements-macOS%2013%2B-lightgrey.svg" alt="requirements">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="license">
  </a>
</p>

## Install

### Homebrew

```sh
brew tap bzantium/cleanbar
brew install --cask cleanbar
```

### Manual

Download the latest release from the [releases page](https://github.com/bzantium/cleanbar/releases/latest), unzip, and drag `CleanBar.app` to your Applications folder.

### Build from source

```sh
git clone https://github.com/bzantium/cleanbar.git
cd cleanbar
./Scripts/build.sh
open CleanBar.app
```

## Features

- **Hide/Show menu bar icons** -- Click the toggle arrow to collapse or expand hidden icons
- **Auto-hide** -- Automatically collapse after a configurable delay
- **Global hotkey** -- Toggle with `Cmd+Shift+B` from anywhere
- **Launch at login** -- Start CleanBar automatically when you log in
- **Lightweight** -- Native Swift app, no Electron, minimal resource usage
- **Menu bar only** -- No Dock icon, lives entirely in the menu bar

## Usage

1. Launch CleanBar -- a `≫` icon appears in your menu bar
2. **Cmd + drag** menu bar icons to rearrange them
3. Place icons you want to hide to the **left** of the separator (`|`)
4. Click `≫` to **hide**, click `≪` to **show**
5. Right-click the icon for **Settings** and **Quit**

## Requirements

- macOS 13 (Ventura) or later

## License

MIT
