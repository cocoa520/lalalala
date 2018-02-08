//
//  IMBLrregularView.h
//  PhoneRescue
//
//  Created by iMobie on 4/6/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBLrregularView : NSView
{
    BOOL _isMainNavigationView;
    NSColor *_backGroudColor;
}
@property (nonatomic, retain) NSColor *backGroudColor;
@property (nonatomic, assign) BOOL isMainNavigationView;
@end
