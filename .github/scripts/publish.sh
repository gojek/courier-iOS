#!/bin/bash

set -eo pipefail

pod trunk push --allow-warnings MQTTClientGJ.podspec
pod trunk push --allow-warnings CourierCore.podspec
pod trunk push --allow-warnings CourierMQTT.podspec
pod trunk push --allow-warnings CourierProtobuf.podspec