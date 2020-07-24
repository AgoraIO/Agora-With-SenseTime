# Agora RTC with SenseTime Android

A tutorial demo for Agora Video SDK can be found here: [Agora-Android-Tutorial-1to1](https://github.com/AgoraIO/Basic-Video-Call/tree/master/One-to-One-Video/Agora-Android-Tutorial-1to1)

This demo demonstrates the combined use of Agora RTC sdk and SenseTime beautification library. You can do:

- Join a channel and have video a chatting with friends;
- SenseTime beauty, makeups and stickers for your video.

## 1 Configuration

### 1.1 Agora RTC
#### 1.1.1 App Id

Create a developer account at [Agora.io](https://dashboard.agora.io/signin/), create a new project and obtain an App ID as the identification of the running app. Update "app/src/main/res/values/strings-config.xml" with your App ID.

```
<string name="AGORA_APP_ID"><#YOUR APP ID#></string>
```

#### 1.1.2 Agora SDK

There are two ways to add Agora Video SDK to the project:

* JCenter (recommended)
* Download SDK from [Agora.io SDK](https://docs.agora.io/en/Agora%20Platform/downloads)

**The first method** will download Agora Video SDK automatically from JCenter when the project is building. Add the following line to "app/build.gradle" (which is default in the project):
```
implementation 'io.agora.rtc:full-sdk:2.9.2'
```

**The second method** needs developers to download SDK and copy the unzipped library files to proper project folders (acquires knowledge of the project structure):

* Copy ***.jar** under **libs** to **app/libs**
* Copy **arm64-v8a**/**x86**/**armeabi-v7a** under **libs** to **app/src/main/jniLibs**.
* Add the following code in the property of the dependence of the "app/build.gradle":

```
implementation fileTree(dir: 'libs', include: ['*.jar'])
```

### 1.2 SenseTime

#### 1.2.1 SenseTime SDK

Most the of code of SenseTime SDK is already provided in the **"sensetime"** module of the demo project. But things to note that developers need to download and copy .so libraries to **"sensetime/src/main/jni/prebuilt/lib"** folder:
```
    lib
      |_ arm64-v8a
         libst_mobile.so
         
      |_ armeabi-v7a
         libst_mobile.so
```

Other native code and JNI interfaces are all in the jni folder. If you have problems building C code for the first time, you may try to select **"Build->Make Project"** or sync the gradle project.

#### 1.2.2 SenseTime Resources

Copy all resource files to **"app/src/main/assets"** from the download link.


#### 1.2.3 SenseTime Licence

Developers must contact SenseTime to obtain the licence file. Change the file name as **"SenseMe.lic"** and copy the file to assets folder.

### 1.3 Camera Capture Framework

We have imported a camera capture framework library. If you are interested in source code and document of this framework, please go to [here](https://github.com/AgoraIO/Agora-Extensions/tree/master/VideoCapture/Android) for more information.

## Developer Environment Requirements
- Android Studio 3.1 or above
- Real devices (Nexus 5X or other devices)
- Some simulators may have functions missing or have performance issue

## Connect Us

- You can find full Agora API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-With-SenseTime/issues)

## License

The MIT License (MIT).
