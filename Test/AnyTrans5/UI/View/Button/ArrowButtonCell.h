//
//  ArrowButtonCell.h
//  PhoneClean3.0
//
//  Created by apple on 13-9-18.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class HoverButton;
@interface ArrowButtonCell : NSTextFieldCell
{
    NSImage *_defaultImage;
    NSImage *_enterImage;
    HoverButton *_btn;
}
@property (nonatomic, retain) NSImage *defaultImage;
@property (nonatomic, retain) NSImage *enterIMage;
@property (nonatomic, retain) HoverButton *btn;
@end
