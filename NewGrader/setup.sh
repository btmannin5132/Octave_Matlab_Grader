#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Update package lists
#apt-get update
apt-get install -y xvfb ghostscript tesseract-ocr tmux


# Install Octave
apt-get install -y octave jq