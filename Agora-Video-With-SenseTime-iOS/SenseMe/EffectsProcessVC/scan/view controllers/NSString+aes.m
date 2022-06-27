//
//  NSString+aes.m
//  AES-Demo
//
//  Created by 马浩萌 on 2022/2/25.
//

#import "NSString+aes.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (aes)

-(NSString *)aes_encryptStringBy:(NSString *)key {
    NSData *encryptData = [self _aesProcessBy:key andOperation:kCCEncrypt];
    return [encryptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

-(NSString *)aes_decryptStringBy:(NSString *)key {
    NSData *decryptData = [self _aesProcessBy:key andOperation:kCCDecrypt];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

-(NSData *)aes_encryptDataBy:(NSString *)key {
    NSData *decryptData = [self _aesProcessBy:key andOperation:kCCEncrypt];
    return decryptData;
}

-(NSData *)aes_decryptDataBy:(NSString *)key {
    NSData *encryptData = [self _aesProcessBy:key andOperation:kCCDecrypt];
    return encryptData;
}


-(NSData *)_aesProcessBy:(NSString *)key andOperation:(CCOperation)operation {
    NSData *originData;
    if (operation == kCCDecrypt) {
        originData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    } else {
        originData = [self dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSString * ivKey = [key copy]; //16位偏移，CBC模式才有
    NSData *initVector = [ivKey dataUsingEncoding:NSUTF8StringEncoding];
    //公钥
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    //数据长度
    NSUInteger dataLength = originData.length;
    //加密输出缓冲区大小
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    //加密输出缓冲区
    void *buffer = malloc(bufferSize);
    //实际输出大小
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,//加密算法
                                          kCCOptionPKCS7Padding,//CBC -> PKCS7Padding，ECB -> kCCOptionPKCS7Padding|kCCOptionECBMode
                                          keyPtr,
                                          kCCBlockSizeAES128,//密钥长度128
                                          initVector.bytes,//偏移字符串, ECB模式传NULL
                                          originData.bytes,//编码内容
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *aesData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return aesData;
    }
    free(buffer);
    return nil;
}
@end
