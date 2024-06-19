#!/bin/bash
# adsbxfeed.sh from https://github.com/snstac/adsbxfeed
#
# Copyright Sensors & Signals LLC https://www.snstac.com
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

CONF_FILE="/etc/AryaOS/adsbxfeed.conf"

if [ -f $CONF_FILE ]; then
  # shellcheck source=SCRIPTDIR/../../etc/AryaOS/adsbxfeed.conf
  . $CONF_FILE
else
  echo "$CONF_FILE doesn't exist, exiting."
  exit 1
fi

if ! [[ -d $RUN_DIR ]]; then
    mkdir -p "$RUN_DIR"
fi

if [[ -z $INPUT ]]; then
    INPUT="127.0.0.1:30005"
fi

INPUT_IP=$(echo "$INPUT" | cut -d: -f1)
INPUT_PORT=$(echo "$INPUT" | cut -d: -f2)
SOURCE="$INPUT_IP,$INPUT_PORT,beast_in,silent_fail"

if [[ -z $UAT_INPUT ]]; then
    UAT_INPUT="127.0.0.1:30978"
fi

UAT_IP=$(echo "$UAT_INPUT" | cut -d: -f1)
UAT_PORT=$(echo "$UAT_INPUT" | cut -d: -f2)
UAT_SOURCE="$UAT_IP,$UAT_PORT,uat_in,silent_fail"

options=(--net --net-only --quiet 
    --uuid-file="$UUID_FILE" 
    --write-json="$RUN_DIR" 
    --lat="$LATITUDE" 
    --lon="$LONGITUDE" 
    --net-connector="$TARGET" 
    --net-connector="$SOURCE"
    --net-connector="$UAT_SOURCE" 
    --net-beast-reduce-interval="$REDUCE_INTERVAL" 
    "$NET_OPTIONS" 
    "$JSON_OPTIONS" 

)

exec /usr/bin/readsb "${options[@]}"