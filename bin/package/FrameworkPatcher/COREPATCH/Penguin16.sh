dir=$(pwd)
source $dir/functions.sh
sdkLevel=$(cat $dir/bin/ddevice/sdkLevel.txt)

bash $dir/bin/shPlugin/COREPATCH/patcher.sh $sdkLevel --framework --services --disable-signature-verification --disable-secure-flag

if [ -f $dir/framework.jar ]; then
mods "Moving Framework To Original Dirc.."
cp -rf $dir/framework.jar $dir/build/baserom/images/system/system/framework/
rm -rf $dir/framework.jar
fi

if [ -f $dir/services.jar ]; then
mods "Moving Services To Original Dirc.."
cp -rf $dir/services.jar $dir/build/baserom/images/system/system/framework/
rm -rf $dir/services.jar
fi