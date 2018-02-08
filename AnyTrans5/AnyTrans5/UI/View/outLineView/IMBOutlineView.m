//
//  IMBOutlineView.m
//  AnyTrans
//
//  Created by long on 16-7-18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBOutlineView.h"
//#import "IMBColorDefine.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBImageAndTextCell.h"
#import "IMBCustomHeaderCell.h"
#define CELL_HEADER_HEIGHT 24
@implementation IMBOutlineView
@synthesize selectionHighlightColor = _selectionHighlightColor;
@synthesize singleDelegate = singleDelegate;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupHeaderCell];
    }
    return self;
}

- (void)setupHeaderCell{
    NSTableHeaderView *tableHeaderView = [self headerView];
    [tableHeaderView setFrameSize:NSMakeSize(tableHeaderView.frame.size.width, CELL_HEADER_HEIGHT)];
    
    for (NSTableColumn *column in [self tableColumns]) {
        NSTableHeaderCell *cell = [column headerCell];
        NSTableHeaderCell *newCell;
        NSString *newTitleKey = [NSString stringWithFormat:CustomLocalizedString(@"List_Header_id_%@", nil),column.identifier];
        NSString *newTitle = CustomLocalizedString(newTitleKey, nil);
        cell.stringValue = CustomLocalizedString(newTitle, nil);
        newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
        [column setHeaderCell:newCell];
        [newCell release];
    }
}


- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];

}

- (void)changeSkin:(NSNotification *)notification
{
    [self setSelectionHighlightColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
    for (NSTableColumn *tableColumn in [self tableColumns]) {
        NSTextFieldCell *fieldCell = (NSTextFieldCell *)tableColumn.dataCell;
        if ([fieldCell isKindOfClass:[IMBImageAndTextCell class]]) {
            [((IMBImageAndTextCell *)fieldCell) setTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [((IMBImageAndTextCell *)fieldCell) setHilightTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        }
    }

}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

//设置高亮颜色
- (id)_highlightColorForCell:(id)cell
{
        if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow])
        {
           return  _selectionHighlightColor;
        }else{
               return [StringHelper getColorFromString:CustomColor(@"tableView_select_LoseFocusColor", nil)];
        }
    
}

- (NSMenu*)menuForEvent:(NSEvent*)event

{
    [[self window] makeFirstResponder:self];
    NSPoint menuPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    
    NSInteger row = [self rowAtPoint:menuPoint];
    if (row >= 0)
    {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        
    }
    if (row < 0 )
    {
        return nil;
    }
    else
    {
        return self.menu;
    }
}

- (void)dealloc
{
    [_selectionHighlightColor release],_selectionHighlightColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    NSPoint aPoint =[self convertPoint:theEvent.locationInWindow fromView:nil];
    NSInteger row = [self rowAtPoint:aPoint];
    NSRect rect = [self frameOfOutlineCellAtRow:row];
    BOOL inner = NSMouseInRect(aPoint, rect, [self isFlipped]);
    if ([singleDelegate respondsToSelector:@selector(outlineView: row:)]&&!inner) {
        [singleDelegate outlineView:self row:row];
    }
}

@end
