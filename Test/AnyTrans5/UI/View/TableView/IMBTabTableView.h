//
//  IMBTabTableView.h
//  iMobieTrans
//
//  Created by iMobie on 14-6-12.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBTabTableView : NSTableView
{
    NSColor *_selectionHighlightColor;
    NSImage *_backgroundimage;
    BOOL    _rightBorder;
}

@property (nonatomic,retain)NSColor *selectionHighlightColor;
@property (nonatomic,retain)NSImage *backgroundimage;
@property (nonatomic,assign)BOOL rightBorder;
@end
