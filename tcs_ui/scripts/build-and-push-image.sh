#!/bin/bash

# shellcheck disable=SC1091
source .env

# Function to extract version from pyproject.toml
get_version_from_pyproject() {
    if [ ! -f "pyproject.toml" ]; then
        echo "Error: pyproject.toml not found!" >&2
        exit 1
    fi
    
    # Using grep/sed to extract version
    #VERSION=$(grep -E '^version\s*=' pyproject.toml | head -1 | sed -E 's/.*=\s*["\']([^"\']+)["\'].*/\1/\')
    VERSION=$(grep -E '^version\s*=' pyproject.toml | head -1 | sed -E 's/.*=\s*["\'"'"']([^"'"'"']+)["\'"'"'].*/\1/')

    if [ -z "$VERSION" ]; then
        echo "Error: Could not extract version from pyproject.toml" >&2
        exit 1
    fi
    
    echo "$VERSION"
}

# Variables
USERNAME="$GIT_USERNAME"  # Your GitHub username
ACCOUNT="$GIT_ACCOUNT"     # Your GitHub account
TOKEN="$GHCR_TOKEN"         # Your GHCR token
IMAGE_NAME="ghcr.io/${ACCOUNT}/${IMAGE_NAME}"  # Replace with your image name
TAG="latest"                   # Tag for the image

# Get version from pyproject.toml
echo "Reading version from pyproject.toml..."
VERSION=$(get_version_from_pyproject)
V_TAG="v${VERSION}"           # Version tag for the image

echo "Using version: $VERSION (tag: $V_TAG)"


# Login to GitHub Container Registry
echo "Logging in to GitHub Container Registry..."
echo "$TOKEN" | docker login ghcr.io -u "$USERNAME" --password-stdin

# Create and use a new buildx builder instance
docker buildx create --name mybuilder --use

# Build and Push the image
echo "Building and pushing Docker image..."
docker buildx build --platform linux/amd64 --tag "${IMAGE_NAME}":${TAG}  --tag "${IMAGE_NAME}":${V_TAG} --push .
#docker buildx build --platform linux/amd64,linux/arm64 --tag "${IMAGE_NAME}":${V_TAG} --push .

# Clean up buildx builder instance
docker buildx rm mybuilder

echo "Build and push completed $IMAGE_NAME:$V_TAG have been pushed to GitHub Container Registry."