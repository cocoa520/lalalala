//
//  IMBSecureTextFieldCell.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDrawOneImageBtn.h"
@interface IMBSecureTextFieldCell : NSSecureTextFieldCell
{
    IMBDrawOneImageBtn *_logBtn;
    NSImageView *_loadingImg;
    CALayer *_loadLayer;
    BOOL _isEnterBtn;
    BOOL _isHasLogBtn;
    id _delegate;
    NSColor *_cursorColor;
}
@property (nonatomic,retain)NSColor *cursorColor;
@property (nonatomic,assign) id delegate;
@property (nonatomic, assign) BOOL isHasLogBtn;
@property (nonatomic, retain) IMBDrawOneImageBtn *logBtn;
@end
