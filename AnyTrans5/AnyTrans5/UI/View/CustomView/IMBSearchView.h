//
//  IMBSearchView.h
//  AnyTrans
//
//  Created by m on 17/8/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HoverButton.h"
#import "IMBCommonEnum.h"
@class IMBSearchTextField;
@interface IMBSearchView : NSView
{
    id		_target;
    SEL		_action;
    
    IMBSearchTextField *_searchField;
    HoverButton *_closeBtn;
    NSString *_stringValue;
    NSTrackingArea *_trackingArea;
    NSColor *_backGroundColor;
    BOOL _isOPen;//是否展开
    MouseStatusEnum _mouseState;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, retain) NSSearchField *searchField;
@property (nonatomic, retain) HoverButton *closeBtn;
@property (nonatomic, retain) NSString *stringValue;
@property (nonatomic, retain) NSColor *backGroundColor;
@property (nonatomic, assign) BOOL isOpen;

@end


@interface IMBSearchTextField : NSSearchField

@end
//
//@interface IMBSearchTextFieldCell : NSTextFieldCell
//
//@end