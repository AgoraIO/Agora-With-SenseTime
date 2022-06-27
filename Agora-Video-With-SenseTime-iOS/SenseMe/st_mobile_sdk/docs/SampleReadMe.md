## iOS Sample 运行指南

## 目录
1. sample 运行
2. sample 主要文件结构


### 1. sample 运行
#### 1.1 解压压缩包 

docs: 包含集成文档、常见问题、sample运行指南

include: SDK头文件

lib： SDK静态库文件

licnese：授权文件

models： 检测模型

samples： sample文件夹

VERSION: 版本信息


#### 1.2 运行项目 

用Xcode打开samples文件夹下的SenseMeEffects.xcodeproj

### 2. sample 主要文件结构
```
SenseMeEffectsCodes：
.
├── SenseMeEffects
│   ├── AppDelegate
│   │   ├── AppDelegate.h
│   │   ├── AppDelegate.m
│   │   ├── SceneDelegate.h
│   │   └── SceneDelegate.m
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── Config
│   │   └── Prefix.pch
│   ├── EFRender
│   │   ├── Effects.h
│   │   ├── Effects.m
│   │   ├── EffectsAnimal.h
│   │   ├── EffectsAnimal.m
│   │   ├── EffectsAttribute.h
│   │   ├── EffectsAttribute.m
│   │   ├── EffectsBase.h
│   │   ├── EffectsBase.m
│   │   ├── EffectsCamera.h
│   │   ├── EffectsCamera.m
│   │   ├── EffectsColorConversion.h
│   │   ├── EffectsColorConversion.m
│   │   ├── EffectsDetector.h
│   │   ├── EffectsDetector.m
│   │   ├── EffectsGLPreview.h
│   │   ├── EffectsGLPreview.m
│   │   ├── EffectsGLShader.h
│   │   ├── EffectsGLShader.m
│   │   ├── EffectsImageUtils.h
│   │   ├── EffectsImageUtils.m
│   │   ├── EffectsProcess.h
│   │   ├── EffectsProcess.m
│   │   ├── EffectsRender.h
│   │   ├── EffectsRender.m
│   │   ├── EffectsTracker.h
│   │   ├── EffectsTracker.m
│   │   ├── EffectsUtils.h
│   │   └── EffectsUtils.m
│   ├── EffectsAVPlayer
│   │   ├── EFAVPlayer.h
│   │   └── EFAVPlayer.m
│   ├── EffectsAudioPlayer
│   │   ├── EffectsAudioPlayer.h
│   │   ├── EffectsAudioPlayer.m
│   │   ├── EffectsAudioPlayerManager.h
│   │   └── EffectsAudioPlayerManager.m
│   ├── EffectsProcessVC
│   │   ├── EFBaseEffectsProcess.h
│   │   ├── EFBaseEffectsProcess.m
│   │   ├── EFImageVC
│   │   │   ├── EFImageVC.h
│   │   │   └── EFImageVC.m
│   │   ├── EFPreviewVC
│   │   │   ├── EFPreviewVC.h
│   │   │   └── EFPreviewVC.m
│   │   ├── EFVideoVC
│   │   │   ├── EFVideoVC.h
│   │   │   └── EFVideoVC.m
│   │   ├── STEffectsAudioPlayer.h
│   │   ├── STEffectsAudioPlayer.m
│   │   ├── View
│   │   │   ├── Category
│   │   │   │   ├── UIView+Model.h
│   │   │   │   └── UIView+Model.m
│   │   │   ├── EFCommonView
│   │   │   │   ├── EFCommonObjectContainerView.h
│   │   │   │   ├── EFCommonObjectContainerView.m
│   │   │   │   ├── EFCommonObjectView.h
│   │   │   │   └── EFCommonObjectView.m
│   │   │   ├── EFEffectsCollectionView
│   │   │   │   ├── EFContentCell.h
│   │   │   │   ├── EFContentCell.m
│   │   │   │   ├── EFEffectsCollectionView.h
│   │   │   │   ├── EFEffectsCollectionView.m
│   │   │   │   ├── EFEffectsContentView.h
│   │   │   │   ├── EFEffectsContentView.m
│   │   │   │   ├── EFTitleCell.h
│   │   │   │   └── EFTitleCell.m
│   │   │   ├── EFEffectsView.h
│   │   │   ├── EFEffectsView.m
│   │   │   ├── EFMakeupFilterBeauty
│   │   │   │   ├── EFBeautySlider.h
│   │   │   │   ├── EFBeautySlider.m
│   │   │   │   ├── EFMakeupFilterBeautyCell.h
│   │   │   │   ├── EFMakeupFilterBeautyCell.m
│   │   │   │   ├── EFMakeupFilterBeautyContentView.h
│   │   │   │   ├── EFMakeupFilterBeautyContentView.m
│   │   │   │   ├── EFMakeupFilterBeautyView.h
│   │   │   │   └── EFMakeupFilterBeautyView.m
│   │   │   ├── EFTriggerView
│   │   │   │   ├── EFTriggerView.h
│   │   │   │   └── EFTriggerView.m
│   │   │   ├── EFVideoRecorderView
│   │   │   │   ├── EFVideoRecorderView.h
│   │   │   │   ├── EFVideoRecorderView.m
│   │   │   │   ├── STCircleProgressBar.h
│   │   │   │   └── STCircleProgressBar.m
│   │   │   ├── NavigationView
│   │   │   │   ├── EFNavigationView.h
│   │   │   │   └── EFNavigationView.m
│   │   │   ├── PopView
│   │   │   │   ├── EFResolutionPopView.h
│   │   │   │   ├── EFResolutionPopView.m
│   │   │   │   ├── EFSettingPopView.h
│   │   │   │   └── EFSettingPopView.m
│   │   │   └── StyleView
│   │   │       ├── EFStyleContentCell.h
│   │   │       ├── EFStyleContentCell.m
│   │   │       ├── EFStyleContentView.h
│   │   │       ├── EFStyleContentView.m
│   │   │       ├── EFStyleView.h
│   │   │       ├── EFStyleView.m
│   │   │       ├── EFStyleViewLayout.h
│   │   │       └── EFStyleViewLayout.m
│   │   └── category
│   │       ├── EFImageVC+EFStatusManagerDelegate.h
│   │       ├── EFImageVC+EFStatusManagerDelegate.m
│   │       ├── EFPreviewVC+EFStatusManagerDelegate.h
│   │       ├── EFPreviewVC+EFStatusManagerDelegate.m
│   │       ├── EFVideoVC+EFStatusManagerDelegate.h
│   │       └── EFVideoVC+EFStatusManagerDelegate.m
│   ├── EffectsUtils
│   │   ├── EFMotionManager.h
│   │   ├── EFMotionManager.m
│   │   ├── EffectsLicense.h
│   │   ├── EffectsLicense.m
│   │   ├── EffectsLog.h
│   │   └── EffectsLog.m
│   ├── EffectsVideoRecorder
│   │   ├── EFAudioManager.h
│   │   ├── EFAudioManager.m
│   │   ├── EFMovieRecorder.h
│   │   ├── EFMovieRecorder.m
│   │   ├── EFMovieRecorderManager.h
│   │   └── EFMovieRecorderManager.m
│   ├── Info.plist
│   ├── Language
│   │   ├── NSBundle+language.h
│   │   ├── NSBundle+language.m
│   │   ├── en.lproj
│   │   │   └── Localizable.strings
│   │   └── zh-Hans.lproj
│   │       └── Localizable.strings
│   ├── Main
│   │   ├── Base.lproj
│   │   │   └── Main.storyboard
│   │   ├── Controller
│   │   │   ├── EFAllEffectsController.h
│   │   │   ├── EFAllEffectsController.m
│   │   │   ├── EFFaceDetectController.h
│   │   │   ├── EFFaceDetectController.m
│   │   │   ├── EFWebViewController.h
│   │   │   ├── EFWebViewController.m
│   │   │   ├── ViewController.h
│   │   │   └── ViewController.m
│   │   ├── View
│   │   │   ├── EFAllEffectsCell.h
│   │   │   ├── EFAllEffectsCell.m
│   │   │   ├── EFItemCell.h
│   │   │   ├── EFItemCell.m
│   │   │   ├── EFMainTypeCell.h
│   │   │   └── EFMainTypeCell.m
│   │   ├── ViewController.m
│   │   ├── main.m
│   │   └── zh-Hans.lproj
│   │       └── Main.strings
│   ├── TermsOfUse.htm
│   ├── Widget
│   │   ├── Banner
│   │   │   ├── STBannerCell.h
│   │   │   ├── STBannerCell.m
│   │   │   ├── STBannerView.h
│   │   │   └── STBannerView.m
│   │   ├── EFSaveToast
│   │   │   ├── EFToast.h
│   │   │   └── EFToast.m
│   │   ├── NavigationController
│   │   │   ├── STNavigationController.h
│   │   │   └── STNavigationController.m
│   │   └── XTPopView
│   │       ├── XTPopTableView.h
│   │       ├── XTPopTableView.m
│   │       ├── XTPopViewBase.h
│   │       └── XTPopViewBase.m
│   ├── datasource # demo数据状态层：demo中素材的拉取加载、状态的保存以及恢复
│   │   ├── EFDataSourceGenerator.h
│   │   ├── EFDataSourceGenerator.m
│   │   ├── EFSenseArMaterialDataModels.h
│   │   ├── EFSenseArMaterialDataModels.m
│   │   ├── all_categories.json
│   │   ├── beauties.json
│   │   ├── effects_service_group_list.json
│   │   ├── helpers
│   │   │   ├── EFAuthorizeAdapter.h
│   │   │   ├── EFAuthorizeAdapter.m
│   │   │   ├── EFDefaultBeautyGeneratHelper.h
│   │   │   ├── EFDefaultBeautyGeneratHelper.m
│   │   │   ├── EFRemoteDataSourceHelper.h
│   │   │   ├── EFRemoteDataSourceHelper.m
│   │   │   ├── EFStorageHelper.h
│   │   │   ├── EFStorageHelper.m
│   │   │   ├── NSDictionary+jsonFile.h
│   │   │   ├── NSDictionary+jsonFile.m
│   │   │   ├── NSObject+dictionary.h
│   │   │   └── NSObject+dictionary.m
│   │   ├── interfaces
│   │   │   └── EFDataSourcing.h
│   │   ├── material_group_map_rulues.json
│   │   ├── remoteSourcesLib
│   │   │   ├── include
│   │   │   │   ├── SenseArMaterial.h
│   │   │   │   ├── SenseArMaterialAction.h
│   │   │   │   ├── SenseArMaterialGroup.h
│   │   │   │   ├── SenseArMaterialService.h
│   │   │   │   └── SenseArSourceService.h
│   │   │   └── lib
│   │   │       └── ios_universal
│   │   │           └── libSenseArSourceService.a
│   │   └── status
│   │       ├── EFMaterialDownloadStatusManager.h
│   │       ├── EFMaterialDownloadStatusManager.m
│   │       ├── EFStatusManager.h
│   │       ├── EFStatusManager.m
│   │       ├── EFStatusManagerDelegate.h
│   │       ├── EFStatusModels.h
│   │       └── EFStatusModels.m
│   ├── en.lproj
│   │   └── LaunchScreen.strings
│   └── zh-Hans.lproj
│       └── LaunchScreen.strings
└── direc_tree.txt

```
