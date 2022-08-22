//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AgoraRteFileInfo;
@interface AgoraRteFileInfo : NSObject
@property (nonatomic, assign) NSInteger fileId;
@property (nonatomic, strong) NSString * _Nullable fileUrl;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger videoWidth;
@property (nonatomic, assign) NSInteger videoHeight;
@property (nonatomic, assign) NSInteger frameRate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger beginTime;

/**
 * @description:
 * @return isValid
 */
- (BOOL)isValid;

/**
 * @description: clonefileInfo
 * @param fileInfo
 */
- (void)cloneTo:(AgoraRteFileInfo * _Nonnull)fileInfo;

@end
@protocol AgoraRtePlayListProtocol <NSObject>

/**
 * @description:  current list If there is a current file, it will return ERR_ALREADY_IN_USE
 */
- (void)clearFileList;

/**
 * @description: Retrieve the file count of current list 
 * @return The number of files in current list
 */
- (NSInteger)fileCount;

/**
 * @description: Gets the total duration of the list
 * @param {*}
 * @return The summarization of each file duration
 */
- (NSInteger)totalDuration;

/**
 * @description: Get file information by file Id
 * @param fileId the query file id
 * @return AgoraRteFileInfo 
 */
- (AgoraRteFileInfo *_Nullable)fileInfoById:(NSInteger) fileId;

/**
 * @description: 
 * @param index the query file index
 * @return AgoraRteFileInfo  output file information
 */
- (AgoraRteFileInfo *_Nullable)fileInfoByIndex:(NSInteger) index;

/**
 * @description: 
 * @return AgoraRteFileInfo
 */
- (AgoraRteFileInfo *_Nullable)firstFileInfo;

/**
 * @description: Get Last file info
 * @return getLastFileInfo
 */
- (AgoraRteFileInfo * _Nullable)lastFileInfo;

/**
 * @description:  Get the file information list of current list
 * @return outFileList
 */
- (NSArray *_Nullable)fileList;

/**
 * @brief 
 * @param fileUrl : the file path url
 * @param insertIndex :the index of want to insert, range in [0, (file_count-1)]
 *                       insert_index <= 0: insert into head of list
 *                       insert_index >= file_count: insert into tail of list
 * @return [out] out_file_info: output the file information
 */
- (AgoraRteFileInfo *_Nonnull )insertFile:(NSString * _Nonnull )fileUrl insertIndex:(NSInteger)insertIndex;

/**
 * @brief Appends a new file to the end of the play list.
 * @param fileUrl : the file path url
 * @return  AgoraRteFileInfo : output the file information
 */
- (AgoraRteFileInfo * _Nonnull)appendFile:(NSString * _Nonnull)fileUrl;

/**
 * @brief Removes a file by file ID from the play list.
 *        If removing current file, it will return @agora::ERR_ALREADY_IN_USE
 * @param removeFileId : the file UUID which want to be removed
 *
 */
- (void)removeFileById:(NSInteger)removeFileId;

/**
 * @description: Removes a file by index.
 *        If removing current file, it will return @agora::ERR_ALREADY_IN_USE
 * @param removeFileIndex  : The index of the file to be removed.
 */
- (void)removeFileByIndex:(NSInteger)removeFileIndex;

/**
 * @description: Removes all files by URL.
 * If removing current file, it will return @agora::ERR_ALREADY_IN_USE
 * @param removeFileUrl : The URL of the file to be removed.
 */
- (void)removeFileByUrl:(NSString * _Nonnull)removeFileUrl;


@end
