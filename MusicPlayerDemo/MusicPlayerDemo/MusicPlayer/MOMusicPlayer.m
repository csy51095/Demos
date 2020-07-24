//
//  MOMusicPlayer.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOMusicPlayer.h"

#import <AVFoundation/AVFoundation.h>

@interface MOMusicPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) CADisplayLink *observerTimer;

@end

@implementation MOMusicPlayer

IMPLEMENTATION_SINGLETON(MOMusicPlayer)

- (instancetype)init {
    if (self = [super init]) {
        _audioPlayer = nil;
        _observerTimer = nil;
        self.status = MOMusicPlayerStatusPause;
        
        [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:NULL];
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
    
    /** 后台播放：
     1.cabability -> background Modes -> audio
     2.激活：AudioSession setActive -> YES
     3.设置后台播放种类: AudioSession setCategory -> AVAudioSessionCategoryPlayback
     */
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
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

#pragma mark - property
- (MOSong *)currentSong {
    if (!self.songs || self.selectedIndex >= self.songs.count) {
        return nil;
    }
    return [self.songs objectAtIndex:self.selectedIndex];
}

- (NSTimeInterval)totalTime {
    if (_audioPlayer) {
        return _audioPlayer.duration;
    }
    return 0.0;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (_audioPlayer) {
        [_audioPlayer setCurrentTime:currentTime];
    }
}

- (NSTimeInterval)currentTime {
    if (_audioPlayer) {
        return _audioPlayer.currentTime;
    }
    return 0.0;
}


#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        [NotificationCenter postNotificationName:MOMusicPlayerStatusDidChangedNotification
                                                            object:self
                                                          userInfo:@{kMusicPlayerStatus :@(self.status)}];
        if (self.status == MOMusicPlayerStatusPlaying) {
            [self startObserveCurrentTime];
        } else {
            [self stopObserveCurrentTime];
        }
        
    } else if ([keyPath isEqualToString:@"selectedIndex"]) {
        [NotificationCenter postNotificationName:MOMusicPlayerCurrentSongDidChangedNotification
                                                            object:self
                                                          userInfo:@{kMusicPlayerCurrentSong: self.currentSong}];
    }
}


#pragma mark - Timer
- (void)startObserveCurrentTime {
    [self stopObserveCurrentTime];
    _observerTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(observeProcess:)];
    [_observerTimer addToRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
}

- (void)stopObserveCurrentTime {
    if (_observerTimer) {
        if (![_observerTimer isPaused]) {
            [_observerTimer invalidate];
        }
        _observerTimer = nil;
    }
}

- (void)observeProcess:(CADisplayLink *)timer {
    [NotificationCenter postNotificationName:MOMusicPlayerCurrentTimeDidChangedNotification
                                                        object:self
                                                      userInfo:@{kCurrentTime: @(_audioPlayer.currentTime),
                                                                 kTotalTime: @(_audioPlayer.duration)}];
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self next];
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"status"];
    [self removeObserver:self forKeyPath:@"selectedIndex"];
    [NotificationCenter removeObserver:self];
}

@end
