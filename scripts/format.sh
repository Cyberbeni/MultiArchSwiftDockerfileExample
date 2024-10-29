#!/bin/bash

set -eo pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

if which swift > /dev/null 2>&1; then
	swift build --product swiftformat
	./.build/debug/swiftformat --cache ./.build/swiftformat-cache.json .
	# https://github.com/nicklockwood/SwiftFormat/issues/1904
	./.build/debug/swiftformat --cache ./.build/swiftformat-cache.json --lint --lenient .
elif which docker > /dev/null 2>&1; then
	docker run --rm \
		--volume .:/workspace \
		--user "$(id -u):$(id -g)" \
		swift:6.0.2 \
		/workspace/scripts/format.sh
else
	echo "Either 'swift' or 'docker' has to be installed to run swiftformat as an SPM plugin."
	exit 1
fi
