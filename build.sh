#!/bin/bash

### Prema Chand Alugu (premaca@gmail.com)
### Shivam Desai (shivamdesaixda@gmail.com)
### A custom build script to build zImage & DTB(Anykernel2 method)

set -e

## Copy this script inside the kernel directory
KERNEL_DIR=$PWD
KERNEL_TOOLCHAIN=$(pwd)/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_DEFCONFIG=X00TD_defconfig
JOBS=8
ANY_KERNEL2_DIR=$KERNEL_DIR/AnyKernel2/
FINAL_KERNEL_ZIP=SphericalKernel-R1-X00TD.zip

# Export User & Host
export KBUILD_BUILD_USER=Spherical
export KBUILD_BUILD_HOST=Kat

# Clean build always lol
echo "**** Cleaning ****"
mkdir -p out
make O=out clean
make O=out mrproper

# The MAIN Part
echo "**** Setting Toolchain ****"
export CROSS_COMPILE=$KERNEL_TOOLCHAIN
export ARCH=arm64 && export SUBARCH=arm64
echo "**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****"
make O=out $KERNEL_DEFCONFIG
make O=out -j$JOBS


echo "**** Verify zImage & dtb ****"
ls $KERNEL_DIR/out/arch/arm64/boot/Image.gz

#Anykernel 2 time!!
echo "**** Verifying Anyernel2 Directory ****"
ls $ANY_KERNEL2_DIR
echo "**** Removing leftovers ****"
rm -rf $ANY_KERNEL2_DIR/Image.gz
rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
rm -rf $FINAL_KERNEL_ZIP

echo "**** Copying zImage ****"
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz $ANY_KERNEL2_DIR/

echo "**** Time to zip up! ****"
cd $ANY_KERNEL2_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
cp $FINAL_KERNEL_ZIP $KERNEL_DIR/

echo "**** Good Bye!! ****"
cd $KERNEL_DIR
rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
rm -rf AnyKernel2/Image.gz

curl -F chat_id="-1001245147279" -F document="CAADBQADIgADTBCSGjYU8tTvyHO6Ag" https://api.telegram.org/bot$BOT_API_KEY/sendDocument
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Device: *X00TD*" -d chat_id="@nubci" -d parse_mode="Markdown"
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Branch: $(git rev-parse --abbrev-ref HEAD)" -d chat_id="@nubci" -d parse_mode="Markdown"
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Commit: <code>$(git log --pretty=format:'%h : %s' -1)</code>" -d chat_id="@nubci" -d parse_mode="HTML"
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Download:" -d chat_id="@nubci"
curl -F chat_id="-1001245147279" -F document=@"$KERNEL_DIR/$FINAL_KERNEL_ZIP" https://api.telegram.org/bot$BOT_API_KEY/sendDocument
