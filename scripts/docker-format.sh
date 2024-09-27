#!/bin/bash

set -eo pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

docker run --rm \
	--volume .:/home \
	swift:6.0.1 \
	/home/scripts/format.sh
