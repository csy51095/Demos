//
//  MOMusicPlayerController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/19.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOMusicPlayerController.h"
#import "MOMusicPlayer.h"

@interface MOMusicPlayerController ()

@property (nonatomic, weak) UIButton *playBtn;

@end

@implementation MOMusicPlayerController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNotification];
    [self refreshUIWithPlayerStatus:MusicPlayer.status];
}

- (void)setupUI {
    self.view.bgColor(@"0xF5DEB3");
    
    UIButton *preBtn = Button.img(@"btn_pre_normal").onClick(^{
        [MusicPlayer previous];
    });
    
    UIButton *playBtn = Button.img(@"btn_play_normal").selectedImg(@"btn_pause_normal").onClick(^{
        if (MusicPlayer.status == MOMusicPlayerStatusPause) {
            [MusicPlayer play];
        } else {
            [MusicPlayer pause];
        }
    });
    self.playBtn = playBtn;
    
    UIButton *nextBtn = Button.img(@"btn_next_normal").onClick(^{
        [MusicPlayer next];
    });
    
    HorStack(NERSpring, preBtn, @(30), playBtn, @(30), nextBtn, NERSpring).embedIn(self.view, NERNull, 0, 100, 0);
    
}


#pragma mark - notification
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerStatusDidChangedNotification:) name:MOMusicPlayerStatusDidChangedNotification object:nil];
}

- (void)teardownNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)musicPlayerStatusDidChangedNotification:(NSNotification *)notification {
    MOMusicPlayerStatus status = [notification.userInfo[kMusicPlayerStatus] intValue];
    [self refreshUIWithPlayerStatus:status];
}

- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status {
    self.playBtn.selected = status == MOMusicPlayerStatusPlaying;
}



- (void)dealloc {
    [self teardownNotification];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
