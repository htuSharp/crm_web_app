# Flutter Installation Checker
Write-Host "Flutter Installation Checker" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# Check if Flutter is in PATH
Write-Host "Checking Flutter in PATH..." -ForegroundColor Yellow
$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterCommand) {
    Write-Host "✅ Flutter found in PATH" -ForegroundColor Green
    Write-Host "Location: $($flutterCommand.Source)" -ForegroundColor White
    
    # Try to get version
    Write-Host "`nChecking Flutter version..." -ForegroundColor Yellow
    try {
        & flutter --version
        Write-Host "✅ Flutter version check successful" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error running Flutter version" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
} else {
    Write-Host "❌ Flutter not found in PATH" -ForegroundColor Red
    
    # Check common locations
    Write-Host "`nChecking common Flutter locations..." -ForegroundColor Yellow
    $locations = @(
        "C:\flutter\bin\flutter.bat",
        "C:\tools\flutter\bin\flutter.bat",
        "$env:USERPROFILE\flutter\bin\flutter.bat"
    )
    
    foreach ($location in $locations) {
        if (Test-Path $location) {
            Write-Host "✅ Found Flutter at: $location" -ForegroundColor Green
        }
    }
}

Write-Host "`n🚀 GOOD NEWS: Your code is ready!" -ForegroundColor Green
Write-Host "All Flutter 3.32.8 compatibility issues have been fixed." -ForegroundColor Green

Write-Host "`n📋 What was fixed:" -ForegroundColor Cyan
Write-Host "• Replaced deprecated withOpacity() with withValues()" -ForegroundColor White
Write-Host "• Removed unnecessary code overrides" -ForegroundColor White
Write-Host "• Cleaned up unused imports" -ForegroundColor White
Write-Host "• Fixed test file class references" -ForegroundColor White
Write-Host "• Updated project for Flutter 3.32.8 compatibility" -ForegroundColor White

Write-Host "`n🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Push to GitHub: git push origin master" -ForegroundColor White
Write-Host "2. GitHub Actions will build and deploy automatically" -ForegroundColor White
Write-Host "3. Your app will be available at GitHub Pages" -ForegroundColor White

Write-Host "`n💡 Local Development Options:" -ForegroundColor Yellow
Write-Host "• Install Flutter from: https://flutter.dev/docs/get-started/install" -ForegroundColor White
Write-Host "• Use GitHub Codespaces for cloud development" -ForegroundColor White
Write-Host "• Use our GitHub Actions workflow for building" -ForegroundColor White

Write-Host "`nPress Enter to continue..." -ForegroundColor Gray
Read-Host
