//
//  IMBBGColoerView.h
//  iMobieTrans
//
//  Created by zhang yang on 13-8-13.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBBGColoerView : NSView {
    NSColor *_background;
    BOOL    _isBorder;
    BOOL    _topBorder;
    BOOL    _bottomBorder;
    BOOL    _rightBorder;
    BOOL    _leftBorder;
}

@property (nonatomic, retain) NSColor *background;
@property (nonatomic, assign) BOOL isBorder;
@property (nonatomic, assign) BOOL topBorder;
@property (nonatomic, assign) BOOL bottomBorder;
@property (nonatomic, assign) BOOL rightBorder;
@property (nonatomic, assign) BOOL leftBorder;
@end

