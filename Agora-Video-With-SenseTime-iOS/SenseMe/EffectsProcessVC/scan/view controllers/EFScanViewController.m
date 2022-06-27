//
//  EFScanViewController.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EFScanAnimationView.h"
#import "HXPhotoPicker.h"
#import "HXAssetManager.h"
#import "NSBundle+language.h"
#import "NSString+aes.h"

@interface EFScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong) AVCaptureSession *captureSession;

@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;

@property (nonatomic,strong) AVCaptureMetadataOutput *metaDataOutput;

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) UIButton *albumButton;

@end

@implementation EFScanViewController

static NSString * const aes_key = @"c62f46da583b48f7";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"扫描二维码", nil);
    
    [self.view.layer addSublayer:self.videoPreviewLayer];
    [self startCapture];
    
    [self customAlbumButton];
    [self customUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - ui
-(void)customAlbumButton {
    self.albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.albumButton setBackgroundImage:[UIImage imageNamed:@"scan_album"] forState:UIControlStateNormal];
    [self.albumButton addTarget:self action:@selector(onAlbumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *albumBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.albumButton];
    self.navigationItem.rightBarButtonItem = albumBarButton;
}

-(void)customUI {
    EFScanAnimationView *boxView = [[EFScanAnimationView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:boxView];
    
    [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view).inset(65);
        make.height.equalTo(boxView.mas_width);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).inset(100);
    }];
    
    UIView *topView = [self viewFactory];
    [self.view addSubview:topView];

    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(boxView.mas_top);
    }];
    
    UIView *leftView = [self viewFactory];
    [self.view addSubview:leftView];

    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(topView);
        make.top.equalTo(topView.mas_bottom);
        make.trailing.equalTo(boxView.mas_leading);
        make.bottom.equalTo(boxView);
    }];
    
    UIView *rightView = [self viewFactory];
    [self.view addSubview:rightView];

    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(boxView.mas_trailing);
        make.top.equalTo(topView.mas_bottom);
        make.trailing.equalTo(topView);
        make.bottom.equalTo(boxView);
    }];
    
    UIView *bottomView = [self viewFactory];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(topView);
        make.top.equalTo(boxView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

-(UIView *)viewFactory {
    UIView *factoryView = [[UIView alloc] initWithFrame:CGRectZero];
    factoryView.backgroundColor = UIColor.blackColor;
    factoryView.alpha = 0.6;
    return factoryView;
}

#pragma mark - notification
-(void)appDidBecomeActive {
    [self.captureSession startRunning];
}

#pragma mark - scan
- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _captureSession;
}

- (AVCaptureDeviceInput *)deviceInput{
    if (!_deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error) {
            return nil;
        }
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)metaDataOutput{
    if (!_metaDataOutput) {
        _metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metaDataOutput setMetadataObjectsDelegate:self queue:        dispatch_get_main_queue()];
 
    }
    return _metaDataOutput;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer{
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPreviewLayer.frame = self.view.bounds;
    }
    return _videoPreviewLayer;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //获取到扫描的数据
    AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *) [metadataObjects lastObject];
    if (dataObject && dataObject.stringValue) {
        [self stopCapture];
        [self scanFinishedWithString:dataObject.stringValue];
    }
}

#pragma makr - 请求权限
- (BOOL)requestDeviceAuthorization{
    
    AVAuthorizationStatus deviceStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (deviceStatus == AVAuthorizationStatusRestricted ||
        deviceStatus ==AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

//开始扫描
- (void)startCapture{
    if (![self requestDeviceAuthorization]) {
        return;
    }
    [self.captureSession beginConfiguration];
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    // 设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    if ([self.captureSession canAddOutput:self.metaDataOutput]) {
        [self.captureSession addOutput:self.metaDataOutput];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSArray *types = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code];
        self.metaDataOutput.metadataObjectTypes =types;
//        NSArray *metadatTypes =  [_metaDataOutput availableMetadataObjectTypes];
//        NSLog(@"metadatTypes == %@",metadatTypes);
    }
    [self.captureSession commitConfiguration];
    
    [self.captureSession startRunning];
}

//停止扫描
- (void)stopCapture{
    [self.captureSession stopRunning];
}

#pragma mark - album
-(void)onAlbumButtonClick:(UIButton *)sender {
    HXPhotoManager *photoManager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhoto];
    photoManager.configuration.type = HXConfigurationTypeWXMoment;
    photoManager.configuration.photoMaxNum = 1;
    photoManager.configuration.hideOriginalBtn = YES;
    photoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_None;
    photoManager.configuration.openCamera = NO;
    
    NSString *language = [NSBundle currentLanguage];
    if ([language hasPrefix:@"zh-Hans"] || language == nil) {
        photoManager.configuration.languageType = HXPhotoLanguageTypeSc;
    }
    if ([language hasPrefix:@"en"]) {
        photoManager.configuration.languageType = HXPhotoLanguageTypeEn;
    }
    
    [self hx_presentSelectPhotoControllerWithManager:photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (photoList.count > 0) {
                UIImage *image = [HXAssetManager originImageForAsset:photoList.firstObject.asset];
                [self processingQRCodeFromImage:image];
            }
        });
    } cancel:^(UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
    }];
}

-(void)processingQRCodeFromImage:(UIImage *)codeImage {
    NSData *imageData = UIImagePNGRepresentation(codeImage);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray *contents = [detector featuresInImage:ciImage];
    if (contents.count > 0) {
        CIQRCodeFeature *feature = [contents lastObject];
        if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
            [self scanFinishedWithString:feature.messageString];
        }
    } else {
        [self scanError];
    }
}

#pragma mark - scan callback
-(void)scanFinishedWithString:(NSString *)result {
    EFScanResultObject *scanResultObjtct = [self isRightUrlString:result];
    if (scanResultObjtct) {
        if (self.scanCallback) {
            self.scanCallback(scanResultObjtct);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self scanError];
    }
}

-(EFScanResultObject *)isRightUrlString:(NSString *)urlString {
    __block EFScanResultObject *result = nil;
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:urlString]; /* 兼容老扫码逻辑 */
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"source"] && [obj.value isEqualToString:@"softsugar"]) {
            result = [[EFScanResultObject alloc] init];
            result.successed = YES;
            result.urlString = urlString;
        }
    }];
    
    if (!result) {
        NSData *scanData = [urlString aes_decryptDataBy:aes_key];
        if (scanData) {
            NSDictionary *foo = [NSJSONSerialization JSONObjectWithData:scanData options:kNilOptions error:nil];
            NSLog(@"%@", foo);
            result = [EFScanResultObject yy_modelWithJSON:scanData];
            if (result) {
                result.successed = YES;
            }
        }
    }
    
    return result;
}

-(void)scanError {
    UIAlertController *scanErrorAlertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"二维码识别失败", nil) message:NSLocalizedString(@"二维码格式不正确，未能识别二维码", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction  actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self startCapture];
    }];
    [scanErrorAlertController addAction:confirmAction];
    [self presentViewController:scanErrorAlertController animated:YES completion:nil];
}

#pragma mark - system
- (void)dealloc{
    [self.captureSession stopRunning];
    self.deviceInput = nil;
    self.metaDataOutput = nil;
    self.captureSession = nil;
    self.videoPreviewLayer = nil;
}

@end
