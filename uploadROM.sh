#!/bin/bash
# SPDX-License-Identifier: GPL-3.0

#!/bin/bash

work_dir=$(pwd)
source "$work_dir/functions.sh"

ANDROID_VER=$(cat "$work_dir/bin/ddevice/androidver.txt")
DEVICE_MODEL=$(cat "$work_dir/bin/ddevice/device_model.txt")
BASE_BUILD_ID=$(cat "$work_dir/bin/ddevice/base_build_id.txt")
BRAND=$(cat "$work_dir/bin/ddevice/brand.txt")

# Unified naming to prevent 1DRIVE/GDRIVE confusion
RCLONE_CONFIG_FILE="$work_dir/rclone.conf"
CLOUD_REMOTE="drive1"

# ---------------------------------------------------------
# DEFINE VARIABLES FIRST (So the 'dummy' block can use them)
# ---------------------------------------------------------
VERSION="$(cat "$work_dir/Version")"

if [[ $(git branch --show-current) == "beta" ]]; then
    status="Beta"
else
    status="Official"
fi

if [[ "$BRAND" == "OnePlus" ]]; then
    NTBUILD="ColorOS"
    uploaddir="ColorOS"
elif [[ "$BRAND" == "OnePlus_Global" ]]; then
    NTBUILD="OxygenOS"
    uploaddir="OxygenOS"
elif [[ "$BRAND" == "RealmeUI" ]]; then
    NTBUILD="RealmeUI"
    uploaddir="RealmeUI"
else
    # Good practice to have a fallback just in case
    NTBUILD="Unknown"
    uploaddir="Unknown"
fi

# ---------------------------------------------------------
# ARGUMENT HANDLING
# ---------------------------------------------------------
if [ "$1" == "setup" ]; then
    if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
        echo "[ERROR] - Please provide rclone token, repo owner/name, and file path"
        exit 1
    fi
    curl -s -o "$RCLONE_CONFIG_FILE" \
         -H "Authorization: token $2" \
         -H "Accept: application/vnd.github.v3.raw" \
         -L "https://api.github.com/repos/$3/contents/$4"
    exit 0

elif [ "$1" == "dummy" ]; then
    # Fixed undefined $RCLONE_CONFIG_1DRIVE and $FILENAME
    rclone -v --config="$RCLONE_CONFIG_FILE" copy "$work_dir/dummy.txt" "$CLOUD_REMOTE:NTBuild/${uploaddir}/${VERSION}/${DEVICE_MODEL}/" || {
        echo "[CLOUD] - Error uploading file to Cloud: dummy.txt"
        exit 1
    }
    exit 0
fi

# ---------------------------------------------------------
# MAIN BUILD PROCESSING
# ---------------------------------------------------------
# Added quotes around variables to prevent word-splitting issues
hash=$(md5sum "out/${NTBUILD}_${DEVICE_MODEL}_${ANDROID_VER}_OS${BASE_BUILD_ID}.zip" | head -c 5)
output_file="out/${NTBUILD}_${VERSION}_${DEVICE_MODEL}_OS${BASE_BUILD_ID}_${hash}_${status}.zip"

mv "out/${NTBUILD}_${DEVICE_MODEL}_${ANDROID_VER}_OS${BASE_BUILD_ID}.zip" "$output_file"

echo "[SCRIPT] - Output: "
echo "$output_file"
echo "[CLOUD] - Uploading"

# Fixed undefined rclone config variable
rclone -v --config="$RCLONE_CONFIG_FILE" copy "$output_file" "$CLOUD_REMOTE:NTBuild/${uploaddir}/${VERSION}/${DEVICE_MODEL}/" || {
    echo "[CLOUD] - Error uploading file to Cloud: $output_file"
    exit 1
}

echo "[SYSTEM] - Clean Workflow.."
rm -rf "$work_dir/out"
rm -rf "$work_dir/build"

echo "[INFO] - Build ${NTBUILD}_${VERSION} for ${DEVICE_MODEL} successful !"
