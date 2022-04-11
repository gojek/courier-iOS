#!/bin/bash

set -eo pipefail

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierTests \
    -destination platform=iOS\ Simulator,OS=15.2,name=iPhone\ 13 \
    clean test | xcpretty