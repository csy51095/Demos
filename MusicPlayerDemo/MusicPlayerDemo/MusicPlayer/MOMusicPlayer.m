//
//  MOMusicPlayer.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOMusicPlayer.h"
#import "MOSong.h"

#import <AVFoundation/AVFoundation.h>

@interface MOMusicPlayer ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MOMusicPlayer

IMPLEMENTATION_SINGLETON(MOMusicPlayer)

- (void)playAtIndex:(NSInteger)index {
    /**
     1.判空
     2.边界
     */
    if (!self.songs || self.selectedIndex >= self.songs.count) {
        return;
    }
    
    if (index < 0) {
        index = self.songs.count -1;
    }
    if (index >= self.songs.count) {
        index = 0;
    }
    
    MOSong *song = [_songs objectAtIndex:index];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:Url(song.mp3Path) error:nil];
    [self.audioPlayer play];
    
    self.selectedIndex = index;
}

- (void)play {
    [self playAtIndex:self.selectedIndex];
}

- (void)pause {
    if (_audioPlayer) {
        [_audioPlayer pause];
    }
}

- (void)previous {
    [self playAtIndex:self.selectedIndex -1];
}

- (void)next {
    [self playAtIndex:self.selectedIndex +1];
}

@end
