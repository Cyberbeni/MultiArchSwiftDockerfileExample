#!/bin/bash

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

## TODO: executalbe/library
## if executable -> assert linked libraries?
## if executable -> swift-service-lifecycle?
## if executable -> CBLogging?
## if library -> remove docker, remove assert linked

## TODO: project name

## License
YEAR=$(date +%Y)
NAME=$(git config --get user.name)
sed -i "s#__YEAR__#${YEAR}#" ./template/LICENSE.md
sed -i "s#__NAME__#${NAME}#" ./template/LICENSE.md
rm UNLICENSE.txt
mv ./template/LICENSE.md .

## Clean readme
cat > README.md <<EOF
## Description
EOF

## Remove template dir
rm -rf ./template
