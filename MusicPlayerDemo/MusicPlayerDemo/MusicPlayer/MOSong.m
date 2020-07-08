//
//  MOSong.m
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/8.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "MOSong.h"

@implementation MOSong

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"coverPath": @"cover",
             @"mp3Path" : @"mp3",
             @"lrcPath" : @"lrc"};
}

@end
