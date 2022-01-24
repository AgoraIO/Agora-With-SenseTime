//
//  SaveToastUtil.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveToastUtil : NSObject
+(void)showToastInView:(UIView *)view text:(NSString *)textStr;
@end

NS_ASSUME_NONNULL_END
