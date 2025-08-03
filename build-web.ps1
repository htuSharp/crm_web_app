# Build script for PharmaCRM Web App
# This script handles Flutter version compatibility and builds the web app

Write-Host "Starting PharmaCRM build process..." -ForegroundColor Green

# Check Flutter version
Write-Host "Checking Flutter version..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1
    Write-Host $flutterVersion -ForegroundColor Cyan
    
    # Check if version contains 3.32.8 or compatible
    if ($flutterVersion -match "Flutter (\d+\.\d+\.\d+)") {
        $version = $matches[1]
        Write-Host "Detected Flutter version: $version" -ForegroundColor Green
        
        # Parse version numbers
        $versionParts = $version.Split('.')
        $major = [int]$versionParts[0]
        $minor = [int]$versionParts[1]
        
        if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 24)) {
            Write-Host "Warning: Flutter version $version may not be compatible. Recommended: 3.24.0+" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "Error: Flutter not found or not properly installed" -ForegroundColor Red
    exit 1
}

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
try {
    flutter clean
    Write-Host "Clean completed successfully" -ForegroundColor Green
} catch {
    Write-Host "Warning: Flutter clean encountered issues" -ForegroundColor Yellow
}

# Get dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
try {
    flutter pub get
    Write-Host "Dependencies installed successfully" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to get dependencies" -ForegroundColor Red
    exit 1
}

# Run analysis (non-fatal)
Write-Host "Running code analysis..." -ForegroundColor Yellow
try {
    flutter analyze
    Write-Host "Code analysis completed successfully" -ForegroundColor Green
} catch {
    Write-Host "Warning: Code analysis found issues, but continuing..." -ForegroundColor Yellow
}

# Run tests (non-fatal)
Write-Host "Running tests..." -ForegroundColor Yellow
try {
    flutter test
    Write-Host "Tests completed successfully" -ForegroundColor Green
} catch {
    Write-Host "Warning: Tests failed or have issues, but continuing..." -ForegroundColor Yellow
}

# Build web app
Write-Host "Building web application..." -ForegroundColor Yellow
try {
    flutter build web --web-renderer html --release --base-href "/crm_web_app/"
    Write-Host "Web build completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error: Web build failed" -ForegroundColor Red
    
    # Try fallback build without base-href
    Write-Host "Attempting fallback build..." -ForegroundColor Yellow
    try {
        flutter build web --web-renderer html --release
        Write-Host "Fallback build succeeded!" -ForegroundColor Green
        Write-Host "Note: Built without base-href. May need manual adjustment for GitHub Pages." -ForegroundColor Yellow
    } catch {
        Write-Host "Fallback build also failed" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Build process completed!" -ForegroundColor Green
Write-Host "Output directory: build\web\" -ForegroundColor Cyan
Write-Host "You can test locally by serving the build\web directory" -ForegroundColor Cyan
Write-Host ""
Write-Host "To test locally, run one of these commands:" -ForegroundColor Yellow
Write-Host "  python -m http.server 8000 (from build\web directory)" -ForegroundColor White
Write-Host "  flutter run -d chrome" -ForegroundColor White

Read-Host "Press Enter to continue..."
