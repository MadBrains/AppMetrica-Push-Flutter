#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR/..

NEW_VERSION="${1}"

echo "Bumping version: ${NEW_VERSION}"

for pkg in {appmetrica_push,appmetrica_push_android,appmetrica_push_huawei,appmetrica_push_ios,appmetrica_push_platform_interface}; do
  # Bump version in pubspec.yaml
  perl -pi -e "s/^version: .*/version: $NEW_VERSION/" packages/$pkg/pubspec.yaml
done

for pkg in {appmetrica_push,appmetrica_push_android,appmetrica_push_huawei,appmetrica_push_ios}; do
  # Bump appmetrica_push_platform_interface version in pubspec.yaml
  perl -pi -e "s/appmetrica_push_platform_interface: .*/appmetrica_push_platform_interface: ^$NEW_VERSION/" packages/$pkg/pubspec.yaml
done

perl -pi -e "s/appmetrica_push_android: .*/appmetrica_push_android: ^$NEW_VERSION/" packages/appmetrica_push/pubspec.yaml
perl -pi -e "s/appmetrica_push_ios: .*/appmetrica_push_ios: ^$NEW_VERSION/" packages/appmetrica_push/pubspec.yaml