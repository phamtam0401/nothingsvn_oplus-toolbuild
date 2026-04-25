work_dir=$(pwd)
source $work_dir/functions.sh
MAIN_FOLDER="$work_dir/build/baserom/images"

cp -rf $work_dir/bin/package/Universal/Fingerprint/overlay/* $MAIN_FOLDER/my_product/overlay/
