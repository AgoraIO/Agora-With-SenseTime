//
//  STViewButton.m
//  SenseMeEffects
//
//  Created by Sunshine on 15/08/2017.
//  Copyright © 2017 SenseTime. All rights reserved.
//

#import "STViewButton.h"

@interface STViewButton ()

@property (nonatomic, strong) dispatch_queue_t blockSerialQueue;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation STViewButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setLongPressGesture];
    }
    return self;
}

- (void)setTapBlock:(STTapBlock)tapBlock {
    
    _tapBlock = tapBlock;
    
    if (_tapBlock) {
        
        self.userInteractionEnabled = YES;
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        
        [self addGestureRecognizer:self.tapGesture];
        
        [self.longPressGesture requireGestureRecognizerToFail:self.tapGesture];
    }
}

- (void)setLongPressGesture {
    
    self.userInteractionEnabled = YES;
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];

    [self addGestureRecognizer:_longPressGesture];
}

- (void)onTap:(UITapGestureRecognizer *)recognizer {
    
    _tapBlock();

}

- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(btnLongPressBegin)]) {
            [self.delegate btnLongPressBegin];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(btnLongPressEnd)]) {
            [self.delegate btnLongPressEnd];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateFailed) {
        if ([self.delegate respondsToSelector:@selector(btnLongPressFailed)]) {
            [self.delegate btnLongPressFailed];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        
        if ([self.delegate respondsToSelector:@selector(btnLongPressEnd)]) {
            [self.delegate btnLongPressEnd];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateRecognized) {
        
        //todo
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        //todo
        
    } else if (recognizer.state == UIGestureRecognizerStatePossible) {
        
        //todo
        
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    _imageView.highlighted = highlighted;
    _titleLabel.highlighted = highlighted;
}

@end
