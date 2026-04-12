#!/bin/bash

set -eo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null

## TODO: executalbe/library
## if executable -> assert linked libraries?
## if executable -> swift-service-lifecycle?
## if executable -> CBLogging?
## if library -> remove docker, remove assert linked

## TODO: project name

## TODO: license

## TODO: clean readme

## TODO: remove template dir
