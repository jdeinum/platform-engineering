usr/bin/env bash

set -euo pipefail

# Absolute path to script directory
SCRIPT_DIR="./resources/"

# Check for Nix
if ! command -v nix-env &> /dev/null; then
  echo "❌ Nix is not installed. Please install Nix first."
  exit 1
fi

# Check for cluster name argument
CLUSTER_NAME="${1:-}"
if [ -z "$CLUSTER_NAME" ]; then
  echo "Usage: $0 <cluster-name>"
  exit 1
fi

# Ensure required tools are installed
for pkg in docker kind kubectl helm; do
  if ! command -v "$pkg" &> /dev/null; then
    echo "📦 Installing $pkg..."
    nix-env -iA "nixpkgs.${pkg}" 
  else
    echo "✅ $pkg already installed."
  fi
done

# Create k3d cluster
echo "🚀 Creating kind cluster: $CLUSTER_NAME"
kind create cluster --name "$CLUSTER_NAME" --config "./resources/kind_cluster.yaml"

echo "⏳ Waiting for nodes to become ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s 

# install nginx
echo "📦 Installing nginx..."
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml 

echo "⏳ Waiting for nginx to become ready..."
kubectl wait -n ingress-nginx --for=condition=Ready pod --all --timeout=120s 

# apply the example
echo "📦 Applying Kubernetes resources..."
kubectl apply -f "$SCRIPT_DIR/deployment.yaml" 
kubectl apply -f "$SCRIPT_DIR/service.yaml" 
kubectl apply -f "$SCRIPT_DIR/nginx_ingress.yaml" 

echo "✅ Done! Visit http://hello.example.com to see the Hello World app."
