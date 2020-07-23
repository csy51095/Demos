//
//  MOLrcBlendLabel.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/23.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOLrcBlendLabel : UILabel

@property (nonatomic, strong) UIColor *highlightedColor;

- (void)canTint:(BOOL)canTint;

- (void)tintPercent:(CGFloat)percent;


@end

NS_ASSUME_NONNULL_END
