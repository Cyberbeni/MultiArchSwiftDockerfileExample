#!/bin/bash

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

## Executalbe/library
echo "Choose project type:"
echo "1 - Executable"
echo "2 - Library"
## TODO: remove other target from Package.swift
while : ; do
	read -r -p "> " -n 1 k <&1
	if [[ $k = 1 ]] ; then
		printf "\nSetting up executable project.\n"
		rm -rf ./Sources/ExampleLib
		rm ./.woodpecker/package-push.yaml
		break
	elif [[ $k = 2 ]] ; then
		printf "\nSetting up library project.\n"
		rm -rf ./Sources/ExampleApp
		rm ./Dockerfile ./dockerignore ./scripts/assert-linked-libraries.sh ./scripts/build-release.sh ./.woodpecker/docker-push.yaml
		break
	fi
done

exit 0

## Project name
read -r -p $'Enter project name:\n> ' PROJECT_NAME
if [ -d ./Sources/ExampleApp ]; then
	mv ./Sources/ExampleApp "./Sources/$PROJECT_NAME"
fi
if [ -d ./Sources/ExampleLib ]; then
	mv ./Sources/ExampleLib "./Sources/$PROJECT_NAME"
fi
sed -i "s#ExampleApp#${PROJECT_NAME}#" ./Package.swift
sed -i "s#ExampleLib#${PROJECT_NAME}#" ./Package.swift

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
