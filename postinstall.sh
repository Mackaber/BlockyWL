#!/usr/bin/env bash
echo "Installing Scratch VM dependencies..."
cd client/scratch-vm && npm install && npm link
echo "Installing Scratch GUI dependencies..."
cd ../../client/scratch-gui && npm link scratch-vm && npm install
echo "Installing Wolfram Web Engine..."
pip install wolframwebengine
echo "All Done!"
