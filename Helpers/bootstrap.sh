#!/bin/bash

gem install bundler -v 2.3.22
bundle install
npm install --global git-format-staged
brew install swiftformat swiftlint swiftgen
git config core.hooksPath .githooks
