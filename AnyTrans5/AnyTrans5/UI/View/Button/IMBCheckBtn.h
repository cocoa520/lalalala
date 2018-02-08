//
//  IMBCheckBtn.h
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBCheckBtn :NSButton
{
    NSImage *_checkImg;
    NSImage *_unCheckImg;
    NSImage *_mixImg;
    NSTrackingArea *_trackingArea;
    BOOL _shouldNotChangeState;
    BOOL _isDrawColor;
}

@property (readwrite,retain,nonatomic) NSImage *checkImg;
@property (readwrite,retain,nonatomic) NSImage *unCheckImg;
@property (readwrite,retain,nonatomic) NSImage *mixImg;
@property (strong) NSTrackingArea *trackingArea;
@property (assign) BOOL shouldNotChangeState;
@property (assign) BOOL isDrawColor;
- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg;
@end
