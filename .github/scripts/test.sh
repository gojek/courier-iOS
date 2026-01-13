#!/bin/bash

set -eo pipefail

# Parse arguments
CLEAN_ARG="clean"
if [ "$1" = "--no-clean" ]; then
    CLEAN_ARG=""
fi

# First attempt
if xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierTests \
    -destination 'platform=iOS Simulator,name=iPhone 17' \
    -parallel-testing-enabled NO \
    $CLEAN_ARG test | xcpretty; then
    exit 0
fi

# Retry without clean on failure
if [ -n "$CLEAN_ARG" ]; then
    echo "Test failed, retrying without clean..."
    xcodebuild -workspace Courier.xcworkspace \
        -scheme CourierTests \
        -destination 'platform=iOS Simulator,name=iPhone 17' \
        -parallel-testing-enabled NO \
        test | xcpretty
fi