//
//  IMBWindowButton.h
//  iMobieTrans
//
//  Created by Pallas on 3/17/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBWindowButton : NSButton {
@private
    NSTrackingArea *_mouseTrackingArea;
    NSString *_groupIdentifier;
    NSImage *_activeImage;
    NSImage *_activeNotKeyWindowImage;
    NSImage *_inactiveImage;
    NSImage *_rolloverImage;
    NSImage *_pressedImage;
}

@property (nonatomic, copy, readonly) NSString *groupIdentifier;

@property (nonatomic, strong) NSImage *activeImage;

@property (nonatomic, strong) NSImage *activeNotKeyWindowImage;

@property (nonatomic, strong) NSImage *inactiveImage;

@property (nonatomic, strong) NSImage *rolloverImage;

@property (nonatomic, strong) NSImage *pressedImage;

+ (instancetype)windowButtonWithSize:(NSSize)size groupIdentifier:(NSString *)groupIdentifier;

- (instancetype)initWithSize:(NSSize)size groupIdentifier:(NSString *)groupIdentifier;

@end
