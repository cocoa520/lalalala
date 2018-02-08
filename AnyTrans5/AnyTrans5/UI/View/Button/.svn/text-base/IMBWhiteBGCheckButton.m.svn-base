//
//  IMBWhiteBGCheckButton.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-12.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBWhiteBGCheckButton.h"
#import "StringHelper.h"

@implementation IMBWhiteBGCheckButton

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

- (void)setState:(NSInteger)value
{
    [super setState:value];
    if (value == NSOnState) {
        [self setImage:[StringHelper imageNamed:@"checkbox2"]];//box_select1
    }
    else if(value == NSOffState){
        [self setImage:[StringHelper imageNamed:@"checkbox1"]];//box_default1
    }
    else if(value == NSMixedState){
        [self setImage:[StringHelper imageNamed:@"checkbox3"]];//box_mix_select1
    }
    [self setNeedsDisplay:YES];
    [self setNeedsDisplay];
}

@end
