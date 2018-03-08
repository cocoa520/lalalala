//
//  IMBCheckCell.h
//  MacClean
//
//  Created by LuoLei on 15-5-13.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface IMBCheckBoxCell : NSButtonCell
{
    NSImage *_onImage;
    NSImage *_onhigHlightImage;
    NSImage *_offImage;
    NSImage *_offhigHlightImage;
    NSImage *_mixedImage;
    NSImage *_mixedHighlightImage;
    BOOL _outlineCheck;
    BOOL _specifyCheck;
    BOOL _isEmpty;
    
    float CheckBoxWidth;
    float CheckBoxHeight;
    BOOL _isMessageCell;
    
    BOOL isoutlineviewcell;
    BOOL isSubNodeCell;
    BOOL isStatue;
    BOOL isHaveValue;

}
@property (nonatomic, retain) NSImage *onImage;
@property (nonatomic, retain) NSImage *offIMage;
@property (nonatomic, readwrite) BOOL outlineCheck;
@property (nonatomic, readwrite) BOOL specifyCheck;
@property (nonatomic, readwrite) BOOL isEmpty;
@property (nonatomic, assign) BOOL isMessageCell;
@property(nonatomic, readwrite) BOOL isoutlineviewcell;
@property(nonatomic, readwrite) BOOL isSubNodeCell;
@property(nonatomic, readwrite) BOOL isStatue;
@property(nonatomic, readwrite) BOOL isHaveValue;
@end
