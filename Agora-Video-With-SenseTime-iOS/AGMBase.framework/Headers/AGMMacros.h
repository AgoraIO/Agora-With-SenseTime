/*
 *  Copyright 2016 The AgoraAGM Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef SDK_OBJC_BASE_AGMMACROS_H_
#define SDK_OBJC_BASE_AGMMACROS_H_

#define AGM_OBJC_EXPORT __attribute__((visibility("default")))

#if defined(__cplusplus)
#define AGM_EXTERN extern "C" AGM_OBJC_EXPORT
#else
#define AGM_EXTERN extern AGM_OBJC_EXPORT
#endif

#ifdef __OBJC__
#define AGM_FWD_DECL_OBJC_CLASS(classname) @class classname
#else
#define AGM_FWD_DECL_OBJC_CLASS(classname) typedef struct objc_object classname
#endif

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
#define AgoraAGM_IOS 1
#endif

#if defined(AgoraAGM_IOS)
#include <UIKit/UIKit.h>
#define AGMView UIView
#else
#include <AppKit/AppKit.h
#define AGMView NSView
#endif

static void AGMInvokeUIThread(dispatch_block_t block) {
  if ([NSThread isMainThread]) {
    block();
  } else {
    dispatch_sync(dispatch_get_main_queue(), block);
  }
}


#endif  // SDK_OBJC_BASE_AGMMACROS_H_
