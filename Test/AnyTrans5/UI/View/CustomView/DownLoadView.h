//
//  DownLoadView.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-22.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BadgeCountView;
@interface DownLoadView : NSView
{
    NSInteger _badgeCount;
    CALayer *_animationLayer;
    BadgeCountView *_badgeCountView;
    NSTrackingArea *_trackingArea;
    int _state;
    BOOL _isiCloudDownLoadView;
}
@property (nonatomic,assign)BOOL isiCloudDownLoadView;
@property (nonatomic,assign)NSInteger badgeCount;
- (NSInteger)setBadgeCountDecrease;
- (void)setEnable:(BOOL)enable;
- (void)addOBServer;
@end

@interface BadgeCountView : NSView
{
    NSInteger _badgeCount;
    BOOL _isiCloudDownLoadView;

}
@property (nonatomic,assign)BOOL isiCloudDownLoadView;
@property (nonatomic,assign)NSInteger badgeCount;
@end