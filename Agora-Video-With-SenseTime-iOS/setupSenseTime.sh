#!/bin/bash

echo "======setup start======"

echo "downing..."

curl -OL https://github.com/AgoraIO/Agora-With-SenseTime/releases/download/0.0.1/SenseTime-iOS-Resource.zip


echo "unzip..."
unzip -n SenseTime-iOS-Resource.zip -d tmp/

echo "move libSenseArSourceService.a"
mv tmp/iOS/libSenseArSourceService.a Agora-With-SenseTime/SenseTimePart/SenseArSourceService/lib/ios_universal/

echo "move resources"
mv tmp/iOS/resources/* Agora-With-SenseTime/SenseTimePart/resources

echo "move st_mobile"
mv tmp/iOS/st_mobile/* Agora-With-SenseTime/SenseTimePart/st_mobile

echo "clear"
rm -rf tmp/
rm SenseTime-iOS-Resource.zip

echo "======setup success======"


