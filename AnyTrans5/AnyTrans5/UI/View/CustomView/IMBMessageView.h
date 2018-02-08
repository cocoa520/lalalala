//
//  IMBMessageView.h
//  DataRecovery
//
//  Created by iMobie on 6/3/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBMessageView : NSView {
    NSColor *_backgroundColor;
    BOOL _isMMS;
}
@property (assign,nonatomic) BOOL isMMS;
- (void)setBackgroundColor:(NSColor *)backgroundColor;

@end
