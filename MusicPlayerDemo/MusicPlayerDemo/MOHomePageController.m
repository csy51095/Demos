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

@interface MOHomePageController ()

@end

@implementation MOHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MOPlayList *playList = [MOPlayListManager sharedInstance].allPlayLists.firstObject;
    
    MusicPlayer.songs = playList.allSongs;
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
