//
//  STBMPModel.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, STBMPTYPE){
    STBMPTYPE_LIP = 0,
    STBMPTYPE_BROW,
    STBMPTYPE_FACE,
    STBMPTYPE_BLUSH,
    STBMPTYPE_EYE,
    STBMPTYPE_EYELINER,
    STBMPTYPE_EYELASH,
    STBMPTYPE_COUNT,
};

@interface STBMPModel : NSObject

@property (nonatomic, copy) NSString *m_iconDefault;
@property (nonatomic, copy) NSString *m_iconHighlight;
@property (nonatomic, copy) NSString *m_name;
@property (nonatomic, copy) NSString *m_zipPath;
@property (nonatomic, assign) BOOL m_selected;
@property (nonatomic, assign) STBMPTYPE m_bmpType;
@property (nonatomic, assign) int m_index;
@property (nonatomic, assign) float m_bmpStrength;

@end

