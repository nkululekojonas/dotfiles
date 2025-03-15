#!/bin/bash

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit'

# Ask for administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; done 2>/dev/null &

### General UI/UX Tweaks ###

echo "Setting macOS defaults..."

# Disable the startup chime
sudo nvram SystemAudioVolume=" "

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Set accent color to Graphite
defaults write NSGlobalDomain AppleAccentColor -int 6

# Set sidebar icon size to Medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Disable window tinting
defaults write NSGlobalDomain AppleReduceTransparency -bool true

### Finder Tweaks ###

# Hide filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Use list view in all Finder windows by default (Nlsv = list view)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

### Dock & Mission Control Tweaks ###

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove all default app icons from the Dock (except Finder and Trash)
defaults write com.apple.dock persistent-apps -array

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

### Trackpad, Keyboard, and Input ###

# Enable tap to click for trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Disable press-and-hold for keys (makes it faster for developers)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set key repeat speed
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

### Safari & WebKit Tweaks ###

# Enable Develop menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show full URL in Safari's address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

### Apply Changes ###

# Restart affected apps
for app in "Finder" "Dock" "Safari" "SystemUIServer"; do
    killall "$app" &> /dev/null
done

echo "macOS defaults have been set. Restart your Mac for all changes to take effect."
