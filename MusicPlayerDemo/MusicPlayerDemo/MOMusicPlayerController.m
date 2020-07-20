//
//  MOMusicPlayerController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/19.
//  Copyright © 2020 Mo. All rights reserved.
//

#define kAnimationKey   @"Rotation"


#import "MOMusicPlayerController.h"
#import "MOMusicPlayer.h"
#import "CALayer+AnimationPause.h"

@interface MOMusicPlayerController ()

@property (nonatomic, weak) UIImageView *coverImgView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *singerLab;
//@property (nonatomic, weak) UILabel *lrcLab;
@property (nonatomic, weak) UIButton *playBtn;

@property (nonatomic, weak) UILabel *currentTimeLab;
@property (nonatomic, weak) UILabel *totalTimeLab;
@property (nonatomic, weak) UISlider *slider;

@property (nonatomic, weak) UIImageView *backgroundImgView;

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
    [self refreshUIWithSong:MusicPlayer.currentSong];
    [self refreshUIWithPlayerStatus:MusicPlayer.status];
    
    // 若歌曲已经在播放，进入控制器立即 startRotation 是无效的，需要延迟调用
    // 原因：vc modal方式的动画 与 核心动画 内部有冲突
    if (MusicPlayer.status == MOMusicPlayerStatusPlaying) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startRotation];
        });
    }
}

- (void)setupUI {
    
    UIButton *closeBtn = Button.str(@"关闭").color(Theme_TextColorString).fnt(20).fixWH(50, 50).onClick(^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }).touchInsets(-10,-10,-10,-10);
    
    UIButton *shareBtn = Button.str(@"分享").color(Theme_TextColorString).fnt(20).fixWH(50,50).onClick(^{
        
    }).touchInsets(-10,-10,-10,-10);
    
    Style(@"tagBtn").color(Theme_TextColorString).selectedColor(@"white").fnt(15);
    UIButton *recommandBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"推荐"));
    UIButton *songBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"歌曲"));
    UIButton *lrcBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"歌词"));
    
    NERStack *topStack = HorStack(closeBtn, NERSpring, recommandBtn,
                                  @(5),Label.str(@"|").color(Theme_TextColorString),@(5), songBtn,
                                  @(5),Label.str(@"|").color(Theme_TextColorString),@(5), lrcBtn,
                                  NERSpring, shareBtn);
    
    UIImageView *coverImgView = ImageView.fixWH(250, 250).img(@"white").borderRadius(125);
    self.coverImgView = coverImgView;
    
    UILabel *titleLab = Label.color(@"white").fnt(20);
    self.titleLab = titleLab;
    
    UILabel *singerLab = Label.color(@"white").fnt(15);
    self.singerLab = singerLab;
    
    UISlider *slider = [[UISlider alloc] init];
    [slider setMinimumTrackTintColor:Theme_ButtonColor];
    [slider setThumbImage:Img(IMAGE(@"slider-block")) forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
    
    CGSize size = [@"00:00" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    UILabel *currentTimeLab = Label.fnt(14).str(@"00:00").fixWidth(size.width).color(@"white");
    UILabel *totalTimeLab = Label.fnt(14).str(@"00:00").fixWidth(size.width).color(@"white");
    self.currentTimeLab = currentTimeLab;
    self.totalTimeLab = totalTimeLab;
    
    NERStack *sliderStack = HorStack(currentTimeLab, @(10), slider, @(10), totalTimeLab);
    
    UIButton *preBtn = Button.img(IMAGE(@"btn_pre_normal")).onClick(^{
        [MusicPlayer previous];
    });
    
    UIButton *playBtn = Button.img(IMAGE(@"btn_play_normal")).selectedImg(IMAGE(@"btn_pause_normal")).onClick(^{
        if (MusicPlayer.status == MOMusicPlayerStatusPause) {
            [MusicPlayer play];
        } else {
            [MusicPlayer pause];
        }
    });
    self.playBtn = playBtn;
    
    UIButton *nextBtn = Button.img(IMAGE(@"btn_next_normal")).onClick(^{
        [MusicPlayer next];
    });
    
    NERStack *bottomStack = HorStack(NERSpring, preBtn, @(30), playBtn, @(30), nextBtn, NERSpring);
    
    UIImageView *backgroundImgView = UIImageView.new.embedIn(self.view);
    backgroundImgView.userInteractionEnabled = YES;
    self.backgroundImgView = backgroundImgView;
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.embedIn(backgroundImgView);
    
    VerStack(topStack,
             @(30),
             HorStack(NERSpring,coverImgView,NERSpring).centerAlignment,
             @(30),
             titleLab, @(15),
             singerLab,@(20),
             sliderStack, @(20), bottomStack).embedIn(effectView.contentView, 20, 20, 40, 20);
}

#pragma mark - target
- (void)sliderValueDidChanged:(UISlider *)slider {
    [MusicPlayer setCurrentTime: slider.value *MusicPlayer.totalTime];
}

#pragma mark - animation
- (void)startRotation {
    CALayer *layer = self.coverImgView.layer;
    CABasicAnimation *animation = [layer animationForKey:kAnimationKey];
    
    // pasue
    if (animation && layer.speed == 0) {
        [layer resumeAnimation];
        return;
    }
    
    //new、pre、next
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI *2);
    animation.duration = 20;
    animation.repeatCount = CGFLOAT_MAX;
    [layer addAnimation:animation forKey:kAnimationKey];
}

- (void)stopRotation {
    CAAnimation *animation = [self.coverImgView.layer animationForKey:kAnimationKey];
    if (animation) {
        [self.coverImgView.layer pauseAnimation];
    }
}

#pragma mark - notification
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerStatusDidChangedNotification:) name:MOMusicPlayerStatusDidChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerCurrentSongDidChangedNotification:) name:MOMusicPlayerCurrentSongDidChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerCurrentTimeDidChangedNotification:) name:MOMusicPlayerCurrentTimeDidChangedNotification object:nil];
}

- (void)teardownNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    NSDateFormatter *formatter = NSDateFormatter.new;
    formatter.dateFormat = @"mm:ss";
    
    self.currentTimeLab.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    self.totalTimeLab.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:totalTime]];
    self.slider.value = currentTime / totalTime;
}

- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status {
    self.playBtn.selected = status == MOMusicPlayerStatusPlaying;
    if (status == MOMusicPlayerStatusPlaying) {
        // 若歌曲已经在播放，进入控制器立即 startRotation 是无效的
        // 原因：vc modal方式的动画 与 核心动画 内部有冲突
        [self startRotation];
    } else {
        [self stopRotation];
    }
}


- (void)refreshUIWithSong:(MOSong *)song {
    UIImage *coverImage = [UIImage imageWithContentsOfFile:song.coverPath];
    _backgroundImgView.image = coverImage;
    _coverImgView.image = coverImage;
    _titleLab.text = song.name;
    _singerLab.text = song.singer;
}

- (void)dealloc {
    [self.coverImgView.layer removeAllAnimations];
    [self teardownNotification];
}

@end
