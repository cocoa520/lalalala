//
//  IMBiTunesSecureTextFieldCell.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-25.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDrawOneImageBtn.h"
@interface IMBiTunesSecureTextFieldCell : NSSecureTextFieldCell
{

//    NSImageView *_loadingImg;
    BOOL _isEnterBtn;
    BOOL _isHasLogBtn;
    NSColor *_cursorColor;
    CALayer *_loadingLayer;
}
@property (nonatomic, assign) BOOL isHasLogBtn;
@property (nonatomic,retain)NSColor *cursorColor;

@end
