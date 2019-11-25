//
//  SenseMEUtils.m
//  SenseMeEffects
//
//  Created by Sunshine on 2019/1/14.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "SenseMEUtils.h"

//st_mobile
#import "st_mobile_common.h"
#import "st_mobile_license.h"

#import <CommonCrypto/CommonDigest.h>

@interface SenseMEUtils ()
@property (nonatomic, assign) BOOL bChecked;
@property (nonatomic, assign) int  msgCheck;
@end

@implementation SenseMEUtils

static dispatch_once_t onceToken;
static SenseMEUtils *utils = nil;

+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        
        utils = [[self alloc] initBySuper];
    });
    
    return utils;
}

- (instancetype)initBySuper
{
    self = [super init];
    
    if (self) {
        
        self.bChecked = NO;
        self.msgCheck = ST_OK;
    }
    
    return self;
}

#pragma mark - check license

- (NSString *)getSHA1StringWithData:(NSData *)data {
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *strSHA1 = [NSMutableString string];
    
    for (int i = 0 ; i < CC_SHA1_DIGEST_LENGTH ; i ++) {
        
        [strSHA1 appendFormat:@"%02x" , digest[i]];
    }
    
    return strSHA1;
}

- (BOOL)checkActiveCodeNative {
    
    NSString *strLicensePath = [[NSBundle mainBundle] pathForResource:@"SENSEME" ofType:@"lic"];
    NSData *dataLicense = [NSData dataWithContentsOfFile:strLicensePath];
    
    NSString *strKeySHA1 = @"SENSEME";
    NSString *strKeyActiveCode = @"ACTIVE_CODE";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strStoredSHA1 = [userDefaults objectForKey:strKeySHA1];
    NSString *strLicenseSHA1 = [self getSHA1StringWithData:dataLicense];
    
    return [self checkAndGenerateActiveCodeWithStoreStr:strStoredSHA1
                                            storeStrKey:strKeySHA1
                                          activeCodeStr:strLicenseSHA1
                                       activeCodeStrKey:strKeyActiveCode
                                            licensePath:strLicensePath
                                                bOnline:NO];
}

- (BOOL)checkActiveCodeOnline
{
    NSString *strLicensePath = [[NSBundle mainBundle] pathForResource:@"SENSEME" ofType:@"lic"];
    NSData *dataLicense = [NSData dataWithContentsOfFile:strLicensePath];
    
    NSString *strKeySHA1 = @"SENSEME";
    NSString *strKeyActiveCode = @"ACTIVE_CODE";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strStoredSHA1 = [userDefaults objectForKey:strKeySHA1];
    NSString *strLicenseSHA1 = [self getSHA1StringWithData:dataLicense];
    
    return [self checkAndGenerateActiveCodeWithStoreStr:strStoredSHA1
                                            storeStrKey:strKeySHA1
                                          activeCodeStr:strLicenseSHA1
                                       activeCodeStrKey:strKeyActiveCode
                                            licensePath:strLicensePath
                                                bOnline:YES];
    
    
}

- (BOOL)checkAndGenerateActiveCodeWithStoreStr:(NSString *)strStore
                                   storeStrKey:(NSString *)storeKey
                                 activeCodeStr:(NSString *)strLicense
                              activeCodeStrKey:(NSString *)activeCodeKey
                                   licensePath:(NSString *)path
                                       bOnline:(BOOL)online
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    st_result_t iRet = ST_OK;
    
    if (strStore.length > 0 && [strLicense isEqualToString:strStore]) {
        
        // Get current active code
        // In this app active code was stored in NSUserDefaults
        // It also can be stored in other places
        NSData *activeCodeData = [userDefaults objectForKey:activeCodeKey];
        
        // Check if current active code is available
        // use file
        iRet = st_mobile_check_activecode(
                                          path.UTF8String,
                                          (const char *)[activeCodeData bytes],
                                          (int)[activeCodeData length]
                                          );
        
        _bChecked = iRet == ST_OK;
        _msgCheck = iRet;
        
        if (ST_OK == iRet) {
            
            // check success
            return YES;
        }
    }
    
    /*
     1. check fail
     2. new one
     3. update
     */
    
    char active_code[1024];
    int active_code_len = 1024;
    
    // generate one
    // use file
    
    if (online) {
        iRet = st_mobile_generate_activecode_online(path.UTF8String,
                                                    active_code,
                                                    &active_code_len);
    }else{
        iRet = st_mobile_generate_activecode(path.UTF8String,
                                             active_code,
                                             &active_code_len);
    }
    
    _bChecked = iRet == ST_OK;
    _msgCheck = iRet;
    
    if (ST_OK != iRet) {
        
        return NO;
        
    } else {
        
        // Store active code
        NSData *activeCodeData = [NSData dataWithBytes:active_code length:active_code_len];
        
        [userDefaults setObject:activeCodeData forKey:activeCodeKey];
        [userDefaults setObject:strLicense forKey:storeKey];
        
        [userDefaults synchronize];
    }
    
    return YES;
}

- (void)checkActiveCodeNativeOnSuccess:(void (^)(void))checkSuccess
                             onFailure:(void (^)(int checkResult))checkFailure
{
    if ([self checkActiveCodeNative]) {
        checkSuccess();
    }else{
        checkFailure(_msgCheck);
    }
}

- (void)checkActiveCodeOnlineOnSuccess:(void (^)(void))checkSuccess
                             onFailure:(void (^)(int checkResult))checkFailure
{
    
    if ([self checkActiveCodeOnline]) {
        checkSuccess();
    }else{
        checkFailure(_msgCheck);
    }
}

+ (BOOL)isCheckedActiveCode
{
    return (utils != nil) && utils.bChecked;
}

@end
