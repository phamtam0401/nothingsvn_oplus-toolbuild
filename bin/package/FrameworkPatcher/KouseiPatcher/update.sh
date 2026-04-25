work_dir=$(pwd)
source $work_dir/functions.sh
prop="$work_dir/bin/shPlugin/KouseiPatcher/prop"
sdkLevel=$(< $work_dir/build/baserom/images/system/system/build.prop grep "ro.system.build.version.sdk" |awk 'NR==1' |cut -d '=' -f 2)
appdir="$work_dir/bin/shPlugin/KouseiPatcher/app"

bash $work_dir/bin/shPlugin/KouseiPatcher/patcher.sh

if [ -f $work_dir/build/baserom/images/system/system/etc/init/hw/init.rc ];then
setprop_rc "on boot" "setprop persist.sys.kaorios kousei" "$work_dir/build/baserom/images/system/system/etc/init/hw/init.rc"
fi

cp -rf $appdir/KaoriosToolbox $work_dir/build/baserom/images/system/system/priv-app
cp -rf $appdir/privapp_whitelist_com.kousei.kaorios.xml $work_dir/build/baserom/images/system/system/etc/permissions
cat $prop/build.prop >> $work_dir/build/baserom/images/system/system/build.prop

if [ -f $work_dir/framework.jar ]; then
cp -rf $work_dir/framework.jar $work_dir/build/baserom/images/system/system/framework/
rm -rf $work_dir/framework.jar
fi