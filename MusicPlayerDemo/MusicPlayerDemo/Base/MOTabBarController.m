//
//  MOTabBarController.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/19.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOTabBarController.h"
#import "MONaviController.h"

#import "MOPlayListManager.h"
#import "MOPlayList.h"
#import "MOMusicPlayer.h"

#import "MOMusicPlayerController.h"

@interface MOTabBarController ()

@end

@implementation MOTabBarController

- (instancetype)init {
    if (self = [super init]) {
        [self setupAppearance];
        [self setupChildVC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MOPlayList *playList = [MOPlayListManager sharedInstance].allPlayLists.firstObject;
    MusicPlayer.songs = playList.allSongs;
    
    [self setupTestUI];
}

- (void)setupAppearance {
    self.tabBar.tintColor = Color(@"#3CB371");
    
    self.tabBar.translucent = NO;
    self.tabBar.shadowImage = UIImage.new;
    self.tabBar.backgroundImage = UIImage.new;
}


- (void)setupChildVC {
    NSArray *classNames = @[@"MOHomePageController",
                            @"MOBaseViewController",
                            @"MOBaseViewController",
                            @"MOBaseViewController"];
    NSArray *vcImageNames = @[@"tabBar_Music",
                              @"tabBar_Video",
                              @"tabBar_Putong",
                              @"tabBar_Me"];
    
    NSMutableArray *array = NSMutableArray.array;
    for (int i = 0; i < classNames.count; i++) {
        [array addObject:[self naviWithClass:NSClassFromString(classNames[i]) icon:vcImageNames[i]]];
    }
    [self setViewControllers:array.copy];
}


- (UINavigationController *)naviWithClass:(Class)className icon:(NSString *)imageName {
    UINavigationController *navi = [[MONaviController alloc] initWithRootViewController: [[className alloc] init]];
    navi.tabBarItem.title = [imageName substringFromIndex:7];
    navi.tabBarItem.image = Img(imageName);
    return navi;
}


- (void)setupTestUI {
    Style(@"btn").fnt(16).color(@"blue").fitSize;
    
    UIButton *preBtn = Button.str(@"Pre").styles(@"btn").onClick(^{
        [MusicPlayer previous];
    }).touchInsets(-10,-10,-10,-10);
    
    UIButton *playBtn = Button.str(@"Play").styles(@"btn").onClick(^{
        [MusicPlayer play];
    }).touchInsets(-10,-10,-10,-10);
    
    UIButton *nextBtn = Button.str(@"Next").styles(@"btn").onClick(^{
        [MusicPlayer next];
    }).touchInsets(-20,-20,-20,-20);
    
    UIView *musicBar = View.bgColor(@"gray").fixHeight(50).embedIn(self.view, NERNull, 20, 54, 20).onClick(^{
        
    });
    
    HorStack(NERSpring, preBtn, @(50), playBtn, @(50), nextBtn, NERSpring).embedIn(musicBar).centerAlignment;
}


@end
