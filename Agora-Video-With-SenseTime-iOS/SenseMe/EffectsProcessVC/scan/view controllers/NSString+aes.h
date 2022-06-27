//
//  NSString+aes.h
//  AES-Demo
//
//  Created by 马浩萌 on 2022/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (aes)

-(NSString *)aes_encryptStringBy:(NSString *)key;
-(NSString *)aes_decryptStringBy:(NSString *)key;
-(NSData *)aes_decryptDataBy:(NSString *)key;
-(NSData *)aes_encryptDataBy:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
