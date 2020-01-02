#!/usr/bin/python
# -*- coding: UTF-8 -*-
import re
import os

def main():
    SDK_URL = ""
    if "SDK_URL" in os.environ:
       SDK_URL = os.environ["SDK_URL"]
        
    TARGET_LIBS_ZIP = "agora_sdk.zip"
    TARGET_INTERNAL_FOLDER = "agora_sdk"

    #if need reset
    ZIP_STRUCTURE_FOLDER = "Agora_Native_SDK_for_iOS_FULL/libs"
    CRY_FRAMEWORK_NAME = "AgoraRtcCryptoLoader.framework"
    FRAMEWORK_NAME = "AgoraRtcEngineKit.framework"

    wget = "wget -q " + SDK_URL + " -O " + TARGET_LIBS_ZIP
    os.system(wget)

    unzip = "unzip -q " + TARGET_LIBS_ZIP + " -d " + TARGET_INTERNAL_FOLDER
    os.system(unzip)

    mv_rtc = "mv -f " + TARGET_INTERNAL_FOLDER + "/" + ZIP_STRUCTURE_FOLDER + "/" + FRAMEWORK_NAME + " \"" + "Agora-With-SenseTime/" + FRAMEWORK_NAME + "\""
    os.system(mv_rtc)

    mv_ecy = "mv -f " + TARGET_INTERNAL_FOLDER + "/" + ZIP_STRUCTURE_FOLDER + "/" + CRY_FRAMEWORK_NAME + " \"" + "Agora-With-SenseTime/" + CRY_FRAMEWORK_NAME + "\""
    os.system(mv_ecy)

    appId = ""
    if "AGORA_APP_ID" in os.environ:
        appId = os.environ["AGORA_APP_ID"]
    token = ""

    senseAppId = ""
    if "SENSE_APP_ID" in os.environ:
        senseAppId = os.environ["SENSE_APP_ID"]
    senseAppKey = ""
    if "SENSE_APP_KEY" in os.environ:
        senseAppKey = os.environ["SENSE_APP_KEY"]

    #if need reset
    f = open("./Agora-With-SenseTime/KeyCenter.m", 'r+')
    content = f.read()

    #if need reset
    agoraAppString = "@\"" + appId + "\""
    agoraTokenString = "@\"" + token + "\""
    contentNew = re.sub(r'<#Agora App Id#>', agoraAppString, content)
    contentNew = re.sub(r'<#Agora App Token#>', agoraTokenString, contentNew)

    senseAppString = "@\"" + senseAppId + "\""
    senseKeyString = "@\"" + senseAppKey + "\""
    contentNew = re.sub(r'<#Sense App Id#>', senseAppString, contentNew)
    contentNew = re.sub(r'<#Sense App Key#>', senseKeyString, contentNew)

    f.seek(0)
    f.write(contentNew)
    f.truncate()


if __name__ == "__main__":
    main()
