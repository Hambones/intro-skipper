#!/usr/bin/env bash
set -euo pipefail

VERSION=${1:-0.0.0}
OUTPUT_DIR=${2:-releases}
BUILD_DIR=${3:-IntroSkipper/bin/Release/net9.0}

if [ ! -d "$BUILD_DIR" ]; then
  echo "Build output not found: $BUILD_DIR" >&2
  echo "Run: dotnet publish -c Release IntroSkipper/IntroSkipper.csproj" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

ZIP_NAME="intro-skipper-${VERSION}.zip"
ZIP_PATH="$OUTPUT_DIR/$ZIP_NAME"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

cp "$BUILD_DIR"/*.dll "$tmpdir" || true

if [ -d "IntroSkipper/Configuration" ]; then
  mkdir -p "$tmpdir/web"
  cp -r IntroSkipper/Configuration/* "$tmpdir/web/"
fi

pushd "$tmpdir" >/dev/null
zip -r "$ZIP_PATH" .
popd >/dev/null

echo "Created package: $ZIP_PATH"
