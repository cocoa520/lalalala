//
//  IMBSerachFieldCell.h
//  AnyTrans
//
//  Created by LuoLei on 16-10-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBSearchFieldCell : NSSearchFieldCell
{
    NSColor *_searchBackgroundColor;
    NSColor *_cursorColor;
    NSColor *_searchBorderColor;
    NSImageView *imageView;
}
@property (nonatomic,retain)NSColor *searchBackgroundColor;
@property (nonatomic,retain)NSColor *cursorColor;
@property (nonatomic,retain)NSColor *searchBorderColor;

@end
