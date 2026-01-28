#!/bin/bash

set -eo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

DOCKER_IMAGE="docker.io/cyberbeni/swift-builder:latest"
PROCESS="swift"

do_it() {
	DO_LINT=0
	while [[ $# -gt 0 ]]; do
		case $1 in
			--lint)
				DO_LINT=1
				shift
				;;
			*)
      		echo "Unknown option $1"
      		exit 1
				;;
		esac
	done

	SWIFTFORMAT="./.build/debug/swiftformat"
	CACHE="./.build/swiftformat-cache.json"

	# Replicate `make` behaviour in docker, `swift build` can easily take 5+ seconds even when no operations are needed.
	# CI will always do fresh clone, so Package.swift/resolved will always be newer than the cache unless we are running parallel jobs.
	# And since we might restore a cache from a different Package.resolved, we want to ensure build is up to date in this case too.
	NEEDS_REBUILD=1
	if [ -z "$CI" ] && which stat > /dev/null 2>&1 && [ -f "$SWIFTFORMAT" ]; then
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
	if (( DO_LINT != 0 )); then
		"$SWIFTFORMAT" --cache "$CACHE" --lint .
	else
		"$SWIFTFORMAT" --cache "$CACHE" .
		# https://github.com/nicklockwood/SwiftFormat/issues/1904
		"$SWIFTFORMAT" --cache "$CACHE" --lint --lenient .
	fi
}

source scripts/_script-wrapper.sh
