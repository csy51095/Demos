//
//  MONewFeatureController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/17.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MONewFeatureController.h"
#import <AVFoundation/AVFoundation.h>

@interface MONewFeatureController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation MONewFeatureController

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


- (void)setup {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PPT90200" withExtension:@"mp4"];
    self.player = [AVPlayer playerWithURL:url];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    [self.player play];
    
    CMTime duration = self.player.currentItem.asset.duration;
    CGFloat time = duration.value *1.0 / duration.timescale;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [layer removeFromSuperlayer];
        [self dismissViewControllerAnimated:YES completion:^{
            self.player = nil;
        }];
    });
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
