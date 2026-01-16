@echo off
chcp 65001 >nul
echo ========================================
echo   GrimVision - Build Script
echo ========================================
echo.

REM Set Java path (change if needed)
set JAVA_HOME=C:\Program Files\Eclipse Foundation\jdk-16.0.2.7-hotspot
set PATH=%JAVA_HOME%\bin;%PATH%

REM Create build directories
if not exist build mkdir build
if not exist build\classes mkdir build\classes
if not exist target mkdir target

REM Download Spigot API if not exists
if not exist build\spigot-api.jar (
    echo Downloading Spigot API 1.16.5...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://hub.spigotmc.org/nexus/content/repositories/snapshots/org/spigotmc/spigot-api/1.16.5-R0.1-SNAPSHOT/spigot-api-1.16.5-R0.1-20210119.001102-143.jar' -OutFile 'build\spigot-api.jar' -UseBasicParsing } catch { Write-Host 'Download failed. Using cached version or manual download required.' }"
)

if not exist build\spigot-api.jar (
    echo.
    echo ERROR: Spigot API not found!
    echo Please download manually:
    echo 1. Go to: https://getbukkit.org/download/spigot
    echo 2. Download spigot-api-1.16.5.jar
    echo 3. Put it in GrimVision\build\ folder as spigot-api.jar
    echo 4. Run this script again
    pause
    exit /b 1
)

echo.
echo Compiling Java source...
javac -cp "build\spigot-api.jar" -d build\classes src\main\java\com\grimvision\GrimVision.java

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Compilation failed!
    pause
    exit /b 1
)

echo Copying plugin.yml...
copy src\main\resources\plugin.yml build\classes\ >nul

echo Creating JAR file...
cd build\classes
jar cvf GrimVision.jar com\grimvision\*.class plugin.yml >nul
cd ..\..

echo Moving JAR to target folder...
move /Y build\classes\GrimVision.jar target\GrimVision.jar >nul

echo.
echo ========================================
echo   BUILD SUCCESSFUL!
echo ========================================
echo.
echo Output: target\GrimVision.jar
echo.
echo To install:
echo 1. Copy target\GrimVision.jar to your server's plugins folder
echo 2. Restart the server
echo.
pause
