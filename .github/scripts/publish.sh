#!/bin/bash

set -eo pipefail

pod repo push --allow-warnings master CourierCore.podspec
pod repo push --allow-warnings master CourierMQTT.podspec
pod repo push --allow-warnings master CourierCommonClient.podspec
pod repo push --allow-warnings master CourierProtobuf.podspec
pod repo push --allow-warnings master MQTTClientGJ.podspec