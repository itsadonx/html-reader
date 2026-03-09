#!/bin/sh
#
# Gradle wrapper script for Unix (used by GitHub Actions and Mac/Linux)

set -e

DIRNAME=$(dirname "$0")
PROJECT_DIR=$(cd "$DIRNAME" && pwd)
WRAPPER_JAR="$PROJECT_DIR/gradle/wrapper/gradle-wrapper.jar"
LAUNCHER=org.gradle.wrapper.GradleWrapperMain

if [ ! -f "$WRAPPER_JAR" ]; then
  echo "Gradle wrapper JAR not found. Run build-apk.ps1 (Windows) or create wrapper with: gradle wrapper"
  exit 1
fi

exec java -Dfile.encoding=UTF-8 -classpath "$WRAPPER_JAR" $LAUNCHER "$@"
