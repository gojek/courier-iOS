#!/bin/bash

set -eo pipefail

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierTests \
    -destination 'platform=iOS Simulator,name=iPhone Air' \
    clean test | xcpretty