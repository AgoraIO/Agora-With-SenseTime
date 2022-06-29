# Agora RTC with SenseTime iOS

This demo demonstrates the combined use of Agora RTC sdk and SenseTime beautification library. You can do:

- Join a channel and have video a chatting with friends;
- SenseTime beauty, makeups and stickers for your video.

## 1 Configuration

### 1.1 Agora RTC
#### 1.1.1 App Id

Create a developer account at [Agora.io](https://dashboard.agora.io/signin/), create a new project and obtain an App ID as the identification of the running app. Update "app/src/main/res/values/strings-config.xml" with your App ID.

修改`KeyCenter.m`中 `AppId`

#### 1.1.2 Agora SDK

There are two ways to add Agora Video SDK to the project:

* JCenter (recommended)
* Download SDK from [Agora.io SDK](https://docs.agora.io/en/Agora%20Platform/downloads)

**The first method** will download Agora Video SDK automatically from Podfile
```
  pod 'AgoraRtcEngine_iOS', '~> 3.7.0'
```

# SenseTime

#### 注意事项
 使用商汤8.8.0版本SDK

Most the of code of SenseTime SDK is already provided in the **"st_mobile_sdk"** module of the demo project. But things to note that developers need to download and copy models include ios_os-universal libraries to **"SenseMe/remoteSourcesLib/** folder:
```
    st_mobile_sdk
      |_ models   
      |_ include       
      |_ ios_os-universal
```

Other soureces all in the remoteSourcesLib files. Copy libraries to **"SenseMe/remoteSourcesLib"** folder:
```
   remoteSourcesLib
      |_ include       
      |_ libSenseArSourceService.a
```

## Connect Us

- You can find full Agora API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-With-SenseTime/issues)

## License

The MIT License (MIT).
