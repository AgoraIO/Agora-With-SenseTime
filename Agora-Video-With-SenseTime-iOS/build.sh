#if need reset
PROJECT_NAME="Agora-With-SenseTime.xcodeproj"
SCHEME_NAME="Agora-With-SenseTime"
BUILD_DATE=`date +%Y-%m-%d-%H.%M.%S`
ArchivePath=${SCHEME_NAME}-${BUILD_DATE}.xcarchive

xcodebuild clean -project ${PROJECT_NAME} -scheme ${SCHEME_NAME} -configuration Release
xcodebuild -project ${PROJECT_NAME} -scheme ${SCHEME_NAME} -archivePath ${ArchivePath} archive
xcodebuild -exportArchive -exportOptionsPlist exportPlist.plist -archivePath ${ArchivePath} -exportPath .
