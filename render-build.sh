#!/usr/bin/env bash
# render-build.sh
# Runs during Render's build phase (before your app starts).
# Installs ffmpeg system-wide so MoviePy can find it.

set -o errexit   # abort on any error

echo "▶ Installing ffmpeg…"
apt-get update -qq
apt-get install -y --no-install-recommends ffmpeg

echo "▶ Installing Python dependencies…"
pip install --upgrade pip
pip install -r requirements.txt

echo "▶ Creating required directories…"
mkdir -p generated data

echo "✅ Build complete."