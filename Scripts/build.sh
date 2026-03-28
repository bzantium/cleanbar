#!/bin/bash
set -euo pipefail

APP_NAME="CleanBar"
BUNDLE_DIR="$APP_NAME.app"
CONTENTS_DIR="$BUNDLE_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo "Building $APP_NAME..."

# Build release binary
swift build -c release 2>&1

# Create bundle structure
rm -rf "$BUNDLE_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Copy binary
cp ".build/release/$APP_NAME" "$MACOS_DIR/"

# Copy Info.plist
cp Resources/Info.plist "$CONTENTS_DIR/"

# Ad-hoc code sign
codesign --force --deep --sign - "$BUNDLE_DIR"

echo ""
echo "✅ Built $BUNDLE_DIR successfully!"
echo "   Run with: open $BUNDLE_DIR"
echo "   Or copy to /Applications for Launch at Login support"
