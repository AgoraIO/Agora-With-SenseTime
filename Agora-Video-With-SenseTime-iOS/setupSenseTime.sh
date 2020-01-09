#!/bin/bash

AgoraModuleVersion="1.1.0"

echo "======setup start======"

echo "downing..."
curl -OL https://github.com/AgoraIO/Agora-With-SenseTime/releases/download/0.0.1/SenseTime-iOS-Resource.zip
curl -OL "https://download.agora.io/components/release/AgoraModule_Base_iOS-${AgoraModuleVersion}.zip"
curl -OL "https://download.agora.io/components/release/AgoraModule_Capturer_iOS-${AgoraModuleVersion}.zip"

echo "unzip..."

rm -rf tmp/
mkdir tmp
mkdir tmp/AgoraModule

unzip -n SenseTime-iOS-Resource.zip -d tmp/
unzip -n "AgoraModule_Base_iOS-${AgoraModuleVersion}.zip" -d tmp/AgoraModule/
unzip -n "AgoraModule_Capturer_iOS-${AgoraModuleVersion}.zip" -d tmp/AgoraModule/

echo "move AgoraModule"
mv tmp/AgoraModule/* Agora-With-SenseTime/

echo "move libSenseArSourceService.a"
mv tmp/SenseTime-iOS-Resource/SenseTime/libSenseArSourceService.a Agora-With-SenseTime/SenseTimePart/SenseArSourceService/lib/ios_universal/

echo "move resources"
mv tmp/SenseTime-iOS-Resource/SenseTime/resources/* Agora-With-SenseTime/SenseTimePart/resources

echo "move st_mobile"
mv tmp/SenseTime-iOS-Resource/SenseTime/st_mobile/* Agora-With-SenseTime/SenseTimePart/st_mobile

echo "clear"
rm -rf tmp/
rm SenseTime-iOS-Resource.zip
rm "AgoraModule_Base_iOS-${AgoraModuleVersion}.zip"
rm "AgoraModule_Capturer_iOS-${AgoraModuleVersion}.zip"

echo "======setup success======"


