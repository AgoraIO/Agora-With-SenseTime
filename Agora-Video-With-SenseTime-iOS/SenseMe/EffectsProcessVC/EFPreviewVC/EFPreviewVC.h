//
//  EFPreviewVC'.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/4.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFBaseEffectsProcess.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFPreviewVC : EFBaseEffectsProcess

//{
//    st_effect_3D_beauty_part_info_t *parts;
//}

@property (nonatomic, readwrite, assign) BOOL _isNotFirst;
@property (nonatomic, assign) BOOL bTakePhoto;
@property (nonatomic) dispatch_queue_t renderQueue;
@property (nonatomic, assign) BOOL showPhotoStripView;

//点击弹出对应type
- (void)actionWith:(EFDataSourceModel *)model selectIndex:(int)index;

- (void)addCommonObject:(UIImage *)image filePath:(NSString *)filePath;

-(void)capturedidOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer handler: (void (^)(CVPixelBufferRef))callback;

@end

NS_ASSUME_NONNULL_END
