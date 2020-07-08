//
//  MOMusicPlayer.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#define MusicPlayer ([MOMusicPlayer sharedInstance])

#import <Foundation/Foundation.h>
@class MOSong;

NS_ASSUME_NONNULL_BEGIN

@interface MOMusicPlayer : NSObject

INTERFACE_SINGLETON(MOMusicPlayer)

@property (nonatomic, weak) NSArray <MOSong *> *songs;
@property (nonatomic, weak) MOSong *currentSong;

- (void)play;
- (void)pause;
- (void)previous;
- (void)next;

@end

NS_ASSUME_NONNULL_END
