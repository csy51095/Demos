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

- (void)viewDidLoad {
    [super viewDidLoad];
    MOPlayList *playList = [MOPlayListManager sharedInstance].allPlayLists.firstObject;
    MusicPlayer.songs = playList.allSongs;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isShowed) {
        self.isShowed = YES;
        [self setupNewFeatureVC];
    }
}

- (void)setupNewFeatureVC {
    MONewFeatureController *featureVC = MONewFeatureController.new;
    [self presentViewController:featureVC animated:NO completion:nil];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
