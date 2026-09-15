#!/bin/bash

set -eo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

DOCKER_IMAGE="docker.io/swift:latest"
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

	swift package resolve --only-use-versions-from-resolved-file

	CACHE="./.build/swiftformat-cache.json"

	case "$(uname)" in
		Darwin)
			SWIFTFORMAT="$(find ./.build/artifacts/swiftformat-artifactbundle -type f -name swiftformat)"
			;;
		Linux)
			case "$(uname -m)" in
				x86_64)
					SWIFTFORMAT="$(find ./.build/artifacts/swiftformat-artifactbundle -type f -name swiftformat_linux)"
					;;
				aarch64)
					SWIFTFORMAT="$(find ./.build/artifacts/swiftformat-artifactbundle -type f -name swiftformat_linux_aarch64)"
					;;
				*)
					echo "Unsupported architecture"
					exit 1
					;;
			esac
			;;
		*)
			echo "Unsupported OS"
			exit 1
			;;
	esac

	if (( DO_LINT != 0 )); then
		"$SWIFTFORMAT" --cache "$CACHE" --lint .
	else
		"$SWIFTFORMAT" --cache "$CACHE" .
		# https://github.com/nicklockwood/SwiftFormat/issues/1904
		"$SWIFTFORMAT" --cache "$CACHE" --lint --lenient .
	fi
}

source scripts/_script-wrapper.sh
