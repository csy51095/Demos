//
//  MOMusicPlayer.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MOPlayList, MOSong;

NS_ASSUME_NONNULL_BEGIN

@interface MOMusicPlayer : NSObject

@property (nonatomic, weak) MOPlayList *playList;
@property (nonatomic, weak) MOSong *currentSong;

- (void)play;
- (void)pause;
- (void)previous;
- (void)next;

@end

NS_ASSUME_NONNULL_END
