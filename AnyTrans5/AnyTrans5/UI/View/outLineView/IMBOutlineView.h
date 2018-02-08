//
//  IMBOutlineView.h
//  AnyTrans
//
//  Created by long on 16-7-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

@protocol OutlineViewSingleClick <NSObject>
- (void)outlineView:(NSOutlineView *)outlineView row:(NSInteger)index;
@end

#import <Cocoa/Cocoa.h>

@interface IMBOutlineView : NSOutlineView
{
    
    NSColor *_selectionHighlightColor;
    id<OutlineViewSingleClick> singleDelegate;
}
@property (nonatomic,retain)NSColor *selectionHighlightColor;
@property (nonatomic,assign)id<OutlineViewSingleClick> singleDelegate;
@end
