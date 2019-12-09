# Agora RTC with SenseTime iOS

A tutorial demo for Agora Video SDK can be found here: [Agora-iOS-Tutorial-Objective-C-1to1](https://github.com/AgoraIO/Basic-Video-Call/tree/master/One-to-One-Video/Agora-iOS-Tutorial-Objective-C-1to1)

This demo demonstrates the combined use of Agora RTC sdk and SenseTime beautification library. You can do:

- Join a channel and have video a chatting with friends;
- SenseTime beauty, makeups and stickers for your video.

## 1 Configuration

### 1.1 Agora RTC
#### 1.1.1 App Id

Create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID as the identification of the running app. Add the App ID in the `KeyCenter.m` file.

```
   + (NSString*)agoraAppId {
       return <#Agora App Id#>;
   }
```

#### 1.1.2 Agora SDK

Unpack the SDK and copy the `AgoraRtcEngineKit.framework` file to the `Agora-With-SenseTime/Agora-Video-With-SenseTime-iOS/Agora-With-SenseTime` folder of your project.


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
 Agora-With-SenseTime
    |_ SenseTimePart
        |_ resources
        |_ SenseArSourceService
            |_ lib
                |_ ios_universal
                   libSenseArSourceService.a
        |_ st_mobile
    |_ AGMBase.framework
    |_ AGMCapturer.framework
    |_ AGMRenderer.framework
```

#### 1.2.2 SenseTime Licence

Developers must contact SenseTime to obtain the licence file. Change the file name as **"SENSEME.lic"** and copy the file to assets folder.

### 1.3 Agora Module
**Agora Module is a Agora  SDK component for iOS.**  

#### Features
- [x]     Audio configuration
- [x]     Video configuration
- [x]   Audio Mute
- [x]     Background recording
- [x]   Support  Beauty Face With SenseTime
- [x]   Support  Beauty Face With FaceUnity
- [x]     Switch camera position
- [ ]     Support Beauty Face With GPUImage
- [ ]   Support build-in filter
- [ ]     Support horizontal vertical recording
- [ ]     Support H264+AAC Hardware Encoding
- [ ]     Drop frames on bad network 
- [ ]     Dynamic switching rate
- [ ]     RTMP Transport
- [ ]     Support Send Buffer
- [ ]     Support WaterMark
- [ ]     Swift Support
- [ ]     Support Single Video or Audio 
- [ ]     Support External input video or audio(Screen recording or Peripheral)
- [ ]     ~~FLV package and send~~
  
#### required frameworks
     * UIKit.framework
     * Foundation.framework
     * AVFoundation.framework
     * VideoToolbox.framework
     * AudioToolbox.framework
     * libz.framework
     * libstdc++.framework
                               
                      
#### Usage Agora Module Example 
##### How to use Capturer

```objc
AGMCapturerVideoConfig *videoConfig = [AGMCapturerVideoConfig defaultConfig];
videoConfig.videoSize = CGSizeMake(720, 1280);
videoConfig.sessionPreset = AGMCaptureSessionPreset720x1280;
self.cameraCapturer = [[AGMCameraCapturer alloc] initWithConfig:videoConfig];
[self.cameraCapturer start];
```

##### How to use build-in filter
```objc
self.filter = [[AGMFilter alloc] init];
```

##### How to use renderer
```objc
self.preview = [[UIView alloc] initWithFrame:self.view.bounds];
[self.view insertSubview:self.preview atIndex:0];
    
AGMRendererConfig *rendererConfig = [AGMRendererConfig defaultConfig];
self.videoRenderer = [[AGMVideoRenderer alloc] initWithConfig:rendererConfig];
self.videoRenderer.preView = self.preview;
[self.videoRenderer start];    


```

##### Associate the modules

```objc

[self.cameraCapturer addVideoSink:self.filter];
[self.filter addVideoSink:self.videoRenderer];

```

##### Custom Filter

Create a class that inherits form AGMVideoSource and implements the AGMVideoSink protocol, Implement the onFrame: method to handle the videoframe .

```objc

#import <AGMBase/AGMBase.h>

@interface AGMSenceTimeFilter : AGMVideoSource <AGMVideoSink>

@end

#import "AGMSenceTimeFilter.h"

@implementation AGMSenceTimeFilter

- (void)onFrame:(AGMVideoFrame *)videoFrame
{
#pragma mark Write the filter processing.
    
    
#pragma mark When you're done, pass it to the next sink.
    if (self.allSinks.count) {
        for (id<AGMVideoSink> sink in self.allSinks) {
            [sink onFrame:videoFrame];
        }
    }
}

@end

```

## Developer Environment Requirements
- Xcode 11 or above
- iOS 8.0 or above
- Real devices

## Connect Us

- You can find full Agora API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advanced-Video/issues)

## License

The MIT License (MIT).
