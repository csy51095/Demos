//
//  MOMusicPlayer.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#define MusicPlayer ([MOMusicPlayer sharedInstance])

#define kMusicPlayerStatus                          @"kMusicPlayerStatus"
#define MOMusicPlayerStatusDidChangedNotification   @"MOMusicPlayerStatusDidChangedNotification"


#import <Foundation/Foundation.h>
@class MOSong;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MOMusicPlayerStatus) {
    MOMusicPlayerStatusPlaying,
    MOMusicPlayerStatusPause,
};

@interface MOMusicPlayer : NSObject

INTERFACE_SINGLETON(MOMusicPlayer)

@property (nonatomic, copy) NSArray <MOSong *> *songs;
@property (nonatomic, copy) MOSong *currentSong;
@property (nonatomic, assign) MOMusicPlayerStatus status;

- (void)play;
- (void)pause;
- (void)previous;
- (void)next;

@end

NS_ASSUME_NONNULL_END
