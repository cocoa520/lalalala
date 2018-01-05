//
//  IMBNoConnectView.m
//  AnyTrans
//
//  Created by iMobie on 8/28/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBNoConnectView.h"
#import "StringHelper.h"

@implementation IMBNoConnectView

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

- (void)awakeFromNib {
    [self setWantsLayer:YES];
    _bgLayer = [[CALayer layer] retain];
    [_bgLayer setAnchorPoint:CGPointMake(0, 0)];
    [_bgLayer setMasksToBounds:YES];
    [_bgLayer setFrame:NSRectToCGRect(self.bounds)];
    
    _bgimageLayer1 = [[CALayer layer] retain];
    [_bgimageLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_bgimageLayer1 setFrame:CGRectMake(0, 48, 1500, 200)];
    _bgimageLayer1.contents = [StringHelper imageNamed:@"car_animation_bg"];
    
    _bgimageLayer2 = [[CALayer layer] retain];
    [_bgimageLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_bgimageLayer2 setFrame:CGRectMake(1500, 48, 1500, 200)];
    _bgimageLayer2.contents = [StringHelper imageNamed:@"car_animation_bg"];
    
    _bgimageLayer3 = [[CALayer layer] retain];
    [_bgimageLayer3 setAnchorPoint:CGPointMake(0, 0)];
    [_bgimageLayer3 setFrame:CGRectMake(1500, 48, 1500, 200)];
    _bgimageLayer3.contents = [StringHelper imageNamed:@"car_animation_bg"];
}

@end
