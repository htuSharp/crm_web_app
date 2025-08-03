@echo off
REM Build script for PharmaCRM Web App
REM This script handles Flutter version compatibility and builds the web app

echo Starting PharmaCRM build process...

REM Check Flutter version
echo Checking Flutter version...
flutter --version
if %ERRORLEVEL% NEQ 0 (
    echo Error: Flutter not found or not properly installed
    exit /b 1
)

REM Clean previous builds
echo Cleaning previous builds...
flutter clean
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Flutter clean encountered issues
)

REM Get dependencies
echo Installing dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to get dependencies
    exit /b 1
)

REM Run analysis (non-fatal)
echo Running code analysis...
flutter analyze
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Code analysis found issues, but continuing...
)

REM Run tests (non-fatal)
echo Running tests...
flutter test
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Tests failed or have issues, but continuing...
)

REM Build web app
echo Building web application...
flutter build web html --release --base-href "/crm_web_app/"
if %ERRORLEVEL% NEQ 0 (
    echo Error: Web build failed
    exit /b 1
)

echo Build completed successfully!
echo Output directory: build\web\
echo You can test locally by serving the build\web directory

pause
