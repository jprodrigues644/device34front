#!/usr/bin/env bash

set -euo pipefail

echo "========================================="
echo " Running Frontend Tests"
echo "========================================="

# Variables
RESULTS_DIR="test-results"

# Clean previous results
echo "Cleaning previous test artifacts..."
rm -rf "$RESULTS_DIR"
mkdir -p "$RESULTS_DIR"

# Check Node.js installation
if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: Node.js is not installed"
  exit 1
fi

# Check npm installation
if ! command -v npm >/dev/null 2>&1; then
  echo "ERROR: npm is not installed"
  exit 1
fi

# Check package.json
if [ ! -f package.json ]; then
  echo "ERROR: package.json not found"
  exit 1
fi

echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"

# Installation of dependencies
echo "Installing dependencies..."
npm ci --cache .npm --prefer-offline

# Installation reporter JUnit si absent
if ! npm list karma-junit-reporter >/dev/null 2>&1; then
  echo "Installing karma-junit-reporter..."
  npm install --save-dev karma-junit-reporter
fi

# Launching Angular tests
echo "Running Angular tests..."

npm test -- \
  --watch=false \
  --browsers=ChromeHeadless

TEST_EXIT_CODE=$?

# General verificationon rapport
if [ -d "$RESULTS_DIR" ]; then
  echo "Test reports generated in $RESULTS_DIR/"
else
  echo "WARNING: No test report generated"
fi

# 
if [ $TEST_EXIT_CODE -ne 0 ]; then
  echo "Frontend tests failed"
  exit $TEST_EXIT_CODE
fi

echo "Frontend tests completed successfully"
exit 0