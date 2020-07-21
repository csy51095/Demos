//
//  MOMusicPlayer.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#define MusicPlayer ([MOMusicPlayer sharedInstance])

/** 播放器状态改变 播放/暂停 */
#define kMusicPlayerStatus                              @"kMusicPlayerStatus"
#define MOMusicPlayerStatusDidChangedNotification       @"MOMusicPlayerStatusDidChangedNotification"

/** 歌曲变更 */
#define kMusicPlayerCurrentSong                         @"kMusicPlayerCurrentSong"
#define MOMusicPlayerCurrentSongDidChangedNotification  @"MOMusicPlayerCurrentSongDidChangedNotification"

/** 时间进度 */
#define kCurrentTime                                    @"kCurrentTime"
#define kTotalTime                                      @"kTotalTime"
#define MOMusicPlayerCurrentTimeDidChangedNotification  @"MOMusicPlayerCurrentTimeDidChangedNotification"



#import <Foundation/Foundation.h>
#import "MOSong.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MOMusicPlayerStatus) {
    MOMusicPlayerStatusPlaying,
    MOMusicPlayerStatusPause,
};

@interface MOMusicPlayer : NSObject

INTERFACE_SINGLETON(MOMusicPlayer)

@property (nonatomic, copy) NSArray <MOSong *> *songs;
@property (nonatomic, strong, readonly) MOSong *currentSong;
@property (nonatomic, assign) MOMusicPlayerStatus status;

@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;

- (void)play;
- (void)pause;
- (void)previous;
- (void)next;

@end

NS_ASSUME_NONNULL_END
