//
//  MOMusicPanelLrcView.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOMusicPanelLrcView.h"
#import "MOLrcBlendLabel.h"

@interface MOMusicPanelLrcView ()

@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *singerLab;
@property (nonatomic, weak) UIButton *playBtn;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *containerView;
@end

@implementation MOMusicPanelLrcView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UILabel *titleLab = Label.color(@"white").fnt(22);
    self.titleLab = titleLab;
    
    UILabel *singerLab = Label.color(@"white").fnt(15);
    self.singerLab = singerLab;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView = scrollView;
    
    UIButton *playBtn = Button.img(IMAGE(@"btn_play_normal")).selectedImg(IMAGE(@"btn_pause_normal")).onClick(^{
        if (self.playBtnDidClickedBlock) {
            self.playBtnDidClickedBlock();
        }
    }).touchInsets(-10,-10,-10,-10).fixWH(30,30);
    self.playBtn = playBtn;
    
    VerStack(titleLab, @(10),
             singerLab, @(10),
             HorStack(scrollView),
             NERSpring,
             @(15),
             HorStack(NERSpring, playBtn)
             ).embedIn(self, 0,25,20, 25);
    
    UIView *containerView = View.embedIn(scrollView).makeCons(^{
        make.width.equal.superview.constants(0);
    });
    self.containerView = containerView;
}

- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status {
    self.playBtn.selected = status == MOMusicPlayerStatusPlaying;
}


- (void)refreshUIWithSong:(MOSong *)song {
    _titleLab.text = song.name;
    _singerLab.text = song.singer;
    [self createLrcPanelWithSong:song];
}


- (void)refreshUIWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    
    
}

- (void)createLrcPanelWithSong:(MOSong *)song {
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSMutableArray <MOLrcBlendLabel *> *labels = NSMutableArray.array;
    for (MOLrcLine *line in song.lrc.lines) {
        MOLrcBlendLabel *label = MOLrcBlendLabel.new;
        label.text  = line.lineText;
        label.font = [UIFont systemFontOfSize:15];
        
        [self.containerView addSubview: label];
        [labels addObject:label];
    }
    
    [labels enumerateObjectsUsingBlock:^(MOLrcBlendLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.makeCons(^{
                make.top.equal.superview.constants(30);
                make.left.equal.superview.constants(0);
            });
        } else {
            UILabel *prevLab = labels[idx-1];
            obj.makeCons(^{
                make.left.equal.superview.constants(0);
                make.top.equal.view(prevLab).bottom.constants(10);
            });
        }
    }];
    
    self.containerView.makeCons(^{
        make.bottom.equal.view(labels.lastObject).constants(20);
    });
}


@end
