//
//  MOHomePageController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOHomePageController.h"
#import "MOPlayListManager.h"
#import "MOPlayList.h"
#import "MOMusicPlayer.h"

#import "MONewFeatureController.h"

@interface MOHomePageController ()

@property (nonatomic, assign) BOOL isShowed;

@end

@implementation MOHomePageController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MOPlayList *playList = [MOPlayListManager sharedInstance].allPlayLists.firstObject;
    MusicPlayer.songs = playList.allSongs;
    
    [self setupTestUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isShowed) {
        self.isShowed = YES;
        MONewFeatureController *featureVC = MONewFeatureController.new;
        [self presentViewController:featureVC animated:NO completion:nil];
    }
}



- (void)setupTestUI {
    Style(@"btn").fnt(16).color(@"blue").fitSize;
    
    UIButton *preBtn = Button.str(@"Pre").styles(@"btn").onClick(^{
        NSLog(@"%s", __func__);
        [MusicPlayer previous];
    }).touchInsets(-10,-10,-10,-10);
    
    UIButton *playBtn = Button.str(@"Play").styles(@"btn").onClick(^{
        NSLog(@"%s", __func__);
        [MusicPlayer play];
    }).touchInsets(-10,-10,-10,-10);
    
    UIButton *nextBtn = Button.str(@"Next").styles(@"btn").onClick(^{
        NSLog(@"%s", __func__);
        [MusicPlayer next];
    }).touchInsets(-20,-20,-20,-20);
    
    HorStack(NERSpring, preBtn, @(50), playBtn, @(50), nextBtn, NERSpring).embedIn(self.view, NERNull,0, 30, 0);
    
}


@end
