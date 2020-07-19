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

@interface MOMusicPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MOMusicPlayer

IMPLEMENTATION_SINGLETON(MOMusicPlayer)

- (instancetype)init {
    if (self = [super init]) {
        _audioPlayer = nil;
        self.status = MOMusicPlayerStatusPause;
        
        [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
        
        
    }
    return self;
}

- (void)playAtIndex:(NSInteger)index {
    /**
     1.判空
     2.边界
     */
    if (!self.songs || self.songs.count == 0) {
        return;
    }
    
    /** play or pause */
    if (index == self.selectedIndex && _audioPlayer) {
        [_audioPlayer play];
        self.status = MOMusicPlayerStatusPlaying;
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
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
    self.selectedIndex = index;
    self.status = MOMusicPlayerStatusPlaying;
}

- (void)play {
    [self playAtIndex:self.selectedIndex];
}

- (void)pause {
    if (_audioPlayer) {
        [_audioPlayer pause];
        self.status = MOMusicPlayerStatusPause;
    }
}

- (void)previous {
    [self playAtIndex:self.selectedIndex -1];
}

- (void)next {
    [self playAtIndex:self.selectedIndex +1];
}


#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MOMusicPlayerStatusDidChangedNotification
                                                            object:self
                                                          userInfo:@{kMusicPlayerStatus :@(self.status)}];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self next];
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
