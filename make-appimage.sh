#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q songrec | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/re.fossplant.songrec.svg
export DESKTOP=/usr/share/applications/re.fossplant.songrec.desktop
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0
export DEPLOY_PIPEWIRE=1
export STARTUPWMCLASS=re.fossplant.songrec # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1

# Deploy dependencies
quick-sharun /usr/bin/songrec

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
