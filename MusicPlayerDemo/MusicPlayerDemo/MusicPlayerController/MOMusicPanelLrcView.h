//
//  MOMusicPanelLrcView.h
//  MusicPlayerDemo
//
//  Created by Xian Mo on 2020/7/21.
//  Copyright © 2020 Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOMusicPanelLrcView : UIView

@property (nonatomic, copy) void(^playBtnDidClickedBlock)(void);
@end

NS_ASSUME_NONNULL_END
