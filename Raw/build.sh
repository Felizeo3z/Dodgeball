#!/bin/bash

# Dodge Ball Survival Build Script
# This script builds the game for multiple platforms

echo "🎮 Building Dodge Ball Survival releases..."

# Create builds directory
mkdir -p builds/windows
mkdir -p builds/macos  
mkdir -p builds/web
mkdir -p builds/linux

echo "📁 Created build directories"

# Check if Godot is available
if ! command -v godot &> /dev/null; then
    echo "❌ Godot not found in PATH. Please install Godot 4.4 or add it to your PATH"
    exit 1
fi

echo "✅ Godot found"

# Export for each platform
echo "🏗️ Building Windows version..."
godot --headless --export-release "Windows Desktop" builds/windows/DodgeBallSurvival.exe

echo "🏗️ Building macOS version..."
godot --headless --export-release "macOS" builds/macos/DodgeBallSurvival.zip

echo "🏗️ Building Web version..."
godot --headless --export-release "Web" builds/web/index.html

echo "🎉 Build complete! Check the builds/ directory for your releases"
echo "📦 Available builds:"
ls -la builds/*/ 