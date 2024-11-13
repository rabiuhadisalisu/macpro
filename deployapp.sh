#!/bin/bash

# Stop the script if any command fails
set -e

# 1. Checkout repository
echo "Cloning repository..."
git clone https://github.com/rabiuhadisalisu/citypressapp.git  # Replace with your repository URL
cd citypressapp  # Change to your project directory

# 2. Install Flutter using Homebrew
echo "Updating Homebrew and installing Flutter..."
brew update
brew install --cask flutter  # Install Flutter
brew install gradle  # Install Gradle as a backup if required

# 3. Install Android SDK tools
echo "Installing Android SDK..."
brew install --cask android-sdk
export ANDROID_HOME=/usr/local/share/android-sdk
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# 4. Set up Java (ensure Java 17 is installed)
echo "Installing Java 17..."
brew install --cask adoptopenjdk17  # Install Java 17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH

# 5. Check Flutter version
echo "Checking Flutter version..."
flutter --version

# 6. Clean Flutter project (to avoid conflicts)
echo "Cleaning Flutter project..."
flutter clean

# 7. Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# 8. Generate Gradle Wrapper if not already present
echo "Generating Gradle Wrapper if not already present..."
if [ ! -f "./gradlew" ]; then
  echo "Generating Gradle Wrapper..."
  cd android
  gradle wrapper  # Generate the Gradle wrapper if it doesn't exist
  cd ..
fi

# 9. Run Gradle wrapper to download dependencies
echo "Running Gradle to download dependencies..."
cd android  # Change to android directory
./gradlew --no-daemon buildEnvironment
./gradlew --no-daemon clean build  # Ensure dependencies are downloaded
cd ..

# 10. Build the APK
echo "Building the APK..."
flutter build apk --release

# 11. Upload APK as artifact (simulated in local bash)
echo "Uploading APK as artifact..."
# Assuming you want to keep the APK in your local directory, you can upload manually or integrate with a tool.
# Example path:
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
echo "APK path: $APK_PATH"
# Add your custom artifact upload logic here (e.g., using a cloud storage API)

echo "Build complete!"
