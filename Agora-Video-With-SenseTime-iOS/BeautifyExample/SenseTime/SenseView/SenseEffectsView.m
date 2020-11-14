//
//  SenseEffectsView.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/20.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseEffectsView.h"
#import "STParamUtil.h"
#import "STScrollTitleView.h"
#import "EffectsCollectionView.h"
#import "STCollectionView.h"
#import "EffectsCollectionViewCell.h"
#import "STMobileLog.h"
#import "STTriggerView.h"
//#import "STEffectsAudioPlayer.h"
#import "STCommonObjectContainerView.h"


@interface SenseEffectsView ()<STCommonObjectContainerViewDelegate> {
 
}

@property (nonatomic, readwrite, strong) STScrollTitleView *scrollTitleView;
@property (nonatomic, strong) EffectsCollectionView *effectsList;
@property (nonatomic, readwrite, strong) STCollectionView *objectTrackCollectionView;
@property (nonatomic, readwrite, strong) UIImageView *noneStickerImageView;
@property (nonatomic, readwrite, strong) UIView *noneStickerView;

@property (nonatomic, readwrite, strong) NSArray *arrObjectTrackers;
@property (nonatomic, assign) STEffectsType curEffectStickerType;
@property (nonatomic, strong) NSArray *arrCurrentModels;
@property (nonatomic , strong) EffectsCollectionViewCellModel *prepareModel;

@property (nonatomic, strong) SenseEffectsManager *senseEffectsManager;

@end

@implementation SenseEffectsView

- (void)initSenseEffectsManager:(SenseEffectsManager *)manager {
    
    self.senseEffectsManager = manager;
    
    STWeakSelf
    self.senseEffectsManager.onTrackBlock = ^(st_rect_t trackRect, CGPoint displayCenter) {
        if (weakSelf.commonObjectContainerView.currentCommonObjectView.isOnFirst) {
            //用作同步,防止再次改变currentCommonObjectView的位置

        } else if (trackRect.left == 0 && trackRect.top == 0 && trackRect.right == 0 && trackRect.bottom == 0) {

            weakSelf.commonObjectContainerView.currentCommonObjectView.hidden = YES;

        } else {
            weakSelf.commonObjectContainerView.currentCommonObjectView.hidden = NO;
            weakSelf.commonObjectContainerView.currentCommonObjectView.center = displayCenter;
        }
    };
    
    [self setupViews];
}

-(void)initDefaultValue {
    self.arrCurrentModels = [self.senseEffectsManager.effectsDataSource objectForKey:@(STEffectsTypeStickerMy)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.effectsList reloadData];
    });
}

- (void)setupViews {
    UIView *noneStickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 57, 40)];
    noneStickerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    noneStickerView.layer.shadowColor = UIColorFromRGB(0x141618).CGColor;
    noneStickerView.layer.shadowOpacity = 0.5;
    noneStickerView.layer.shadowOffset = CGSizeMake(3, 3);
    _noneStickerView = noneStickerView;
    
    UIImage *image = [UIImage imageNamed:@"none_sticker.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((57 - image.size.width) / 2, (40 - image.size.height) / 2, image.size.width, image.size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = image;
    imageView.highlightedImage = [UIImage imageNamed:@"none_sticker_selected.png"];
    _noneStickerImageView = imageView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapNoneSticker:)];
    [noneStickerView addGestureRecognizer:tapGesture];
    
    [noneStickerView addSubview:imageView];
    
    UIView *whiteLineView = [[UIView alloc] initWithFrame:CGRectMake(56, 3, 1, 34)];
    whiteLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [noneStickerView addSubview:whiteLineView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self addSubview:lineView];
    
    [self addSubview:noneStickerView];
    [self addSubview:self.scrollTitleView];
    [self addSubview:self.effectsList];
    [self addSubview:self.objectTrackCollectionView];
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 181, SCREEN_WIDTH, 50)];
    blankView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:blankView];
}

#pragma mark --setup view
- (STCommonObjectContainerView *)commonObjectContainerView {
    if(!_commonObjectContainerView){
        _commonObjectContainerView = [[STCommonObjectContainerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _commonObjectContainerView.delegate = self;
    }
    return _commonObjectContainerView;
}

- (STScrollTitleView *)scrollTitleView {
    if (!_scrollTitleView) {
        
        STWeakSelf;
        
        NSArray *stickerTypeArray = @[
                                      @(STEffectsTypeStickerMy),
                                      @(STEffectsTypeStickerNew),
                                      @(STEffectsTypeSticker2D),
                                      @(STEffectsTypeStickerAvatar),
                                      @(STEffectsTypeSticker3D),
                                      @(STEffectsTypeStickerGesture),
                                      @(STEffectsTypeStickerSegment),
                                      @(STEffectsTypeStickerFaceDeformation),
                                      @(STEffectsTypeStickerFaceChange),
                                      @(STEffectsTypeStickerParticle),
                                      @(STEffectsTypeObjectTrack)];
        
        NSArray *normalImages = @[
                                  [UIImage imageNamed:@"native.png"],
                                  [UIImage imageNamed:@"new_sticker.png"],
                                  [UIImage imageNamed:@"2d.png"],
                                  [UIImage imageNamed:@"avatar.png"],
                                  [UIImage imageNamed:@"3d.png"],
                                  [UIImage imageNamed:@"sticker_gesture.png"],
                                  [UIImage imageNamed:@"sticker_segment.png"],
                                  [UIImage imageNamed:@"sticker_face_deformation.png"],
                                  [UIImage imageNamed:@"face_painting.png"],
                                  [UIImage imageNamed:@"particle_effect.png"],
                                  [UIImage imageNamed:@"common_object_track.png"]
                                  ];
        NSArray *selectedImages = @[
                                    [UIImage imageNamed:@"native_selected.png"],
                                    [UIImage imageNamed:@"new_sticker_selected.png"],
                                    [UIImage imageNamed:@"2d_selected.png"],
                                    [UIImage imageNamed:@"avatar_selected.png"],
                                    [UIImage imageNamed:@"3d_selected.png"],
                                    [UIImage imageNamed:@"sticker_gesture_selected.png"],
                                    [UIImage imageNamed:@"sticker_segment_selected.png"],
                                    [UIImage imageNamed:@"sticker_face_deformation_selected.png"],
                                    [UIImage imageNamed:@"face_painting_selected.png"],
                                    [UIImage imageNamed:@"particle_effect_selected.png"],
                                    [UIImage imageNamed:@"common_object_track_selected.png"]
                                    ];
        
        
        _scrollTitleView = [[STScrollTitleView alloc] initWithFrame:CGRectMake(57, 0, SCREEN_WIDTH - 57, 40) normalImages:normalImages selectedImages:selectedImages effectsType:stickerTypeArray titleOnClick:^(STTitleViewItem *titleView, NSInteger index, STEffectsType type) {
            
            [weakSelf handleEffectsType:type];
        }];
        
        _scrollTitleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _scrollTitleView;
}

- (STCollectionView *)objectTrackCollectionView {
    if (!_objectTrackCollectionView) {
        
        __weak typeof(self) weakSelf = self;
        _objectTrackCollectionView = [[STCollectionView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 140) withModels:nil andDelegateBlock:^(STCollectionViewDisplayModel *model) {
            [weakSelf handleObjectTrackChanged:model];
        }];
        
        _objectTrackCollectionView.arrModels = self.arrObjectTrackers;
        _objectTrackCollectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _objectTrackCollectionView;
}

- (STTriggerView *)triggerView {
    
    if (!_triggerView) {
        
        _triggerView = [[STTriggerView alloc] init];
    }
    
    return _triggerView;
}

- (EffectsCollectionView *)effectsList
{
    if (!_effectsList) {
        
        __weak typeof(self) weakSelf = self;
        _effectsList = [[EffectsCollectionView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 140)];
        [_effectsList registerNib:[UINib nibWithNibName:@"EffectsCollectionViewCell"
                                                 bundle:[NSBundle mainBundle]]
       forCellWithReuseIdentifier:@"EffectsCollectionViewCell"];
        _effectsList.numberOfSectionsInView = ^NSInteger(STCustomCollectionView *collectionView) {
            
            return 1;
        };
        _effectsList.numberOfItemsInSection = ^NSInteger(STCustomCollectionView *collectionView, NSInteger section) {
            
            return weakSelf.arrCurrentModels.count;
        };
        _effectsList.cellForItemAtIndexPath = ^UICollectionViewCell *(STCustomCollectionView *collectionView, NSIndexPath *indexPath) {
            
            static NSString *strIdentifier = @"EffectsCollectionViewCell";
            
            EffectsCollectionViewCell *cell = (EffectsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:strIdentifier forIndexPath:indexPath];
            
            NSArray *arrModels = weakSelf.arrCurrentModels;
            
            if (arrModels.count) {
                
                EffectsCollectionViewCellModel *model = arrModels[indexPath.item];
                
                if (model.iEffetsType != STEffectsTypeStickerMy) {
                    
                    id cacheObj = [weakSelf.senseEffectsManager.thumbnailCache objectForKey:model.material.strMaterialFileID];
                    
                    if (cacheObj && [cacheObj isKindOfClass:[UIImage class]]) {
                        
                        model.imageThumb = cacheObj;
                    }else{
                        
                        model.imageThumb = [UIImage imageNamed:@"none"];
                    }
                }
                
                cell.model = model;
                
                return cell;
            }else{
                
                cell.model = nil;
                
                return cell;
            }
        };
        _effectsList.didSelectItematIndexPath = ^(STCustomCollectionView *collectionView, NSIndexPath *indexPath) {
            
            NSArray *arrModels = weakSelf.arrCurrentModels;
            [weakSelf handleStickerChanged:arrModels[indexPath.item]];
        };
    }
    
    return _effectsList;
}

- (void)dealloc {
    
    _senseEffectsManager = nil;
    
    NSArray *targets = [_noneStickerView gestureRecognizers];
    for (UIGestureRecognizer *recognizer in targets) {
        [_noneStickerView removeGestureRecognizer: recognizer];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.commonObjectContainerView removeFromSuperview];
    });
}


#pragma mark -- click events
- (void)handleObjectTrackChanged:(STCollectionViewDisplayModel *)model {

    if (self.commonObjectContainerView.currentCommonObjectView) {
        [self.commonObjectContainerView.currentCommonObjectView removeFromSuperview];
    }
    self.senseEffectsManager.commonObjectViewSetted = NO;
    self.senseEffectsManager.commonObjectViewAdded = NO;

    if (model.isSelected) {
        UIImage *image = model.image;
        [self.commonObjectContainerView addCommonObjectViewWithImage:image];
        self.commonObjectContainerView.currentCommonObjectView.onFirst = YES;
        self.senseEffectsManager.bTracker = YES;
    }
}

- (void)handleEffectsType:(STEffectsType)type {
    
    switch (type) {
            
        case STEffectsTypeStickerMy:
        case STEffectsTypeSticker2D:
        case STEffectsTypeStickerAvatar:
        case STEffectsTypeSticker3D:
        case STEffectsTypeStickerGesture:
        case STEffectsTypeStickerSegment:
        case STEffectsTypeStickerFaceChange:
        case STEffectsTypeStickerFaceDeformation:
        case STEffectsTypeStickerParticle:
        case STEffectsTypeStickerNew:
        case STEffectsTypeObjectTrack:
            self.curEffectStickerType = type;
            break;
        default:
            break;
    }
    
    switch (type) {
            
        case STEffectsTypeStickerMy:
        case STEffectsTypeStickerNew:
        case STEffectsTypeSticker2D:
        case STEffectsTypeStickerAvatar:
        case STEffectsTypeStickerFaceDeformation:
        case STEffectsTypeStickerSegment:
        case STEffectsTypeSticker3D:
        case STEffectsTypeStickerGesture:
        case STEffectsTypeStickerFaceChange:
        case STEffectsTypeStickerParticle:
            
            self.objectTrackCollectionView.hidden = YES;
            self.arrCurrentModels = [self.senseEffectsManager.effectsDataSource objectForKey:@(type)];
            [self.effectsList reloadData];

            self.effectsList.hidden = NO;
            
            break;
            
        case STEffectsTypeObjectTrack:
            [self.senseEffectsDelegate onDevicePositionChange:AVCaptureDevicePositionBack];
            
            self.objectTrackCollectionView.arrModels = self.arrObjectTrackers;
            self.objectTrackCollectionView.hidden = NO;
            self.effectsList.hidden = YES;
            [self.objectTrackCollectionView reloadData];
            
            break;
            
        default:
            break;
    }
    
}

- (void)onTapNoneSticker:(UITapGestureRecognizer *)tapGesture {
    
    [self cancelStickerAndObjectTrack];
    self.noneStickerImageView.highlighted = YES;
}

- (void)handleStickerChanged:(EffectsCollectionViewCellModel *)model {
    
    self.prepareModel = model;
    
    if (STEffectsTypeStickerMy == model.iEffetsType) {
        [self setMaterialModel:model];
        return;
    }

    STWeakSelf;
    BOOL isMaterialExist = [[SenseArMaterialService sharedInstance] isMaterialDownloaded:model.material];
    BOOL isDirectory = YES;
    BOOL isFileAvalible = [[NSFileManager defaultManager] fileExistsAtPath:model.material.strMaterialPath
                                                               isDirectory:&isDirectory];
    
    ///TODO: 双页面共享 service  会造成 model & material 状态更新错误
    if (isMaterialExist && (isDirectory || !isFileAvalible)) {
        
        model.state = NotDownloaded;
        model.strMaterialPath = nil;
        isMaterialExist = NO;
    }
    
    if (model && model.material && !isMaterialExist) {
        
        model.state = IsDownloading;
        [self.effectsList reloadData];
        
        [[SenseArMaterialService sharedInstance]
         downloadMaterial:model.material
         onSuccess:^(SenseArMaterial *material)
         {
             
             model.state = Downloaded;
             model.strMaterialPath = material.strMaterialPath;
             
             if (model == weakSelf.prepareModel) {
                 
                 [weakSelf setMaterialModel:model];
             }else{
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [weakSelf.effectsList reloadData];
                 });
             }
         }
         onFailure:^(SenseArMaterial *material, int iErrorCode, NSString *strMessage) {
             
             model.state = NotDownloaded;
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [weakSelf.effectsList reloadData];
             });
         }
         onProgress:nil];
    }else{
        
        [self setMaterialModel:model];
    }
}

#pragma mark -- private
- (void)cancelStickerAndObjectTrack {
    
    [self handleStickerChanged:nil];

    self.objectTrackCollectionView.selectedModel.isSelected = NO;
    [self.objectTrackCollectionView reloadData];
    self.objectTrackCollectionView.selectedModel = nil;

    if (self.commonObjectContainerView.currentCommonObjectView) {
        [self.commonObjectContainerView.currentCommonObjectView removeFromSuperview];
    }
    
    [self.senseEffectsManager cancelStickerAndObjectTrack];
}

- (void)setMaterialModel:(EffectsCollectionViewCellModel *)targetModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.triggerView.hidden = YES;
    });

    STWeakSelf
    [self.senseEffectsManager setMaterialModel:targetModel triggerSuccessBlock:^(NSString *contentText, NSString *imageName) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.effectsList reloadData];
            [weakSelf.triggerView showTriggerViewWithContent:contentText image:[UIImage imageNamed:imageName]];
        });
    } triggerFailBlock:^{
        [weakSelf.effectsList reloadData];
    }];
}

#pragma mark - STCommonObjectContainerViewDelegate
- (void)commonObjectViewStartTrackingFrame:(CGRect)frame {

    self.senseEffectsManager.commonObjectViewAdded = YES;
    self.senseEffectsManager.commonObjectViewSetted = NO;

    [self.senseEffectsManager resetTrackingFrame:frame];
}

- (void)commonObjectViewFinishTrackingFrame:(CGRect)frame {
    self.senseEffectsManager.commonObjectViewAdded = NO;
}

#pragma mark - lazy load array
- (NSArray *)arrObjectTrackers {
    if (!_arrObjectTrackers) {
        _arrObjectTrackers = [self getObjectTrackModels];
    }
    return _arrObjectTrackers;
}
- (NSArray *)getObjectTrackModels {
    
    NSMutableArray *arrModels = [NSMutableArray array];
    
    NSArray *arrImageNames = @[@"object_track_happy", @"object_track_hi", @"object_track_love", @"object_track_star", @"object_track_sticker", @"object_track_sun"];
    
    for (int i = 0; i < arrImageNames.count; ++i) {
        
        STCollectionViewDisplayModel *model = [[STCollectionViewDisplayModel alloc] init];
        model.strPath = NULL;
        model.strName = @"";
        model.index = i;
        model.isSelected = NO;
        model.image = [UIImage imageNamed:arrImageNames[i]];
        model.modelType = STEffectsTypeObjectTrack;
        
        [arrModels addObject:model];
    }
    
    return [arrModels copy];
}

- (void)resetCommonObjectViewPosition {
    if (self.commonObjectContainerView.currentCommonObjectView) {
        self.senseEffectsManager.commonObjectViewSetted = NO;
        self.senseEffectsManager.commonObjectViewAdded = NO;
        
        self.commonObjectContainerView.currentCommonObjectView.hidden = NO;
        self.commonObjectContainerView.currentCommonObjectView.onFirst = YES;
        self.commonObjectContainerView.currentCommonObjectView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    }
}
@end
