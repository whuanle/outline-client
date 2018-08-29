#!/bin/bash -eux
#
# Copyright 2018 The Outline Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

yarn do www/build

# ugh so hard to get cordova to look at build only
yarn browserify -e build/www/app/cordova_main.js -o www/cordova_main.js

# TODO: babel polyfill
# TODO: env json
# TODO: transpile bower components
# TODO: transpile ui components
# TODO: rtl
# TODO: xcode (for apple)
