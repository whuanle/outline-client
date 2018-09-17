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

# THINK:
#  - build/electron/electron: main
#  - build/electron/www: renderer

# TODO: consider another build target that produces, e.g. ES6
yarn do src/www/build

# populate build/electron
tsc -p src/electron
rsync -ac --exclude '*.ts' src/electron build/

# ugh, copy www into build/electron/
rsync -ac www build/electron/

# Copy binaries into the Electron folder.
# The destination folder must be kept in sync with:
#  - the value specified for --config.asarUnpack in package_action.sh
#  - the value returned by process_manager.ts#pathToEmbeddedExe
readonly BIN_DEST=build/electron/bin/win32
mkdir -p $BIN_DEST
rsync -ac \
  third_party/shadowsocks-libev/windows/ third_party/badvpn/windows/ \
  $BIN_DEST

# Copy files for OutlineService.
cp src/electron/install_windows_service.bat build/electron/
rsync -ac \
  --include '*.exe' --include '*.dll' \
  --exclude='*' \
  third_party/newtonsoft/ tools/OutlineService/OutlineService/bin/ \
  build/electron/

# Version info and Sentry config.
# In Electron, the path is relative to electron_index.html.
scripts/environment_json.sh -p windows > build/electron/www/environment.json

# We need a top-level index.js.
# Its only job is to load electron/index.js.
cat << EOM > build/electron/index.js
require('./electron');
EOM

# Not strictly necessary when running from the command line but this sets fields
# such as productName which influences things like the appData directory, easing
# debugging.
cp package.json build/electron/

# Icons.
electron-icon-maker --input=src/electron/logo.png --output=build/electron
