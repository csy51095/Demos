//
//  MOMusicPlayerController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/19.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOMusicPlayerController.h"

@implementation MOMusicPlayerController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
