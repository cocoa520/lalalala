//
//  IMBLinkButton.h
//  iMobieTrans
//
//  Created by Pallas on 9/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBLinkButton : NSButton {
@private
    NSTrackingArea *_trackingArea;
    NSColor *_textColor;
}

@property (nonatomic, readwrite, retain) NSColor *textColor;

@end
