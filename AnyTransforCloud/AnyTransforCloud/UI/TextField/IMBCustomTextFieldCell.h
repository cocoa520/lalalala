//
//  IMBCustomTextFieldCell.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/10/21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBCustomTextFieldCell : NSTextFieldCell
{
    NSColor *_cursorColor;
}
@property (nonatomic,retain)NSColor *cursorColor;

@end
