#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Starting Nix install and setup..."

# Detect OS and install prerequisites
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Detected macOS."
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "Installing prerequisites with brew..."
  brew install curl xz
elif command -v apt-get &>/dev/null; then
  echo "Detected Debian/Ubuntu."
  sudo apt-get update
  sudo apt-get install -y curl xz-utils
elif command -v yum &>/dev/null; then
  echo "Detected yum-based Linux."
  sudo yum install -y curl xz
else
  echo "Unsupported OS or package manager. This script should only be used on MacOS or a Debian based system."
  exit 1
fi

# Install Nix multi-user daemon
if ! command -v nix &>/dev/null; then
  echo "Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install) --daemon
else
  echo "Nix is already installed."
fi

# Source nix profile to have nix command available
if [ -f /etc/profile.d/nix.sh ]; then
  # shellcheck disable=SC1091
  source /etc/profile.d/nix.sh
fi

echo "Configuring Nix channel to stable..."
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs || true
nix-channel --update

echo "✅ Nix installed and configured."

# Ask user which script to run
echo
echo "Which Kubernetes setup do you want to run?"
select option in "k3d" "kind" "Quit"; do
  case $option in
    k3d)
      echo "Running k3d_nix.sh..."
      bash ./k3d_nix.sh
      break
      ;;
    kind)
      echo "Running kind_nix.sh..."
      bash ./kind_nix.sh
      break
      ;;
    Quit)
      echo "Exiting."
      exit 0
      ;;
    *)
      echo "Invalid option. Please choose again."
      ;;
  esac
done

echo "🎉 Done!"
