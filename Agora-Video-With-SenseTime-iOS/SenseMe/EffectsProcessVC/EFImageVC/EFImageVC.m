//
//  EFImageVC.m
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/28.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFImageVC.h"
#import "EffectsImageUtils.h"
#import "EFEffectsView.h"
#import "EFNavigationView.h"
#import "EFEffectsCollectionView.h"
#import "EFMakeupFilterBeautyView.h"
#import "EFSettingPopView.h"
#import "EFResolutionPopView.h"
#import "EFStyleView.h"
#import <Photos/Photos.h>
#import "EFToast.h"

@interface EFImageVC ()<EFNavigationViewDelegate, EFEffectsViewDelegate, EFMakeupFilterBeautyViewDelegate, EFEffectsCollectionViewDelegate>
{
    GLuint _textureInput;
}
@property (nonatomic, strong) UIImage *imageProcessed;
@property (nonatomic, strong) UIImageView *processingImageView;
@property (nonatomic, strong) EFNavigationView *navigationView;
@property (nonatomic, strong) EFEffectsView *effectsView;
///特效
@property (nonatomic, strong) EFEffectsCollectionView *efCollectionView;
///美妆 美颜 滤镜
@property (nonatomic, strong) EFMakeupFilterBeautyView *efMakeupFilterBeautyView;
///风格
@property (nonatomic, strong) EFStyleView *styleView;
@end

@implementation EFImageVC
- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createEffectProcess];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
    [EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode2].efDelegate = self;
#pragma clang diagnostic pop
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)createEffectProcess{
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.ciContext = [CIContext contextWithEAGLContext:self.glContext];
                                               
    self.effectsProcess = [[EffectsProcess alloc] initWithType:EffectsTypePhoto
                                                     glContext:self.glContext];
    dispatch_async(dispatch_get_global_queue(0, 0),  ^{
        [self.effectsProcess setModelPath:[[NSBundle mainBundle] pathForResource:@"model" ofType:@"bundle"]];
        
        if (![[EAGLContext currentContext] isEqual:self.glContext]) {
            [EAGLContext setCurrentContext:self.glContext];
        }
        NSString *microPlasticDefaultPath = [[NSBundle mainBundle] pathForResource:@"3DMicroPlasticDefault" ofType:@"zip"];
        [self.effectsProcess setEffectType:EFFECT_BEAUTY_3D_MICRO_PLASTIC path:microPlasticDefaultPath];
        [self.effectsProcess getMeshList];
        
        [[EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode2] efTriggerAllStorage];
    });
    
    CGRect previewRect = [self getZoomedRectWithImageWidth:self.imageOriginal.size.width
                                                    height:self.imageOriginal.size.height
                                                    inRect:self.view.bounds
                                                scaleToFit:YES];
    self.effecgGLPreview = [[EffectsGLPreview alloc] initWithFrame:previewRect
                                                           context:self.glContext];
    [self.view insertSubview:self.effecgGLPreview atIndex:0];
}

#pragma mark - Image Process
- (void)processImageAndDisplay {
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    self.view.userInteractionEnabled = NO;
    self.imageProcessed = [self processImageAndReturnTexture];
    self.processingImageView.image = self.imageProcessed;
    self.view.userInteractionEnabled = YES;
}
- (UIImage *)processImageAndReturnTexture{
    if (self.imageOriginal) {
        if (UIImageOrientationUp != self.imageOriginal.imageOrientation) {
            UIGraphicsBeginImageContext(self.imageOriginal.size);
            [self.imageOriginal drawInRect:CGRectMake(0, 0, self.imageOriginal.size.width, self.imageOriginal.size.height)];
            self.imageOriginal = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    int dataSize = self.imageOriginal.size.width * self.imageOriginal.size.height * 4;
    unsigned char * pBGRAImageIn = (unsigned char * )malloc(dataSize);
    
    [EffectsImageUtils convertUIImage:self.imageOriginal toBGRABytes:pBGRAImageIn];
    
    int iBytesPerRow = self.imageOriginal.size.width * 4;
    int iWidth = self.imageOriginal.size.width;
    int iHeight = self.imageOriginal.size.height;
    // 设置 OpenGL 环境 , 需要与初始化 SDK 时一致
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    _textureInput = [self.effectsProcess createTextureWidth:iWidth height:iHeight];
    glBindTexture(GL_TEXTURE_2D, _textureInput);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, iWidth, iHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, pBGRAImageIn);
    
    if (!_outTexture)
        [self.effectsProcess createGLObjectWith:iWidth
                                         height:iHeight
                                        texture:&_outTexture
                                    pixelBuffer:&_outputPixelBuffer
                                      cvTexture:&_outputCVTexture];
    // 人脸信息检测
    [self.effectsProcess processData:pBGRAImageIn
                                size:dataSize
                               width:iWidth
                              height:iHeight
                              stride:iBytesPerRow
                              rotate:ST_CLOCKWISE_ROTATE_0
                         pixelFormat:ST_PIX_FMT_RGBA8888
                        inputTexture:_textureInput
                          outTexture:_outTexture
                      outPixelFormat:ST_PIX_FMT_BGRA8888
                             outData:nil];
    
    
    if (pBGRAImageIn) {
        free(pBGRAImageIn);
    }
    glDeleteTextures(1, &_textureInput);
    glFlush();
    
    CGImageRef cgImage = [EffectsImageUtils getCGImageWithTexture:_outTexture
                                                            width:iWidth
                                                           height:iHeight
                                                        ciContext:self.ciContext];
    
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return imageResult;
}



#pragma mark - UI
- (void)setupSubviews {
    [self.view addSubview:self.processingImageView];
    self.navigationView = [[EFNavigationView alloc]initWithFrame:CGRectZero type:EFViewTypePhoto];
    self.navigationView.delegate = self;
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(92);
    }];
    self.effectsView = [[EFEffectsView alloc] initWithFrame:CGRectZero type:EFViewTypePhoto];
    self.effectsView.delegate = self;
    [self.view addSubview:self.effectsView];
    [self.effectsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.efCollectionView = [[EFEffectsCollectionView alloc]initWithFrame:CGRectZero model:EFStatusManagerSingletonMode2];
    self.efCollectionView.delegate = self;
    [self.view addSubview:self.efCollectionView];
    
    self.efMakeupFilterBeautyView = [[EFMakeupFilterBeautyView alloc]initWithFrame:CGRectZero model:EFStatusManagerSingletonMode2];
    self.efMakeupFilterBeautyView.delegate = self;
    [self.view addSubview:self.efMakeupFilterBeautyView];
    
    self.styleView = [[EFStyleView alloc]initWithFrame:CGRectZero model:EFStatusManagerSingletonMode2];
    [self.view addSubview:self.styleView];
}

#pragma mark - EFMakeupFilterBeautyViewDelegate
- (void)compareClick:(UIButton *)btn {
    self.processingImageView.image = btn.selected ? self.imageOriginal : self.imageProcessed;
}


#pragma mark - EFNavigationViewDelegate
- (void)EFNavigationView:(EFNavigationView *)view didSelect:(NSInteger)index sender:(id)sender{
    switch (index) {
        case 0:
        {
            //清除贴纸
            if ([EAGLContext currentContext] != self.glContext) {
                [EAGLContext setCurrentContext:self.glContext];
            }
            if(_outTexture) glDeleteTextures(1, &_outTexture);
            [[EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode2] efRestoreCurrentStorageFromCache];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            //保存
        case 1:
        {
            [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageProcessed];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [EFToast show:self.view description:error ? NSLocalizedString(@"图片保存失败", nil)  : NSLocalizedString(@"图片保存成功", nil)];
                });
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - EFEffectsViewDelegate
- (void)efEffectsView:(EFEffectsView *)view amplificationContrastAction:(NSInteger)index sender:(nonnull id)sender{
    switch (index) {
        case 0:
            break;
        case 1:{
            UIButton *btn = (UIButton *)sender;
            self.processingImageView.image = btn.selected ? self.imageOriginal : self.imageProcessed;
        }
            break;
        default:
            break;
    }
}


- (void)efEffectsView:(EFEffectsView *)view effectsAction:(EFDataSourceModel *)model index:(int)index {
    if ([model.efName isEqualToString:@"特效"]) {
        self.efCollectionView.dataSource = [model.efSubDataSources mutableCopy];
        [self.efCollectionView show:self.view select:index];
    }
    if ([model.efName isEqualToString:@"美妆"]) {
        self.efMakeupFilterBeautyView.dataSource = [model.efSubDataSources mutableCopy];
        self.efMakeupFilterBeautyView.itemType = effectsItemMakeup;
        [self.efMakeupFilterBeautyView show:self.view select:index];
    }
    if ([model.efName isEqualToString:@"滤镜"]) {
        self.efMakeupFilterBeautyView.dataSource = [model.efSubDataSources mutableCopy];
        self.efMakeupFilterBeautyView.itemType = effectsItemFilter;
        [self.efMakeupFilterBeautyView show:self.view select:index];
    }
    if ([model.efName isEqualToString:@"美颜"]) {
        self.efMakeupFilterBeautyView.dataSource = [model.efSubDataSources mutableCopy];
        self.efMakeupFilterBeautyView.itemType = effectsItemBeauty;
        [self.efMakeupFilterBeautyView show:self.view select:index];
    }
    
    [self.effectsView hideSubview:YES];
    [[EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode2] efGetOverLapAndUpdateCurrentStorage];
}

- (void)efEffectsView:(EFEffectsView *)view videoCamearStyleAction:(EffectsActionType)type {
    switch (type) {
        case effectsPhoto:
            break;
        case effectsStyle:
            [[EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode2] efGetOverLapAndUpdateCurrentStorage];
            [self.styleView show:self.view];
            break;
        case effectsVideo:
            break;
        case effectsTakePhoto:
            break;
        case effectsRecord:
            break;
    }
}

#pragma mark - hidden touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UIView *view = [touches anyObject].view;
    //特效
    if (view.tag == 1000) {
        [self.effectsView hideSubview:NO];
        [self.efCollectionView dismiss:self.view];
    }
    //美妆 滤镜 美颜
    if (view.tag == 1001) {
        [self.effectsView hideSubview:NO];
        [self.efMakeupFilterBeautyView dismiss:self.view];
    }
    if ([view isEqual:self.effecgGLPreview] || [view isEqual:self.processingImageView]) {
        [self.styleView dismiss:self.view];
        [self.effectsView contentOffset:100];
    }
}

#pragma mark - setter/getter
- (UIImageView *)processingImageView{
    if (!_processingImageView) {
        _processingImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _processingImageView.image = _imageOriginal;
        _processingImageView.backgroundColor = [UIColor clearColor];
        _processingImageView.userInteractionEnabled = YES;
        _processingImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _processingImageView;
}

#pragma mark - EFEffectsCollectionView & EFEffectsCollectionViewDelegate
-(void)setShowPhotoStripView:(BOOL)showPhotoStripView {
    _showPhotoStripView = showPhotoStripView;
    self.efCollectionView.showPhotoStripView = showPhotoStripView;
}

-(void)effectsCollectionView:(EFEffectsCollectionView *)effectsCollectionView selectedImage:(UIImage *)image {
    [self setImageBackground:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self processImageAndDisplay];
    });
}

@end
