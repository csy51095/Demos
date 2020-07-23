//
//  MOMusicPlayerController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/19.
//  Copyright © 2020 Mo. All rights reserved.
//



#import "MOMusicPlayerController.h"

#import "MOMusicPanelSongView.h"
#import "MOMusicPanelLrcView.h"

@interface MOMusicPlayerController ()

@property (nonatomic, weak) UIImageView *backgroundImgView;

@property (nonatomic, weak) MOMusicPanelSongView *songView;
@property (nonatomic, weak) MOMusicPanelLrcView *lrcView;

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
    [self setupAction];
    [self setupNotification];
    [self refreshUIWithSong:MusicPlayer.currentSong];
    [self refreshUIWithPlayerStatus:MusicPlayer.status];
    [self refreshUIWithCurrentTime:MusicPlayer.currentTime totalTime:MusicPlayer.totalTime];
    
    // 若歌曲已经在播放，进入控制器立即 startRotation 是无效的，需要延迟调用
    // 原因：vc modal方式的动画 与 核心动画 内部有冲突
    if (MusicPlayer.status == MOMusicPlayerStatusPlaying) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.songView startRotation];
        });
    }
}

- (void)setupUI {
    
    // 背景 毛玻璃效果
    UIImageView *backgroundImgView = UIImageView.new.embedIn(self.view);
    backgroundImgView.userInteractionEnabled = YES;
    self.backgroundImgView = backgroundImgView;
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.embedIn(backgroundImgView);
    
    // 上方按钮
    UIButton *closeBtn = Button.str(@"关闭").color(Theme_TextColorString).fnt(20).fixWH(50, 50).onClick(^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }).touchInsets(-10,-10,-10,-10);
    
    UIButton *shareBtn = Button.str(@"分享").color(Theme_TextColorString).fnt(20).fixWH(50,50).onClick(^{
        
    }).touchInsets(-10,-10,-10,-10);
    
    Style(@"tagBtn").color(Theme_TextColorString).selectedColor(@"white").fnt(15);
    UIButton *songBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"歌曲"));
    UIButton *lrcBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"歌词"));
    
    NERStack *topStack = HorStack(@(20),closeBtn, NERSpring, songBtn,
                                  @(5),Label.str(@"|").color(Theme_TextColorString),@(5), lrcBtn,
                                  NERSpring, shareBtn,@(20));
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIView *contentView = View.addTo(scrollView).makeCons(^{
        make.edge.equal.superview.constants(0);
        make.height.equal.superview.constants(0);
        make.width.equal.superview.multipliers(2);
    });
    
    MOMusicPanelSongView *songView = [MOMusicPanelSongView new];
    songView.addTo(contentView).makeCons(^{
        make.top.left.bottom.equal.superview.constants(0);
        make.width.equal.constants(Screen.width);
    });
    self.songView = songView;
    
    MOMusicPanelLrcView *lrcView = [MOMusicPanelLrcView new];
    lrcView.addTo(contentView).makeCons(^{
        make.top.bottom.right.equal.superview.constants(0);
        make.left.equal.view(songView).right.constants(0);
    });
    self.lrcView = lrcView;
    
    VerStack(topStack,
             @(30), scrollView
             ).embedIn(effectView.contentView, 20, 0, 0, 0);
    
    scrollView.makeCons(^{
        make.width.equal.superview.constants(0);
    });
}

- (void)setupAction {
    _songView.playBtnDidClickedBlock = ^{
        if (MusicPlayer.status == MOMusicPlayerStatusPause) {
            [MusicPlayer play];
        } else {
            [MusicPlayer pause];
        }
    };
    
    _songView.preBtnDidClickedBlock = ^{
        [MusicPlayer previous];
    };
    
    _songView.nextBtnDidClickedBlock = ^{
        [MusicPlayer next];
    };

    _songView.sliderValueChangedBlock = ^(CGFloat value) {
        [MusicPlayer setCurrentTime: value *MusicPlayer.totalTime];
    };
    
    
    _lrcView.playBtnDidClickedBlock = ^{
        if (MusicPlayer.status == MOMusicPlayerStatusPause) {
            [MusicPlayer play];
        } else {
            [MusicPlayer pause];
        }
    };
}

#pragma mark - notification
- (void)setupNotification {
    [NotificationCenter addObserver:self selector:@selector(musicPlayerStatusDidChangedNotification:) name:MOMusicPlayerStatusDidChangedNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(musicPlayerCurrentSongDidChangedNotification:) name:MOMusicPlayerCurrentSongDidChangedNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(musicPlayerCurrentTimeDidChangedNotification:) name:MOMusicPlayerCurrentTimeDidChangedNotification object:nil];
    
    [NotificationCenter addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)teardownNotification {
    [NotificationCenter removeObserver:self];
}

- (void)musicPlayerStatusDidChangedNotification:(NSNotification *)notification {
    MOMusicPlayerStatus status = [notification.userInfo[kMusicPlayerStatus] intValue];
    [self refreshUIWithPlayerStatus:status];
}

- (void)musicPlayerCurrentSongDidChangedNotification:(NSNotification *)notification {
    MOSong *song = notification.userInfo[kMusicPlayerCurrentSong];
    [self refreshUIWithSong:song];
}

- (void)musicPlayerCurrentTimeDidChangedNotification:(NSNotification *)notification {
    NSTimeInterval currentTime = [notification.userInfo[kCurrentTime] doubleValue];
    NSTimeInterval totalTime = [notification.userInfo[kTotalTime] doubleValue];
    
    [self refreshUIWithCurrentTime:currentTime totalTime:totalTime];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.songView startRotation];
    });
}


- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status {
    [self.songView refreshUIWithPlayerStatus:status];
    [self.lrcView refreshUIWithPlayerStatus:status];
}


- (void)refreshUIWithSong:(MOSong *)song {
    UIImage *coverImage = [UIImage imageWithContentsOfFile:song.coverPath];
    _backgroundImgView.image = coverImage;
    [self.songView refreshUIWithSong:song];
    [self.lrcView refreshUIWithSong:song];
}

- (void)refreshUIWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    [self.songView refreshUIWithCurrentTime:currentTime totalTime:totalTime];
    [self.lrcView refreshUIWithCurrentTime:currentTime totalTime:totalTime];
}

- (void)dealloc {
    [self teardownNotification];
}

@end
