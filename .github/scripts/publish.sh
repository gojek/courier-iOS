#!/bin/bash

set -eo pipefail

pod trunk push --allow-warnings MQTTClientGJ.podspec
pod trunk push --allow-warnings CourierCore.podspec
pod trunk push --allow-warnings --synchronous CourierMQTT.podspec
pod trunk push --allow-warnings --synchronous CourierProtobuf.podspec

# Commented out temporarily due to missing ownership of the pod
# pod trunk push --allow-warnings --synchronous CourierMQTTChuck.podspec