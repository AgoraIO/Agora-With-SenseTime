//
//  STEffectsAudioPlayer.h
//
//  Created by sluin on 2017/8/16.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STEffectsAudioPlayerDelegate;

@interface STEffectsAudioPlayer : NSObject

@property (nonatomic , weak) id<STEffectsAudioPlayerDelegate> delegate;

- (BOOL)loadSound:(NSData *)soundData name:(NSString *)strName;
- (BOOL)playSound:(NSString *)strName loop:(int)iLoop; /*  */
- (void)stopSound:(NSString *)strName;
- (void)unloadSound:(NSString *)strName;
- (void)pauseSound:(NSString *)strName;
- (void)resumeSound:(NSString *)strName;
- (void)clearAll;

@end

@protocol STEffectsAudioPlayerDelegate <NSObject>

- (void)audioPlayerDidFinishPlaying:(STEffectsAudioPlayer *)player successfully:(BOOL)flag name:(NSString *)strName;

@end
