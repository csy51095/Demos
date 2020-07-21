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
@property (nonatomic, weak) UIButton *playBtn;
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
    
    [self setupNotification];
    [self setupMusicBar];
    [self refreshUIWithPlayerStatus:MusicPlayer.status];
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


- (void)setupMusicBar {
    Style(@"btn").fnt(16).color(@"#F5FFFA").fitSize;
    
    UIButton *preBtn = Button.str(LANGUAGE(@"Pre")).styles(@"btn").onClick(^{
        [MusicPlayer previous];
    }).touchInsets(-10,-10,-10,-10);
    
    
    CGSize size = [@"pause" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    UIButton *playBtn = Button.styles(@"btn").fixWidth(size.width).onClick(^{
        if (MusicPlayer.status == MOMusicPlayerStatusPause) {
            [MusicPlayer play];
        } else {
            [MusicPlayer pause];
        }
    }).touchInsets(-10,-10,-10,-10);
    self.playBtn = playBtn;
    
    UIButton *nextBtn = Button.str(LANGUAGE(@"Next")).styles(@"btn").onClick(^{
        [MusicPlayer next];
    }).touchInsets(-20,-20,-20,-20);
    
    UIView *musicBar = View.bgColor(@"#F5DEB3").borderRadius(25).fixHeight(50).embedIn(self.view, NERNull, 20, 54, 20).onClick(^{
        MOMusicPlayerController *vc = [MOMusicPlayerController new];
        [self presentViewController:vc animated:YES completion:nil];
    });
    
    HorStack(NERSpring, preBtn, @(50), playBtn, @(50), nextBtn, NERSpring).embedIn(musicBar).centerAlignment;
}


#pragma mark - notification
- (void)setupNotification {
    [NotificationCenter addObserver:self selector:@selector(musicPlayerStatusDidChangedNotification:) name:MOMusicPlayerStatusDidChangedNotification object:nil];
}

- (void)teardownNotification {
    [NotificationCenter removeObserver:self];
}

- (void)musicPlayerStatusDidChangedNotification:(NSNotification *)notification {
    MOMusicPlayerStatus status = [notification.userInfo[kMusicPlayerStatus] intValue];
    [self refreshUIWithPlayerStatus:status];
}

- (void)refreshUIWithPlayerStatus:(MOMusicPlayerStatus)status {
    self.playBtn.str(status == MOMusicPlayerStatusPlaying? LANGUAGE(@"pause"): LANGUAGE(@"play"));
}

- (void)dealloc {
    [self teardownNotification];
}


@end
