//
//  IMBCheckBtn.h
//  iMobieTrans
//
//  Created by iMobie on 3/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBMyDrawCommonly.h"

@interface IMBCheckBtn :NSButton
{
    NSImage *_checkImg;
    NSImage *_unCheckImg;
    NSImage *_mixImg;
    BOOL _shouldNotChangeState;
    BOOL _isbackUpsettingBtn;
    BOOL _isDFUView;
    BOOL _isIosFixView;
    BOOL _isiOsFixMainView;
    BOOL _isMouseEnter;
    MouseStatusEnum _buttonType;
    NSTrackingArea *_trackingArea;
}
@property (assign) BOOL isIosFixView;
@property (assign) BOOL isDFUView;
@property (assign) BOOL isbackUpsettingBtn;
@property (readwrite,retain) NSImage *checkImg;
@property (readwrite,retain) NSImage *unCheckImg;
@property (readwrite,retain) NSImage *mixImg;
@property (assign) BOOL shouldNotChangeState;
@property (assign) BOOL isiOsFixMainView;
@property (assign) BOOL isMouseEnter;
- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg mixImg:(NSImage *)mixImg;
- (id)initWithCheckImg:(NSImage *)checkImg unCheckImg:(NSImage *)uncheckImg;
- (void)setCheckStateImage:(NSString *)btnName;

@end
