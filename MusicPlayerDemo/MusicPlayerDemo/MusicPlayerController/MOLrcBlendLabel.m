//
//  MOLrcBlendLabel.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/23.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOLrcBlendLabel.h"

@interface MOLrcBlendLabel ()

@property (nonatomic, assign) BOOL canTint;
@property (nonatomic, assign) CGFloat tintPercent;
@end


@implementation MOLrcBlendLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _canTint = NO;
        _tintPercent = 0.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!_canTint) return;

    UIColor *color = _highlightedColor ?: UIColor.blackColor;
    CGFloat width = self.bounds.size.width *_tintPercent;
    CGRect tintRect = CGRectMake(0, 0, width, self.bounds.size.height);
    [color set];
    
    UIRectFillUsingBlendMode(tintRect, kCGBlendModeSourceIn);
}

- (void)tintPercent:(CGFloat)percent {
    _tintPercent = percent;
    [self setNeedsDisplay];
}

- (void)canTint:(BOOL)canTint {
    _canTint = canTint;
    [self setNeedsDisplay];
}

@end
