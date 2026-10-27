#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
FLUTTER_VERSION=3.47.8
if [ ! -x .tools/flutter/bin/flutter ]; then
  mkdir -p .tools
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git .tools/flutter
fi
export PATH="$PWD/.tools/flutter/bin:$PATH"
flutter config --no-analytics
flutter pub get
flutter build web --release --dart-define=DEMO_MODE=true --no-wasm-dry-run
