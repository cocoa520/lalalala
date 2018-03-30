//
//  IMBMessageNameTextCell.h
//  iMobieTrans
//
//  Created by iMobie on 14-11-19.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBMessageNameTextCell : NSTextFieldCell
{
    NSFont *_titleFont;
    NSFont *_subTitleFont;
    NSColor *_titleColor;
    NSColor *_subTitleColor;
    BOOL _ishigh;
}
@property (nonatomic, assign) NSColor *subTitleColor;
@property (nonatomic, assign) NSColor *titleColor;
@property (nonatomic, assign) NSFont *titleFont;
@property (nonatomic, assign) NSFont *subTitleFont;
@property (nonatomic, assign) BOOL ishigh;
@end
