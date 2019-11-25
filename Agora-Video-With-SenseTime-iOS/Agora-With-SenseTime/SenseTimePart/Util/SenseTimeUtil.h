//
//  SenseTimeUtil.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/22.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SenseTimeUtil : NSObject

+ (BOOL)isIphoneX;
+ (CGFloat)layoutWidthWithValue:(CGFloat)value;
+ (CGFloat)layoutHeightWithValue:(CGFloat)value;
    
+ (CGRect)getZoomedRectWithRect:(CGRect)rect scaleToFit:(BOOL)bScaleToFit videoSettingSize:(CGSize)size;

+ (void)snapWithView:(UIView *)preview texture:(GLuint)iTexture width:(int)iWidth height:(int)iHeight;

+ (BOOL)checkMediaStatus:(NSString *)mediaType;

@end

NS_ASSUME_NONNULL_END
