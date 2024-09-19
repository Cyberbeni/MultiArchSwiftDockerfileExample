#!/bin/bash

set -eo pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null

swift package plugin --allow-writing-to-package-directory swiftformat
