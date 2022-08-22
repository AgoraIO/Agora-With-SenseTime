//
//  STBMPDetailColV.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "STBMPDetailColV.h"
#import "STBMPDetailColVCell.h"

@interface STBMPDetailColV ()

//models
@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_lipsArr;
@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_blushsArr;
@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_browsArr;
@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_eyeshadowArr;
@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_eyelinerArr;
@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_eyelashArr;
@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_facesArr;

@property (nonatomic, assign) STBMPTYPE m_bmpType;

@property (nonatomic, assign) int m_lipsIndex;
@property (nonatomic, assign) int m_blushIndex;
@property (nonatomic, assign) int m_browIndex;
@property (nonatomic, assign) int m_eyeShadowIndex;
@property (nonatomic, assign) int m_eyeLinerIndex;
@property (nonatomic, assign) int m_eyeLashIndex;
@property (nonatomic, assign) int m_faceIndex;

//views
@property (nonatomic, strong) UICollectionView *m_bmpDtColV;
@end

@implementation STBMPDetailColV

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUis) name:@"resetUIs" object:nil];
        
        [self setupDefaults];
        
        [self setupUIs];
        
        return self;
    }
    
    return nil;
}

- (void)setupDefaults
{
    
    _m_blushsArr = [self getSourceFromPath:@"blush" bmpType:STBMPTYPE_BLUSH];
    _m_browsArr = [self getSourceFromPath:@"brow" bmpType:STBMPTYPE_BROW];
    _m_eyeshadowArr = [self getSourceFromPath:@"eyeshadow" bmpType:STBMPTYPE_EYE];
    _m_eyelinerArr = [self getSourceFromPath:@"eyeliner" bmpType:STBMPTYPE_EYELINER];
    _m_eyelashArr = [self getSourceFromPath:@"eyelash" bmpType:STBMPTYPE_EYELASH];
    _m_facesArr = [self getSourceFromPath:@"face" bmpType:STBMPTYPE_FACE];
    _m_lipsArr = [self getSourceFromPath:@"lips" bmpType:STBMPTYPE_LIP];
    
    _m_lipsIndex = _m_blushIndex = _m_browIndex = _m_eyeShadowIndex = _m_eyeLinerIndex = _m_eyeLashIndex = _m_faceIndex = 0;
}

- (void)resetUis
{
    [self setupDefaults];
    
    [_m_bmpDtColV reloadData];
    
    STBMPModel *resetModel = [[STBMPModel alloc] init];
    resetModel.m_bmpStrength = 0.8;
    
    for (int i = 0; i < STBMPTYPE_COUNT; ++i) {
        
        if (self.delegate) {
            
            [self.delegate didSelectedModel:resetModel];
        }
    }
}

- (NSMutableArray *)getSourceFromPath:(NSString *)beautyType bmpType:(STBMPTYPE)bmpType
{
    NSString *strLocalBundlePath = [[NSBundle mainBundle] pathForResource:beautyType ofType:@"bundle"];
    NSArray *arrFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strLocalBundlePath error:nil];
    [arrFiles sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *array = [NSMutableArray array];
    STBMPModel *model = [[STBMPModel alloc] init];
    model.m_iconDefault = @"close_white";
    model.m_name = @"None";
    model.m_index = 0;
    model.m_bmpType = bmpType;
    model.m_bmpStrength = 0.8f;
    [array addObject:model];
    for (NSString *strFileName in arrFiles) {
        if ([strFileName hasSuffix:@".zip"]) {
            NSString *strBmpPath = [strLocalBundlePath stringByAppendingPathComponent:strFileName];
            NSString *strName = [[strBmpPath stringByDeletingPathExtension] lastPathComponent];
            NSString *strThumbPath = [[strBmpPath stringByDeletingPathExtension] stringByAppendingString:@".png"];
            STBMPModel *model = [[STBMPModel alloc] init];
            model.m_iconDefault = strThumbPath;
            model.m_zipPath = strBmpPath;
            model.m_name = strName;
            model.m_index = (int)[arrFiles indexOfObject:strFileName] + 1;
            model.m_bmpStrength = 0.8f;
            model.m_bmpType = bmpType;
            [array addObject:model];
        }
    }
    return array;
}


- (void)setupUIs
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(70, 80);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.m_bmpDtColV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 80) collectionViewLayout:flowLayout];
    self.m_bmpDtColV.delegate = self;
    self.m_bmpDtColV.dataSource = self;
    self.m_bmpDtColV.backgroundColor = [UIColor clearColor];
    self.m_bmpDtColV.showsVerticalScrollIndicator = NO;
    [self.m_bmpDtColV registerClass:[STBMPDetailColVCell class] forCellWithReuseIdentifier:@"STBMPDetailColVCell"];
    [self addSubview:self.m_bmpDtColV];
}

- (void)didSelectedBmpType:(STBMPModel *)model
{
    if (_m_bmpType != model.m_bmpType) {
        
        _m_bmpType = model.m_bmpType;
        
        [_m_bmpDtColV reloadData];
    }
}

#pragma collectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (_m_bmpType) {
        case STBMPTYPE_EYE:
            return _m_eyeshadowArr.count;
            break;
        case STBMPTYPE_EYELINER:
            return _m_eyelinerArr.count;
            break;
        case STBMPTYPE_EYELASH:
            return _m_eyelashArr.count;
            break;
        case STBMPTYPE_LIP:
            return _m_lipsArr.count;
            break;
        case STBMPTYPE_BROW:
            return _m_browsArr.count;
            break;
        case STBMPTYPE_BLUSH:
            return _m_blushsArr.count;
            break;
        case STBMPTYPE_FACE:
            return _m_facesArr.count;
            break;
        case STBMPTYPE_COUNT:
            break;
    }
    return 0;
}

#pragma dataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    STBMPDetailColVCell *cell = (STBMPDetailColVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"STBMPDetailColVCell" forIndexPath:indexPath];
    STBMPModel *model = nil;
    int index = (int)indexPath.row;
    switch (_m_bmpType) {
        case STBMPTYPE_EYE:
            model = _m_eyeshadowArr[index];
            if (index == _m_eyeShadowIndex) {
                [cell setDidSelected:YES];
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }else{
                [cell setDidSelected:NO];
            }
            break;
        case STBMPTYPE_EYELINER:
            model = _m_eyelinerArr[index];
            if (index == _m_eyeLinerIndex) {
                [cell setDidSelected:YES];
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }else{
                [cell setDidSelected:NO];
            }
            break;
        case STBMPTYPE_EYELASH:
            model = _m_eyelashArr[index];
            if (index == _m_eyeLashIndex) {
                [cell setDidSelected:YES];
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }else{
                [cell setDidSelected:NO];
            }
            break;
        case STBMPTYPE_LIP:
            model = _m_lipsArr[index];
            if (index == _m_lipsIndex) {
                [cell setDidSelected:YES];
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }else{
                [cell setDidSelected:NO];
            }
            break;
        case STBMPTYPE_BROW:
            model = _m_browsArr[index];
            if (index == _m_browIndex) {
                [cell setDidSelected:YES];
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }else{
                [cell setDidSelected:NO];
            }
            break;
        case STBMPTYPE_BLUSH:
            model =_m_blushsArr[index];
            if (index == _m_blushIndex) {
                [cell setDidSelected:YES];
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }else{
                [cell setDidSelected:NO];
            }
            break;
        case STBMPTYPE_FACE:
            model = _m_facesArr[index];
            if (index == _m_faceIndex) {
                [cell setDidSelected:YES];
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }else{
                [cell setDidSelected:NO];
            }
            break;
        case STBMPTYPE_COUNT:
            break;
    }
    [cell setName:model.m_name];
    [cell setIcon:model.m_iconDefault];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    STBMPModel *model = nil;
    switch (_m_bmpType) {
        case STBMPTYPE_EYE:
            model = _m_eyeshadowArr[(int)indexPath.row];
            if ((int)indexPath.row == _m_eyeShadowIndex) {
                _m_eyeShadowIndex = -1;
                STBMPModel *unModel = [[STBMPModel alloc] init];
                unModel.m_bmpType = STBMPTYPE_EYE;
                if (self.delegate) {
                    [self.delegate didSelectedModel:unModel];
                }
            }else{
                _m_eyeShadowIndex = (int)indexPath.row;
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }
            [_m_bmpDtColV reloadData];
            break;
        case STBMPTYPE_EYELINER:
            model = _m_eyelinerArr[(int)indexPath.row];
            if ((int)indexPath.row == _m_eyeLinerIndex) {
                _m_eyeLinerIndex = -1;
                STBMPModel *unModel = [[STBMPModel alloc] init];
                unModel.m_bmpType = STBMPTYPE_EYELINER;
                if (self.delegate) {
                    [self.delegate didSelectedModel:unModel];
                }
            }else{
                _m_eyeLinerIndex = (int)indexPath.row;
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }
            [_m_bmpDtColV reloadData];
            break;
        case STBMPTYPE_EYELASH:
            model = _m_eyelashArr[(int)indexPath.row];
            if ((int)indexPath.row == _m_eyeLashIndex) {
                _m_eyeLashIndex = -1;
                STBMPModel *unModel = [[STBMPModel alloc] init];
                unModel.m_bmpType = STBMPTYPE_EYELASH;
                if (self.delegate) {
                    [self.delegate didSelectedModel:unModel];
                }
            }else{
                _m_eyeLashIndex = (int)indexPath.row;
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }
            [_m_bmpDtColV reloadData];
            break;
        case STBMPTYPE_LIP:
            model = _m_lipsArr[(int)indexPath.row];
            if ((int)indexPath.row == _m_lipsIndex) {
                _m_lipsIndex = -1;
                STBMPModel *unModel = [[STBMPModel alloc] init];
                unModel.m_bmpType = STBMPTYPE_LIP;
                if (self.delegate) {
                    [self.delegate didSelectedModel:unModel];
                }
            }else{
                _m_lipsIndex = (int)indexPath.row;
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }
            [_m_bmpDtColV reloadData];
            break;
        case STBMPTYPE_BROW:
            model = _m_browsArr[(int)indexPath.row];
            if ((int)indexPath.row == _m_browIndex) {
                _m_browIndex = -1;
                STBMPModel *unModel = [[STBMPModel alloc] init];
                unModel.m_bmpType = STBMPTYPE_BROW;
                if (self.delegate) {
                    [self.delegate didSelectedModel:unModel];
                }
            }else{
                _m_browIndex = (int)indexPath.row;
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }
            [_m_bmpDtColV reloadData];
            break;
        case STBMPTYPE_BLUSH:
            model = _m_blushsArr[(int)indexPath.row];
            if ((int)indexPath.row == _m_blushIndex) {
                _m_blushIndex = -1;
                STBMPModel *unModel = [[STBMPModel alloc] init];
                unModel.m_bmpType = STBMPTYPE_BLUSH;
                if (self.delegate) {
                    [self.delegate didSelectedModel:unModel];
                }
            }else{
                _m_blushIndex = (int)indexPath.row;
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }
            [_m_bmpDtColV reloadData];
            break;
        case STBMPTYPE_FACE:
            model = _m_facesArr[(int)indexPath.row];
            if ((int)indexPath.row == _m_faceIndex) {
                _m_faceIndex = -1;
                STBMPModel *unModel = [[STBMPModel alloc] init];
                unModel.m_bmpType = STBMPTYPE_FACE;
                if (self.delegate) {
                    [self.delegate didSelectedModel:unModel];
                }
            }else{
                _m_faceIndex = (int)indexPath.row;
                if (self.delegate) {
                    [self.delegate didSelectedModel:model];
                }
            }
            [_m_bmpDtColV reloadData];
            break;
        case STBMPTYPE_COUNT:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetUIs" object:nil];
}
@end
