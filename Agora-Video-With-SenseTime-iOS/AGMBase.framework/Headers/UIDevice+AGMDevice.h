/*
 *  Copyright 2016 The AgoraAGM project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <Foundation/Foundation.h>

#if !TARGET_OS_OSX

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AGMDeviceType) {
  AGMDeviceTypeUnknown,
  AGMDeviceTypeIPhone1G,
  AGMDeviceTypeIPhone3G,
  AGMDeviceTypeIPhone3GS,
  AGMDeviceTypeIPhone4,
  AGMDeviceTypeIPhone4Verizon,
  AGMDeviceTypeIPhone4S,
  AGMDeviceTypeIPhone5GSM,
  AGMDeviceTypeIPhone5GSM_CDMA,
  AGMDeviceTypeIPhone5CGSM,
  AGMDeviceTypeIPhone5CGSM_CDMA,
  AGMDeviceTypeIPhone5SGSM,
  AGMDeviceTypeIPhone5SGSM_CDMA,
  AGMDeviceTypeIPhone6Plus,
  AGMDeviceTypeIPhone6,
  AGMDeviceTypeIPhone6S,
  AGMDeviceTypeIPhone6SPlus,
  AGMDeviceTypeIPhone7,
  AGMDeviceTypeIPhone7Plus,
  AGMDeviceTypeIPhoneSE,
  AGMDeviceTypeIPhone8,
  AGMDeviceTypeIPhone8Plus,
  AGMDeviceTypeIPhoneX,
  AGMDeviceTypeIPhoneXS,
  AGMDeviceTypeIPhoneXSMax,
  AGMDeviceTypeIPhoneXR,
  AGMDeviceTypeIPodTouch1G,
  AGMDeviceTypeIPodTouch2G,
  AGMDeviceTypeIPodTouch3G,
  AGMDeviceTypeIPodTouch4G,
  AGMDeviceTypeIPodTouch5G,
  AGMDeviceTypeIPodTouch6G,
  AGMDeviceTypeIPad,
  AGMDeviceTypeIPad2Wifi,
  AGMDeviceTypeIPad2GSM,
  AGMDeviceTypeIPad2CDMA,
  AGMDeviceTypeIPad2Wifi2,
  AGMDeviceTypeIPadMiniWifi,
  AGMDeviceTypeIPadMiniGSM,
  AGMDeviceTypeIPadMiniGSM_CDMA,
  AGMDeviceTypeIPad3Wifi,
  AGMDeviceTypeIPad3GSM_CDMA,
  AGMDeviceTypeIPad3GSM,
  AGMDeviceTypeIPad4Wifi,
  AGMDeviceTypeIPad4GSM,
  AGMDeviceTypeIPad4GSM_CDMA,
  AGMDeviceTypeIPad5,
  AGMDeviceTypeIPad6,
  AGMDeviceTypeIPadAirWifi,
  AGMDeviceTypeIPadAirCellular,
  AGMDeviceTypeIPadAirWifiCellular,
  AGMDeviceTypeIPadAir2,
  AGMDeviceTypeIPadMini2GWifi,
  AGMDeviceTypeIPadMini2GCellular,
  AGMDeviceTypeIPadMini2GWifiCellular,
  AGMDeviceTypeIPadMini3,
  AGMDeviceTypeIPadMini4,
  AGMDeviceTypeIPadPro9Inch,
  AGMDeviceTypeIPadPro12Inch,
  AGMDeviceTypeIPadPro12Inch2,
  AGMDeviceTypeIPadPro10Inch,
  AGMDeviceTypeSimulatori386,
  AGMDeviceTypeSimulatorx86_64,
};

@interface UIDevice (AGMDevice)

+ (AGMDeviceType)deviceType;
+ (BOOL)isIOS11OrLater;

@end

#endif
