//
//  IMBSecureTextFieldCell.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBSecureTextFieldCell : NSSecureTextFieldCell
{
    NSImageView *_loadingImg;
    CALayer *_loadLayer;
    BOOL _isEnterBtn;
    id _delegate;
    NSColor *_cursorColor;
}
@property (nonatomic,retain)NSColor *cursorColor;
@property (nonatomic,assign) id delegate;
@end
