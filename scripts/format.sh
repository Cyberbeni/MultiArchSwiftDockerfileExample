#!/bin/bash

set -eo pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
DOCKER_IMAGE="docker.io/swift:6.0.2"

if which swift > /dev/null 2>&1; then
	SWIFTFORMAT="./.build/debug/swiftformat"
	CACHE="./.build/swiftformat-cache.json"

	# Replicate `make` behaviour in docker, `swift build` can easily take 5+ seconds even when no operations are needed.
	NEEDS_REBUILD=1
	if which stat > /dev/null 2>&1 && [ -f "$SWIFTFORMAT" ]; then
		PRODUCT_MTIME=$(stat -c %Y "$SWIFTFORMAT")
		PACKAGE_SWIFT_MTIME=$(stat -c %Y "./Package.swift")
		PACKAGE_RESOLVED_MTIME=$(stat -c %Y "./Package.resolved")
		if (( PRODUCT_MTIME > PACKAGE_SWIFT_MTIME && PRODUCT_MTIME > PACKAGE_RESOLVED_MTIME )); then
			NEEDS_REBUILD=0
		fi
	fi
	if (( NEEDS_REBUILD != 0 )); then
		swift build --product swiftformat
		touch "$SWIFTFORMAT"
	fi
	"$SWIFTFORMAT" --cache "$CACHE" .
	# https://github.com/nicklockwood/SwiftFormat/issues/1904
	"$SWIFTFORMAT" --cache "$CACHE" --lint --lenient .
elif which docker > /dev/null 2>&1; then
	docker run --rm \
		--volume .:/workspace \
		--user "$(id -u):$(id -g)" \
		"$DOCKER_IMAGE" \
		"/workspace/scripts/$(basename "${BASH_SOURCE[0]}")"
elif which podman > /dev/null 2>&1; then
	podman run --rm \
		--volume .:/workspace \
		--userns=keep-id \
		"$DOCKER_IMAGE" \
		"/workspace/scripts/$(basename "${BASH_SOURCE[0]}")"
else
	echo "Either 'swift', 'docker' or 'podman' has to be installed to run swiftformat."
	exit 1
fi
