#!/bin/bash
set -eo pipefail

# Get the directory that this script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Build the Docker image with the correct context
echo "Building Docker image: functions"
echo -e "\n"
sudo docker build -t functionapp ${DIR} --build-arg BUILDKIT_INLINE_CACHE=1

# Generate a unique tag for the image
tag=$(date -u +"%Y%m%d-%H%M%S")
echo "Tagging image with: $tag"
sudo docker tag functionapp functionapp:$tag

# Output the tag to a file to be used in deployment
echo -n "$tag" > ./functions/image_tag.txt

echo "Build and tagging complete. Tag: $tag"
echo -e "\n"