#!/usr/bin/env bash
echo "Installing Scratch VM dependencies..."
cd client/scratch-vm && npm install && sudo npm link
echo "Installing Scratch GUI dependencies..."
cd ../../client/scratch-gui && npm sudo link scratch-vm && sudo npm install
echo "Installing Wolfram Web Engine..."
pip install wolframwebengine
echo "All Done!"
