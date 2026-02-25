#!/bin/bash -e
# frameworks=("GRDB")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"

rm -rf derived_data/
rm -rf archives/

framework_name="MQTTClientGJ"
scheme="MQTTClientGJ"
workspace="Courier.xcworkspace"

rm -rf $framework_name.xcframework
echo "Archiving $framework_name to XCFramework"

xcodebuild archive \
    -workspace  $workspace\
    -scheme $scheme \
    -derivedDataPath derived_data/$framework_name-iOS \
    -destination "generic/platform=iOS" \
    -sdk iphoneos \
    -archivePath archives/$framework_name-iOS \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO 

xcodebuild archive \
    -workspace $workspace \
    -scheme $scheme \
    -derivedDataPath derived_data/$framework_name-iOS-Simulator \
    -destination "generic/platform=iOS Simulator" \
    -sdk iphonesimulator \
    -archivePath archives/$framework_name-iOS-Simulator \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO 

xcodebuild -create-xcframework \
    -framework "archives/$framework_name-iOS.xcarchive/Products/Library/Frameworks/$framework_name.framework" \
    -framework "archives/$framework_name-iOS-Simulator.xcarchive/Products/Library/Frameworks/$framework_name.framework" \
    -output "$framework_name.xcframework"

echo "Archiving $framework_name to XCFramework Succeeded"

# for framework_name in ${frameworks[@]}; do

# done

# echo "All XCFramework Targets Archive Succeeded"