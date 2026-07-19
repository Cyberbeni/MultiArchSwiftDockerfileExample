#!/bin/bash

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

## Executalbe/library
echo "Choose project type:"
echo "1 - Executable"
echo "2 - Library"
while : ; do
	read -r -p "> " -n 1 k <&1
	if [[ $k = 1 ]] ; then
		printf "\nSetting up executable project.\n"
		rm -rf ./Sources/ExampleLib
		rm ./.woodpecker/package-push.yaml
		perl -0pe "s#\t\t\.library\(\n(.*\n)*?\t\t\),\n##g" -i ./Package.swift
		perl -0pe "s#\t\t\.target\(\n(.*\n)*?\t\t\),\n##g" -i ./Package.swift
		echo "Keep Docker setup?"
		echo "1 - Yes"
		echo "2 - No"
		while : ; do
			read -r -p "> " -n 1 k <&1
			if [[ $k = 1 ]] ; then
				echo ""
				read -r -p $'Enter container image name (allowed characters: lowercase letters, digits, dashes):\n> ' CONTAINER_IMAGE_NAME
				sed -i "s#multi-arch-swift-dockerfile-example#${CONTAINER_IMAGE_NAME}#" ./.woodpecker/docker-push.yaml
				break
			elif [[ $k = 2 ]] ; then
				printf "\nRemoving Docker related files.\n"
				rm ./Dockerfile ./.dockerignore ./.woodpecker/docker-push.yaml
				break
			fi
		done
		break
	elif [[ $k = 2 ]] ; then
		printf "\nSetting up library project.\n"
		rm -rf ./Sources/ExampleApp
		rm ./Dockerfile ./.dockerignore ./scripts/assert-linked-libraries.sh ./scripts/build-release.sh ./.woodpecker/docker-push.yaml
		perl -0pe "s#\t\t\.executable\(\n(.*\n)*?\t\t\),\n##g" -i ./Package.swift
		perl -0pe "s#\t\t\.executableTarget\(\n(.*\n)*?\t\t\),\n##g" -i ./Package.swift
		break
	fi
done

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
