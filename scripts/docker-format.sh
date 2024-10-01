#!/bin/bash

set -eo pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

docker run --rm \
	--volume .:/workspace \
	--user "$(id -u):$(id -g)" \
	swift:6.0.1 \
	/workspace/scripts/format.sh
