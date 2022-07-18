#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR/..

DEVELOPMENT_TEAM="${1}"

echo "Update DEVELOPMENT_TEAM: ${DEVELOPMENT_TEAM}"

perl -pi -e "s/DEVELOPMENT_TEAM = .*/DEVELOPMENT_TEAM = $DEVELOPMENT_TEAM;/" examples/example_fcm/ios/Runner.xcodeproj/project.pbxproj