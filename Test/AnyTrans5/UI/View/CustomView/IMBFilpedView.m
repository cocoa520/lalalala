//
//  IMBFilpedView.m
//  DataRecovery
//
//  Created by iMobie on 5/31/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBFilpedView.h"

@implementation IMBFilpedView
@synthesize smsData = _smsData;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (BOOL)isFlipped
{
    return YES;
}


@end
