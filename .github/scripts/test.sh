#!/bin/bash

- name: Load Xcode version
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: latest-stable

    - name: Install xcpretty
      run: gem install xcpretty

    - name: Run Unit Tests
      run: |
set -eo pipefail

xcodebuild -workspace Courier.xcworkspace \
    -scheme CourierTests \
    -destination platform=iOS\ Simulator,name=iPhone\ 15 \
    clean test | xcpretty