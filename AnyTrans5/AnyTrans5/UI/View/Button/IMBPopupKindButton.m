//
//  IMBPopupKindButton.m
//  TestMyOwn
//
//  Created by iMobie on 6/26/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBPopupKindButton.h"
#import "IMBPopupKindButtonCell.h"

@implementation IMBPopupKindButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        IMBPopupKindButtonCell *cell = [[IMBPopupKindButtonCell alloc] init];
        [self setCell:cell];
    }
    return self;
}

- (void)viewDidMoveToSuperview{
    [super viewDidMoveToSuperview];
    [self setPreferredEdge:NSMaxXEdge];
    [self setPullsDown:YES];
}

- (void)setImage:(NSImage *)image{
    [super setImage:image];
}

- (void)drawRect:(NSRect)dirtyRect
{
    IMBPopupKindButtonCell *cell = [self cell];
    [cell drawImageWithFrame:dirtyRect inView:self];

}

+ (Class)cellClass{
    return [IMBPopupKindButtonCell class];
}

@end
