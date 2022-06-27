//
//  EFScanResourceManager.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFScanResourceManager.h"
#import "EFSenseArMaterialDataModels.h"
#import "ScanSenseArMaterial.h"

typedef void(^EFScanResourceManagerDownloadBlock)(EFScanResourceDownloadStatus status);
typedef EFScanResourceManagerDownloadBlock ZipDownloadBlock;

static NSString * const stScanCacheArchiverKey = @"/Documents/ScanCacheArchiver";
#define materialServiceInstance [SenseArMaterialService sharedInstance]
#define ScanCachePath [NSHomeDirectory() stringByAppendingPathComponent:stScanCacheArchiverKey]

@interface EFScanResourceManager ()

@property (nonatomic, strong) NSMutableArray <EFScanResourceModel * > *cacheList;

@end

@implementation EFScanResourceManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static EFScanResourceManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[EFScanResourceManager alloc] init];
    });
    return manager;
}

-(void)efProcessingScanResultObject:(EFScanViewControllerScanResultObject *)scanResultObject {
    NSString *zipUrlString = scanResultObject.urlString;
    if ([self _isDownloaded:zipUrlString]) {
        [self _afterDownloaded:scanResultObject];
    } else {
        [self _download:zipUrlString withCallback:^(EFScanResourceDownloadStatus status) {
            if (status == EFScanResourceDownloadStatusSuccessed) {
                [self _afterDownloaded:scanResultObject];
            } else {
                [self _notifyStatusHasChanged:status];
            }
        }];
    }
}

#pragma mark - 下载完毕后 流程封装
-(void)_afterDownloaded:(EFScanViewControllerScanResultObject *)scanResultObject {
    if([self _isInCacheList:scanResultObject.urlString]) {
        // do nothing
    } else {
        [self _insertIntoCacheList:scanResultObject];
    }
    [self _notifyStatusHasChanged:EFScanResourceDownloadStatusSuccessed];
}

#pragma mark - 下载判断主流程
-(BOOL)_isDownloaded:(NSString *)url {
    ScanSenseArMaterial *maskMeterial = [[ScanSenseArMaterial alloc] init];
    maskMeterial.strMaterialURL = url;
    maskMeterial.strID = url;
    maskMeterial.strMaterialFileID = url;
    return [materialServiceInstance isMaterialDownloaded:maskMeterial];
}

-(BOOL)_isInCacheList:(NSString *)url {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.url == %@", url];
    NSArray *filterResult = [self.cacheList filteredArrayUsingPredicate:predicate];
    return filterResult.count > 0;
}

-(void)_insertIntoCacheList:(EFScanViewControllerScanResultObject *)scanResultObject {
    @defer {
        [self _write];
    };
    EFScanResourceModel *model = [[EFScanResourceModel alloc] init];
    model.url = scanResultObject.urlString;
    model.imageName = scanResultObject.icon;
    [self.cacheList addObject:model];
}

-(void)_notifyStatusHasChanged:(EFScanResourceDownloadStatus)status {
    if (status == EFScanResourceDownloadStatusSuccessed) {
        [self _resetCacheList];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanResourceManager:downloadStatusChanged:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate scanResourceManager:self downloadStatusChanged:status];
        });
    }
}

-(void)_download:(NSString *)url withCallback:(ZipDownloadBlock)callback {
    ScanSenseArMaterial *maskMeterial = [[ScanSenseArMaterial alloc] init];
    maskMeterial.strMaterialURL = url;
    maskMeterial.strID = url;
    maskMeterial.strMaterialFileID = url;
    [materialServiceInstance downloadMaterial:maskMeterial onSuccess:^(SenseArMaterial *material) {
        if (callback) {
            callback(EFScanResourceDownloadStatusSuccessed);
        }
    } onFailure:^(SenseArMaterial *material, int iErrorCode, NSString *strMessage) {
        if (callback) {
            callback(EFScanResourceDownloadStatusFailed);
        }
    } onProgress:^(SenseArMaterial *material, float fProgress, int64_t iSize) {
        
    }];
}

#pragma mark - cache R/W
-(NSMutableArray<EFScanResourceModel *> *)cacheList {
    if (!_cacheList) {
        [self _resetCacheList];
    }
    return _cacheList;
}

-(void)_resetCacheList {
    _cacheList = [NSMutableArray arrayWithArray:[self _read]];
}

-(NSArray <NSString *> *)_read {
    NSArray *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:ScanCachePath];
    cache = [[cache reverseObjectEnumerator] allObjects];
    return cache;
}

-(void)_write {
    NSArray *cache = [self.cacheList copy];
    [NSKeyedArchiver archiveRootObject:cache toFile:ScanCachePath];
}

@end
