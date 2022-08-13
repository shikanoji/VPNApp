# sysvpn-apple
SysVPN Client For Apple Devices

# Installation

- install Go 
  ```
  brew install go
  ```
- use LicensePlist to control OSS License: https://github.com/mono0926/LicensePlist

# Init Fastlane for App Distribution
## Install `rbenv`: 
  ```
  brew install rbenv
  ```
## Install ruby for project environemt
  ```
  rbenv install 3.1.2
  rbenv local 3.1.2
  ```
## Install `bundler`
  ```
  gem install bundler
  bundler init
  ```
  Change Gemfile content to 
  
  ```
  source "https://rubygems.org"

  gem "fastlane"
  ```
  
  You might need to export GEM_HOME
  ```
  export GEM_HOME="$HOME/.gem"
  ```
## Install `fastlane`
  ```
  brew install fastlane
  fastlane init swift
  ```
  
  Follow Firebase distribution setup: https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane
  
  
