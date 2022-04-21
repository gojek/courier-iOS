#!/bin/bash

set -eo pipefail

echo "Building CourierCore"

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierCore \
    -destination "generic/platform=iOS Simulator"
    -configuration Release 

echo "Building CourierMQTT"

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierMQTT \
    -destination "generic/platform=iOS Simulator"
    -configuration Release 

echo "Building CourierCommonClient"

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierCommonClient \
    -destination "generic/platform=iOS Simulator"
    -configuration Release 

echo "Building CourierProtobuf"

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierProtobuf \
    -destination "generic/platform=iOS Simulator"
    -configuration Release