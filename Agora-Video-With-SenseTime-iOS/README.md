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
or you can manual to download and unzip to **"Agora-With-SenseTime/SenseTimePart/"** folder:
1. [SenseTime-iOS-Resource.zip](https://github.com/AgoraIO/Agora-With-SenseTime/releases/download/0.0.1/SenseTime-iOS-Resource.zip) 
2. [AgoraModule_Base_iOS-1.2.0](https://download.agora.io/components/release/AgoraModule_Base_iOS-1.2.0.zip)
3. [AgoraModule_Capturer_iOS-1.2.0](https://download.agora.io/components/release/AgoraModule_Capturer_iOS-1.2.0.zip)
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
```

#### 1.2.2 SenseTime Licence

Developers must contact SenseTime to obtain the licence file. Change the file name as **"SENSEME.lic"** and copy the file to assets folder.

### 1.3 Agora Module
**Agora Module is an Agora  SDK component for iOS.**  

#### Features
- [x] 	Capturer
	- [x] Camera Capturer
		- [x] Support for front and rear camera switching
		- [x] Support for dynamic resolution switching
		- [x] Support I420, NV12, BGRA pixel format output
		- [x] Support Exposure, ISO
		- [ ] Support ZoomScale
		- [ ] Support Torch
		- [ ] Support watermark
	- [x] Audio Capturer
		- [x] Support single and double channel
		- [x] Support Mute
	- [x]  Video Frame Adapter (For processing the video frame direction required by different modules)
		- [x] Support VideoOutputOrientationModeAdaptative for RTC function
		- [x] Support ...FixedLandscape and ...FixedLandscape for CDN live streaming
  
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

##### Adapter Filter

 ```objc
 self.videoAdapterFilter = [[AGMVideoAdapterFilter alloc] init];
 self.videoAdapterFilter.ignoreAspectRatio = YES;
 self.videoAdapterFilter.isMirror = YES;
 #define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)
 CGAffineTransform rotation = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(90));
 self.videoAdapterFilter.affineTransform = rotation;
 ```

##### Associate the modules

```objc

[self.cameraCapturer addVideoSink:self.videoAdapterFilter];
[self.videoAdapterFilter addVideoSink:senceTimeFilter];

```

##### Custom Filter

Create a class that inherits form AGMVideoSource and implements the AGMVideoSink protocol, Implement the onFrame: method to handle the videoframe .

```objc

#import <AGMBase/AGMBase.h>

@interface AGMSenceTimeFilter : AGMVideoSource <AGMVideoSink>

@end

#import "AGMSenceTimeFilter.h"

@implementation AGMSenceTimeFilter

- (void)onTextureFrame:(AGMImageFramebuffer *)textureFrame frameTime:(CMTime)time {
{
#pragma mark Write the filter processing.
    
    
#pragma mark When you're done, pass it to the next sink.
    if (self.allSinks.count) {
        for (id<AGMVideoSink> sink in self.allSinks) {
            [sink onTextureFrame:textureFrame frameTime:time];
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
