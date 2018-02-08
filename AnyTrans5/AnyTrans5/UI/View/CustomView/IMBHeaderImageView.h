//
//  IMBHeaderImageView.h
//  iMobieTrans
//
//  Created by iMobie on 14-11-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBHeaderImageView : NSView
{
    NSImage *_headerimage;
}
@property(nonatomic,retain)NSImage *headerimage;
@end
