//
//  ViewController.m
//  ButtonAlignmentDemo
//
//  Created by Xian Mo on 2020/8/23.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "UIButton+Alignment.h"
#import "UIButton+AttStrAlignment.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UIButton+Alignment
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"phone" forState:UIControlStateNormal];
    [btn1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"icon1"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
    }];
    // 在布局完之后调用
    [btn1 alignment_TopToBottom];
    [btn1 alignment_gap:20];
    
    
    // UIButton+AttStrAlignment.h
    UIImage *image = [UIImage imageNamed:@"icon2"];
    UIButton *btn2 = [UIButton buttonWithTitle:@"umbrella"
                               titleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20],
                                                 NSForegroundColorAttributeName: UIColor.blackColor}
                                         image:image
                                     imageSize:CGSizeMake(image.size.width *0.8, image.size.height *0.8)
                                       lineGap:20];
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(100);
    }];    
}


@end
