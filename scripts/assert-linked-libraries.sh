#!/bin/bash

set -eo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

DOCKER_IMAGE="docker.io/cyberbeni/swift-builder:latest"
PROCESS="swift ldd jq"

do_it() {
	APPS=$(swift package dump-package | jq -r '.products[] | select(.type | has("executable")) | .name')
	LIBS=(
		Foundation
		FoundationInternationalization
		_FoundationICU
	)
	if [ -z "$APPS" ]; then
		echo "error: no executable targets found"
		exit 1
	fi
	HAS_ERROR=0
	IFS=$'\n'
	for APP in $APPS; do
		for LIB in "${LIBS[@]}"; do
			if ldd ".build/debug/$APP" | grep "lib$LIB.so" > /dev/null 2>&1; then
				echo "error: $APP links with $LIB"
				HAS_ERROR=1
			fi
		done
	done
	if (( HAS_ERROR != 0 )); then
		exit 1
	fi
}

source scripts/_script-wrapper.sh
