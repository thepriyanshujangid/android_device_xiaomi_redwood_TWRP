#!/usr/bin/env bash
#
# Copyright (C) 2023 The TwrpBuilder Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_DEVICE=$1

ROM_EXTRACT_PATH=$2

if [ $# -lt 2 ] ; then
    echo "Usage: setup_prebuilts.sh <device name> <rom dump path>"
    exit
fi

MODULES_PATH=0
COPY_FROM=0

if [ -d "$ROM_EXTRACT_PATH/vendor_dlkm" ] && [ "$(ls -A $ROM_EXTRACT_PATH/vendor_dlkm)" != "" ]; then
    MODULES_PATH=1
    COPY_FROM="$ROM_EXTRACT_PATH/vendor_dlkm/lib/modules"
    echo "/vendor_dlkm found. Using module path $MODULES_PATH"
elif [ -d "$ROM_EXTRACT_PATH/vendor/lib/modules/5.4-gki" ] && [ "$(ls -A $ROM_EXTRACT_PATH/vendor/lib/modules/5.4-gki)" != "" ]; then
    MODULES_PATH=2
    COPY_FROM="$ROM_EXTRACT_PATH/vendor/lib/modules/5.4-gki/"
    echo "/vendor/lib/modules/5.4-gki found. Using module path $MODULES_PATH"
else
    echo "No modules found"
    exit
fi

echo $COPY_FROM

module_list=($(ls -A ./prebuilt/$TARGET_DEVICE/modules/1.1/))

for iterator in ${module_list[*]}; do
    echo "Copying $iterator from $COPY_FROM/$iterator"
    cp $COPY_FROM/$iterator ./prebuilt/$TARGET_DEVICE/modules/1.1/
done