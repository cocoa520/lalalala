//
//  IMBiCloudDeleteButton.h
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBiCloudDeleteButton : NSButton{
    NSTrackingArea *trackingArea;
    NSImage *_mouseExitImage;
    NSImage *_mouseEnteredImage;
    NSImage *_mouseDownImage;
    NSImage *_mouseEnableImage;
    BOOL _isEnable;
}

@property (nonatomic,retain) NSImage *mouseExitImage;
@property (nonatomic,retain) NSImage *mouseEnteredImage;
@property (nonatomic,retain) NSImage *mouseDownImage;
@property (nonatomic,retain) NSImage *mouseEnableImage;
@property (nonatomic,assign) BOOL isEnable;

- (void) setImageWithWithPrefixImageName:(NSString*)prefixImageName;

@end
