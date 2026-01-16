#!/bin/bash

echo "========================================"
echo "  GrimVision - Build Script"
echo "========================================"
echo ""

# Create build directories
mkdir -p build/classes
mkdir -p target

# Download Spigot API if not exists
if [ ! -f "build/spigot-api.jar" ]; then
    echo "Downloading Spigot API 1.16.5..."
    curl -L -o build/spigot-api.jar "https://hub.spigotmc.org/nexus/content/repositories/snapshots/org/spigotmc/spigot-api/1.16.5-R0.1-SNAPSHOT/spigot-api-1.16.5-R0.1-20210119.001102-143.jar" 2>/dev/null
    
    if [ ! -f "build/spigot-api.jar" ]; then
        echo ""
        echo "ERROR: Spigot API download failed!"
        echo "Please download manually from https://getbukkit.org/download/spigot"
        echo "and place it in build/spigot-api.jar"
        exit 1
    fi
fi

echo ""
echo "Compiling Java source..."
javac -cp "build/spigot-api.jar" -d build/classes src/main/java/com/grimvision/GrimVision.java

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Compilation failed!"
    exit 1
fi

echo "Copying plugin.yml..."
cp src/main/resources/plugin.yml build/classes/

echo "Creating JAR file..."
cd build/classes
jar cvf GrimVision.jar com/grimvision/*.class plugin.yml >/dev/null
cd ../..

echo "Moving JAR to target folder..."
mv build/classes/GrimVision.jar target/GrimVision.jar

echo ""
echo "========================================"
echo "  BUILD SUCCESSFUL!"
echo "========================================"
echo ""
echo "Output: target/GrimVision.jar"
echo ""
echo "To install:"
echo "1. Copy target/GrimVision.jar to your server's plugins folder"
echo "2. Restart the server"
echo ""
