//
//  IMBRefreshLoadingVIew.m
//  iMobieTrans
//
//  Created by iMobie on 14-8-8.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBRefreshLoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
@implementation IMBRefreshLoadingView
@synthesize needTimer = needTimer;
@synthesize loadingType = loadingType;
- (id)initWithFrame:(NSRect)frame needTimer:(BOOL)needtimer
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        count = 0;
        needTimer = needtimer;
        [self initsubViews];
        
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame needTimer:(BOOL)needtimer LoadingType:(LoadingType)_loadingType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        count = 0;
        needTimer = needtimer;
        loadingType = _loadingType;
        [self initsubViews];
        
    }
    return self;
}


- (void)initsubViews
{
    //92*92 190*368 45
    //[self setWantsLayer:YES];
    loadingImageView = [[NSImageView alloc] initWithFrame:NSMakeRect((self.frame.size.width - 92)/2.0+42,(self.frame.size.height - 92 - 45)/2.0+88 , 92, 92)];
    loadingText = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 25,self.frame.size.width , 20)];
    [loadingImageView setImageFrameStyle:NSImageFrameNone];
    [loadingImageView setImage:[StringHelper imageNamed:@"refresh_loading"]];
    [loadingText setEditable:NO];
    [loadingText setBordered:NO];
    [loadingText setDrawsBackground:NO];
    [loadingText setAlignment:NSCenterTextAlignment];
    [loadingText setFont:[NSFont fontWithName:@"Helvetica Neue" size:16.0]];
    [loadingText setTextColor:[NSColor colorWithCalibratedRed:111.0/255 green:205.0/255 blue:244.0/255 alpha:1.0]];
    [self changeTipText];
    [loadingImageView setWantsLayer:YES];
    if (needTimer) {
        [loadingImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5/60 target:self selector:@selector(rotation) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }else
    {
        [loadingImageView setFrame:NSMakeRect((self.frame.size.width - 92)/2.0,(self.frame.size.height - 92)/2.0+20, 92, 92)];
        [loadingImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.duration = 0.5;
        animation.repeatCount = NSIntegerMax;
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue =[NSNumber numberWithFloat:-2*pi];
        [loadingImageView.layer addAnimation:animation forKey:@"xuan"];
       
    }
    [self addSubview:loadingImageView];
    [self addSubview:loadingText];
    [loadingText release];
    [loadingImageView release];
    
}

- (void)changeTipText
{
    [loadingImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    if (!needTimer) {
        [loadingImageView.layer removeAllAnimations];
        
        [loadingImageView setFrame:NSMakeRect((self.frame.size.width - 92)/2.0,(self.frame.size.height - 92)/2.0+20, 92, 92)];
        [loadingImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.duration = 0.5;
        animation.repeatCount = NSIntegerMax;
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue =[NSNumber numberWithFloat:-2*pi];
        [loadingImageView.layer addAnimation:animation forKey:@"xuan"];
        
        
    }
    if (loadingType == LoadingDelete) {
        [loadingText setStringValue:[NSString stringWithFormat:@"%@, %@...",CustomLocalizedString(@"Common_id_3", nil),[CustomLocalizedString(@"Common_id_5", nil) lowercaseString]]];
    }else if(loadingType == LoadingAddPlaylist)
    {
        [loadingText setStringValue:CustomLocalizedString(@"Playlist_id_9", nil)];
    }else if(loadingType == LoadingRefresh)
    {
        [loadingText setStringValue:CustomLocalizedString(@"MSG_Loading", nil)];
    }else if(loadingType == LoadingReName)
    {
        [loadingText setStringValue:CustomLocalizedString(@"MSG_Rename", nil)];
    }else if(loadingType == LoadingAddBookmark)
    {
        [loadingText setStringValue:[NSString stringWithFormat:@"%@...",CustomLocalizedString(@"Common_id_6", nil)]];
    }else if(loadingType == LoadingEditBookmark)
    {
        [loadingText setStringValue:[NSString stringWithFormat:@"%@...",CustomLocalizedString(@"Common_id_2", nil)]];
    }else if(loadingType == LoadingDeleteBookmark)
    {
        [loadingText setStringValue:[NSString stringWithFormat:@"%@...",CustomLocalizedString(@"Common_id_3", nil)]];
    }else {
        [loadingText setStringValue:CustomLocalizedString(@"MSG_Loading", nil)];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
}

- (void)rotation
{
    count++;
    float rotateAngle = - (6*count*M_PI)/180;
    [loadingImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [loadingImageView.layer setAffineTransform:CGAffineTransformMakeRotation(rotateAngle)];
    if (count == 60) {
        count = 0;
    }
}

- (void)killTimer
{
    if (timer != nil) {
        [timer invalidate]; timer = nil;
    }
}

- (void)dealloc
{
    [loadingImageView.layer removeAllAnimations];
    [super dealloc];
}

@end
