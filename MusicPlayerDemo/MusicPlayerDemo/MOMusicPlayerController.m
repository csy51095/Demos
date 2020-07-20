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

@property (nonatomic, weak) UIImageView *coverImgView;
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *singerLab;
//@property (nonatomic, weak) UILabel *lrcLab;
@property (nonatomic, weak) UIButton *playBtn;

@property (nonatomic, weak) UILabel *currentTimeLab;
@property (nonatomic, weak) UILabel *totalTimeLab;
@property (nonatomic, weak) UISlider *slider;

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
    [self refreshUIWithSong:MusicPlayer.currentSong];
}

- (void)setupUI {
    self.view.bgColor(@"0xF5DEB3");
    
    NSString *wordColorString = @"0xBC8F8F";
    
    UIButton *closeBtn = Button.str(@"关闭").color(wordColorString).fnt(20).fixWH(50, 50).onClick(^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }).touchInsets(-10,-10,-10,-10);
    
    UIButton *shareBtn = Button.str(@"分享").color(wordColorString).fnt(20).fixWH(50,50).onClick(^{
        
    }).touchInsets(-10,-10,-10,-10);
    
    Style(@"tagBtn").color(wordColorString).selectedColor(@"white").fnt(15);
    UIButton *recommandBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"推荐"));
    UIButton *songBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"歌曲"));
    UIButton *lrcBtn = Button.styles(@"tagBtn").str(LANGUAGE(@"歌词"));
    
    NERStack *topStack = HorStack(closeBtn, NERSpring, recommandBtn,
                                  @(5),Label.str(@"|").color(wordColorString),@(5), songBtn,
                                  @(5),Label.str(@"|").color(wordColorString),@(5), lrcBtn,
                                  NERSpring, shareBtn);
    
    UIImageView *coverImgView = ImageView.fixWH(100, 100).img(@"white").borderRadius(50);
    self.coverImgView = coverImgView;
    
    UILabel *titleLab = Label.color(@"white").fnt(20);
    self.titleLab = titleLab;
    
    UILabel *singerLab = Label.color(@"white").fnt(15);
    self.singerLab = singerLab;
    
    UISlider *slider = [[UISlider alloc] init];
    [slider setThumbImage:Img(IMAGE(@"slider-block")) forState:UIControlStateNormal];
    self.slider = slider;
    
    CGSize size = [@"00:00" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    UILabel *currentTimeLab = Label.fnt(14).fixWidth(size.width).color(@"white");
    UILabel *totalTimeLab = Label.fnt(14).fixWidth(size.width).color(@"white");
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
    
    VerStack(topStack, @(10), coverImgView, @(20), titleLab, @(20), singerLab,
             NERSpring, sliderStack, @(20), bottomStack).embedIn(self.view, 20, 20, 50, 20);
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
}


- (void)refreshUIWithSong:(MOSong *)song {
    _coverImgView.image = [UIImage imageWithContentsOfFile:song.coverPath];
    _titleLab.text = song.name;
    _singerLab.text = song.singer;
}

- (void)dealloc {
    [self teardownNotification];
}

@end
