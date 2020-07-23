//
//  MOMusicPanelLrcView.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOMusicPanelLrcView.h"

@interface MOMusicPanelLrcView ()

@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *singerLab;
@property (nonatomic, weak) UIButton *playBtn;
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
    
    UILabel *titleLab = Label.color(@"white").fnt(20);
    self.titleLab = titleLab;
    
    UILabel *singerLab = Label.color(@"white").fnt(15);
    self.singerLab = singerLab;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    
    UIButton *playBtn = Button.img(IMAGE(@"btn_play_normal")).selectedImg(IMAGE(@"btn_pause_normal")).onClick(^{
        if (self.playBtnDidClickedBlock) {
            self.playBtnDidClickedBlock();
        }
    }).fixWH(30,30);
    self.playBtn = playBtn;
    
    VerStack(titleLab, @(10),
             singerLab, @(10),
             HorStack(@(25), scrollView, @(25)),
             NERSpring,
             @(15),
             HorStack(NERSpring, playBtn, @(20)),
             @(20)).embedIn(self);
    
    UIView *containerView = View.embedIn(scrollView).makeCons(^{
        make.width.height.equal.superview.constants(0);
    });
    containerView.bgColor(WheatColor);
    self.containerView = containerView;
}


@end
