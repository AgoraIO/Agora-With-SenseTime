# Agora RTC with SenseTime iOS

A tutorial demo for Agora Video SDK can be found here: [Agora-iOS-Tutorial-Objective-C-1to1](https://github.com/AgoraIO/Basic-Video-Call/tree/master/One-to-One-Video/Agora-iOS-Tutorial-Objective-C-1to1)

This demo demonstrates the combined use of Agora RTC sdk and SenseTime beautification library. You can do:

- Join a channel and have video a chatting with friends;
- SenseTime beauty, makeups and stickers for your video.

## 1 Configuration

### 1.1 Agora RTC
#### 1.1.1 App Id

Create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID as the identification of the running app. Add the App ID in the `ViewController.m` file.

```
   self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:<#Your Agora App Id#> delegate:nil];
```

#### 1.1.2 Agora SDK

Unpack the SDK and copy the `AgoraRtcEngineKit.framework` file to the `Agora-With-SenseTime/Agora-Video-With-SenseTime-iOS` folder of your project.


### 1.2 SenseTime


#### 1.2.1 SenseTime SDK & Resources & st_mobile

Most the of code of SenseTime SDK is already provided in the **"SenseTimePart"** of the demo project.
But things to note that developers need run 
```
cd Agora-Video-With-SenseTime-iOS/
sh setupSenseTime.sh
```
or you can manual to download and unzip [SenseTime-iOS-Resource.zip](https://github.com/AgoraIO/Agora-With-SenseTime/releases/download/0.0.1/SenseTime-iOS-Resource.zip) to **"Agora-With-SenseTime/SenseTimePart/"** folder:
```
 SenseTimePart
      |_ resources
      |_ SenseArSourceService
          |_ lib
              |_ ios_universal
                   libSenseArSourceService.a
      |_ st_mobile
```

#### 1.2.2 SenseTime Licence

Developers must contact SenseTime to obtain the licence file. Change the file name as **"SENSEME.lic"** and copy the file to assets folder.


## Developer Environment Requirements
- Xcode 10 or above
- iOS 8.0 or above
- Real devices

## Connect Us

- You can find full Agora API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advanced-Video/issues)

## License

The MIT License (MIT).
