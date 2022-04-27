#!/bin/bash

set -eo pipefail

pod trunk push --allow-warnings master CourierCore.podspec
pod trunk push --allow-warnings master CourierMQTT.podspec
pod trunk push --allow-warnings master CourierProtobuf.podspec
pod trunk push --allow-warnings master MQTTClientGJ.podspec