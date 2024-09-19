#!/bin/bash

# TODO: use your own tag and add `--push` to push to registry

set -eo pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

# https://docs.docker.com/build/building/multi-platform/#create-a-custom-builder
docker buildx build \
	--platform linux/amd64,linux/arm64 \
	-t local/swift_example_app \
	.
