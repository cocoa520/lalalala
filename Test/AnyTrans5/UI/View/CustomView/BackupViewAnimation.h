//
//  BackupViewAnimation.h
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-10.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BackupViewAnimation : NSView
{
    CALayer *_bglayer;
    CALayer *_boxlayer;
    CALayer *_itemBglayer;
    CALayer *_booklayer;
    CALayer *_cameralayer;
    CALayer *_contactlayer;
    CALayer *_messagelayer;
    CALayer *_musiclayer;
    CALayer *_playlistlayer;
}
- (void)startAnimation;
- (void)stopAnimation;
@end
