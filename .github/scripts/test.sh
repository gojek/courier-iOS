#!/bin/bash

set -eo pipefail

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierTests \
    -destination platform=iOS\ Simulator,OS=16.0,name=iPhone\ 13 \
    clean test | xcpretty