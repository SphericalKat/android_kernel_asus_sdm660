# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=SphericalKernel
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=X00TD
device.name2=X00TD
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
# alert of unsupported Android version
android_ver=$(grep "^ro.build.version.release" /system/build.prop | cut -d= -f2);
case "$android_ver" in
  "8.0.0"|"8.1.0") support_status="supported";;
  *) support_status="unsupported";;
esac;
ui_print " ";
ui_print "Running Android $android_ver..."
ui_print "This kernel is $support_status for this version!";

dump_boot;

# begin ramdisk changes

# end ramdisk changes

write_boot;

## end install

