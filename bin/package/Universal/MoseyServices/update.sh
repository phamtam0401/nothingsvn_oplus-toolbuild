work_dir=$(pwd)
source $work_dir/functions.sh
MAIN_FOLDER="$work_dir/build/baserom/images"
HOOKS="$work_dir/bin/package/Universal/MoseyServices/hook"

echo "[MODS] - Adding MoseyServices..."
cp -rf $work_dir/bin/package/Universal/MoseyServices/odm $MAIN_FOLDER
cp -rf $work_dir/bin/package/Universal/MoseyServices/system_ext $MAIN_FOLDER
echo "com.google.android.moseyservice.IMoseyService/default   u:object_r:mosey_service:s0" >> $MAIN_FOLDER/odm/etc/selinux/precompiled_service_contexts
echo "/(vendor|odm)/bin/mosey_server    u:object_r:mosey_server_exec:s0" >> $MAIN_FOLDER/odm/etc/selinux/precompiled_file_contexts
echo "/(vendor|odm)/bin/mosey_server    u:object_r:mosey_server_exec:s0" >> $MAIN_FOLDER/vendor/etc/selinux/vendor_file_contexts
echo "com.google.android.moseyservice.IMoseyService/default   u:object_r:mosey_service:s0" >> $MAIN_FOLDER/vendor/etc/selinux/vendor_service_contexts
echo "user=_app isPrivApp=true name=com.google.android.mosey domain=mosey_app type=app_data_file levelFrom=all" >> $MAIN_FOLDER/system_ext/etc/selinux/system_ext_seapp_contexts
echo "<hidden-api-whitelisted-app package=\"com.google.android.mosey\" />" >> $MAIN_FOLDER/system_ext/etc/sysconfig/hidden-api-whitelist.xml
xmlstarlet ed -L \
  -s "/compatibility-matrix" -t elem -n "hal" -v "" \
  -i "/compatibility-matrix/hal[last()]" -t attr -n "format" -v "aidl" \
  -s "/compatibility-matrix/hal[last()]" -t elem -n "name" -v "com.google.android.moseyservice" \
  -s "/compatibility-matrix/hal[last()]" -t elem -n "interface" -v "" \
  -s "/compatibility-matrix/hal[last()]/interface" -t elem -n "name" -v "IMoseyService" \
  -s "/compatibility-matrix/hal[last()]/interface" -t elem -n "instance" -v "default" \
  $MAIN_FOLDER/system/system/etc/vintf/compatibility_matrix.device.xml
xmlstarlet ed -L \
  -s "/config" -t elem -n "hidden-api-whitelisted-app" -v "" \
  -i "/config/hidden-api-whitelisted-app[last()]" -t attr -n "package" -v "com.google.android.mosey" \
  $MAIN_FOLDER/system_ext/etc/sysconfig/hidden-api-whitelist-ext.xml
cat $HOOKS/system_ext/24policy.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/202404.cil
cat $HOOKS/system_ext/25policy.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/202504.cil
cat $HOOKS/system_ext/apimap.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/29.0.cil
cat $HOOKS/system_ext/apimap.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/30.0.cil
cat $HOOKS/system_ext/apimap.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/31.0.cil
cat $HOOKS/system_ext/apimap.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/32.0.cil
cat $HOOKS/system_ext/apimap.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/33.0.cil
cat $HOOKS/system_ext/apimap.txt >> $MAIN_FOLDER/system_ext/etc/selinux/mapping/34.0.cil
cat $HOOKS/system_ext/policy.txt >> $MAIN_FOLDER/system_ext/etc/selinux/system_ext_sepolicy.cil
cat $HOOKS/system_ext/policy_debug.txt >> $MAIN_FOLDER/system_ext/etc/selinux/system_ext_sepolicy_debug.cil
cat $HOOKS/vendor/plat.txt >> $MAIN_FOLDER/vendor/etc/selinux/plat_pub_versioned.cil
cat $HOOKS/vendor/plat_debug.txt >> $MAIN_FOLDER/vendor/etc/selinux/plat_pub_versioned_debug.cil
cat $HOOKS/vendor/policy.txt >> $MAIN_FOLDER/vendor/etc/selinux/vendor_sepolicy.cil
cat $HOOKS/vendor/policy_debug.txt >> $MAIN_FOLDER/vendor/etc/selinux/vendor_sepolicy_debug.cil
echo "[MODS] - Done"
