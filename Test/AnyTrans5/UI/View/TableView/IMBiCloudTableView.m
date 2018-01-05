//
//  IMBiCloudTableView.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBiCloudTableView.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCustomCornerView.h"
#import "IMBiCloudTableCell.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBiCloudTableView
@synthesize isSelectAll = _isSelectAll;
@synthesize mouseDelegate = _mouseDelegate;
@synthesize checkBoxCell = _checkBoxCell;
@synthesize dataAry = _dataAry;
#define CELL_HEADER_HEIGHT 28
#define CELL_HEADER_WIDTH 34
- (void)_setupHeaderCell
{
    NSTableHeaderView* tableHeaderView = [self headerView];
    [tableHeaderView setFrameSize:NSMakeSize(tableHeaderView.frame.size.width, CELL_HEADER_HEIGHT)];
    
    for (NSTableColumn* column in [self tableColumns]) {
		NSTableHeaderCell* cell = [column headerCell];
		NSTableHeaderCell* newCell ;
        if ([column.identifier isEqualToString:@"CheckCol"]) {
            IMBCheckHeaderCell *checkCell = [[IMBCheckHeaderCell alloc] initWithCell:cell];
            newCell = checkCell;
        } else {
            //从Localized文件中取出title等控件。
            NSString *newTitleKey = [NSString stringWithFormat:@"List_Header_id_%@",column.identifier];
            NSString *newTitle = CustomLocalizedString(newTitleKey, nil);
            if (![cell.stringValue isEqualToString:newTitle]) {
                cell.stringValue = CustomLocalizedString(newTitleKey, nil);
            }
            newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
        }
        [column setHeaderCell:newCell];
        if ([newCell isKindOfClass:[IMBCheckHeaderCell class]]) {
            _checkBoxCell = [(IMBCheckHeaderCell *)newCell retain];
            [_checkBoxCell.checkButton setTarget:self];
            [_checkBoxCell.checkButton setShouldNotChangeState:YES];
            [_checkBoxCell.checkButton setAction:@selector(doSelectAll:)];
        }
        
		[newCell release];
	}
}

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	if (_trackingArea)
	{
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSTableColumn* column in [self tableColumns]) {
            NSTableHeaderCell* cell = [column headerCell];
            NSTableHeaderCell* newCell ;
            if ([column.identifier isEqualToString:@"CheckCol"]) {
                IMBCheckHeaderCell *checkCell = [[IMBCheckHeaderCell alloc] initWithCell:cell];
                newCell = checkCell;
            } else {
                //从Localized文件中取出title等控件。
                NSString *newTitleKey = [NSString stringWithFormat:@"List_Header_id_%@",column.identifier];
                NSString *newTitle = CustomLocalizedString(newTitleKey, nil);
                if (![cell.stringValue isEqualToString:newTitle]) {
                    cell.stringValue = CustomLocalizedString(newTitleKey, nil);
                }
                if ([column.identifier isEqualToString:@"headCell"] || [column.identifier isEqualToString:@"Btn"]) {
                    [cell setStringValue:@""];
                }
                newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
            }
            [column setHeaderCell:newCell];
            if ([newCell isKindOfClass:[IMBCheckHeaderCell class]]) {
                _checkBoxCell = [(IMBCheckHeaderCell *)newCell retain];
                [_checkBoxCell.checkButton setTarget:self];
                [_checkBoxCell.checkButton setShouldNotChangeState:YES];
                [_checkBoxCell.checkButton setAction:@selector(doSelectAll:)];
            }
            
            [newCell release];
        }
    });
    
}

- (void)changeSkin:(NSNotification *)notification
{
    [self setNeedsDisplay:YES];
    if (_alternatingEvenRowBackgroundColor != nil) {
        [_alternatingEvenRowBackgroundColor release];
        _alternatingEvenRowBackgroundColor = nil;
    }
    if (_alternatingOddRowBackgroundColor != nil) {
        [_alternatingOddRowBackgroundColor release];
        _alternatingOddRowBackgroundColor = nil;
    }
    _alternatingEvenRowBackgroundColor = [[StringHelper getColorFromString:CustomColor(@"tableView_evenBgColor", nil)] retain];
    _alternatingOddRowBackgroundColor = [[StringHelper getColorFromString:CustomColor(@"tableView_oddBgColor", nil)] retain];
//    [self _setupHeaderCell];
    [self _setupCornerView];
    
    
    NSTableHeaderView* tableHeaderView = [self headerView];
    [tableHeaderView setFrameSize:NSMakeSize(tableHeaderView.frame.size.width, CELL_HEADER_HEIGHT)];
    
    for (NSTableColumn* column in [self tableColumns]) {
		NSTableHeaderCell* cell = [column headerCell];
		NSTableHeaderCell* newCell ;
        if ([column.identifier isEqualToString:@"CheckCol"]) {
            IMBCheckHeaderCell *checkCell = [[IMBCheckHeaderCell alloc] initWithCell:cell];
            newCell = checkCell;
        } else {
            //从Localized文件中取出title等控件。
            NSString *newTitleKey = [NSString stringWithFormat:@"List_Header_id_%@",column.identifier];
            NSString *newTitle = CustomLocalizedString(newTitleKey, nil);
            if (![cell.stringValue isEqualToString:newTitle]) {
                if ([column.identifier isEqualToString:@"headCell"] || [column.identifier isEqualToString:@"Btn"]) {
                    [cell setStringValue:@""];
                }else{
                    cell.stringValue = CustomLocalizedString(newTitleKey, nil);
                }
            }
            newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
        }
        [column setHeaderCell:newCell];
        if ([newCell isKindOfClass:[IMBCheckHeaderCell class]]) {
            _checkBoxCell = [(IMBCheckHeaderCell *)newCell retain];
            [_checkBoxCell.checkButton setTarget:self];
            [_checkBoxCell.checkButton setShouldNotChangeState:YES];
            [_checkBoxCell.checkButton setAction:@selector(doSelectAll:)];
        }
        for (NSTableColumn *tableColumn in [self tableColumns]) {
            NSTextFieldCell *fieldCell = (NSTextFieldCell *)tableColumn.dataCell;
            if ([fieldCell isKindOfClass:[IMBCenterTextFieldCell class]]) {
                [((IMBCenterTextFieldCell *)fieldCell) setTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                [((IMBCenterTextFieldCell *)fieldCell) setHilightTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
            }
        }
		[newCell release];
	}
	
    

}


- (void)dealloc{
    if (_checkBoxCell != nil) {
        [_checkBoxCell release];
        _checkBoxCell = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [_alternatingEvenRowBackgroundColor release],_alternatingEvenRowBackgroundColor = nil;
    [_alternatingOddRowBackgroundColor release],_alternatingOddRowBackgroundColor = nil;
    [super dealloc];
}

- (void)_setupCornerView
{
	NSView* cornerView = [self cornerView];
	IMBCustomCornerView* newCornerView = [[IMBCustomCornerView alloc] initWithFrame:cornerView.frame];
	[self setCornerView:newCornerView];
	[newCornerView release];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
        _isSelectAll = NO;
        curRow = -1;
		[self _setupHeaderCell];
		[self _setupCornerView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        
        _alternatingEvenRowBackgroundColor = [[StringHelper getColorFromString:CustomColor(@"tableView_evenBgColor", nil)] retain];
        _alternatingOddRowBackgroundColor = [[StringHelper getColorFromString:CustomColor(@"tableView_oddBgColor", nil)] retain];
	}
	return self;
}

- (void)awakeFromNib {
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
    NSTrackingAreaOptions trackingOptions = NSTrackingActiveInActiveApp | NSTrackingMouseMoved;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    // note: NSTrackingActiveAlways flags turns off the cursor updating feature
    NSTrackingArea * myTrackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:trackingOptions owner:self userInfo:nil];
    [self addTrackingArea: myTrackingArea];
}

- (void) doSelectAll:(id)sender {
    IMBCheckButton *btn = _checkBoxCell.checkButton;
    [btn setAllowsMixedState:NO];
    //    [btn setShouldNotChangeState:YES];
    NSLog(@"delegate:%@",self.delegate);
    if (btn.state == true) {
//        if ([self.delegate respondsToSelector:@selector(selectAll)]) {
//            [self selectAll:nil];
//        }
    } else {
//        if ([self.delegate respondsToSelector:@selector(deselectAll)]) {
//            [self deselectAll:nil];
//        }
    }
}


- (void) uncheckAllButton {
    for (NSTableColumn* column in [self tableColumns]) {
		NSTableHeaderCell* cell = [column headerCell];
		if ([column.identifier isEqualToString:@"CheckCol"]) {
            IMBCheckHeaderCell *checkCell = (IMBCheckHeaderCell*)cell;
            [checkCell.checkButton setState:FALSE];
            break;
        }
	}
}

- (void)selectRowIndexes:(NSIndexSet *)indexes {
    [super selectRowIndexes:indexes byExtendingSelection:NO];
}

- (void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend {
    
    [super selectRowIndexes:indexes byExtendingSelection:extend];
    
    int datasourceCount = 0;
    
//    if ([self.delegate respondsToSelector:@selector(getDatasourceCount)]) {
//        datasourceCount = [self.delegate getDatasourceCount];
//    }
//    if ([self.delegate respondsToSelector:@selector(changeCheckState)]) {
        //       [self.delegate changeCheckState];
//    }
    if (datasourceCount != 0 && indexes.count == datasourceCount && _checkBoxCell.checkButton.state == NSOnState){
        return;
    }
//    if ([self.delegate respondsToSelector:@selector(changeAllCheckStatus)]) {
        //        [self.delegate changeAllCheckStatus];
//    }
}

- (void)selectAll:(id)sender {
    [_checkBoxCell.checkButton setState:NSOnState];
//    if ([self.delegate respondsToSelector:@selector(selectAll)]) {
//        [self.delegate selectAll];
//    }
    [super selectAll:sender];
}

- (void)deselectAll:(id)sender {
    [_checkBoxCell.checkButton setState:NSOffState];
//    if ([self.delegate respondsToSelector:@selector(deselectAll)]) {
//        [self.delegate deselectAll];
//    }
    [super deselectAll:sender];
}

- (void)changeAllCheckState:(NSInteger)state
{
    NSLog(@"checkbox allowMixtureState:%hhd",_checkBoxCell.checkButton.allowsMixedState);
    [_checkBoxCell.checkButton setState:state];
}

//- (id)_highlightColorForCell:(id)cell
//{

//    if([self selectionHighlightStyle] == 1)
//    {
//        return nil;
//    }
//    else
//    {
//        return [NSColor colorWithDeviceRed:87.0/255 green:159.0/255 blue:226.0/255 alpha:1.0];//_highlightBKColor;
//    }
//}

//- (id)_highlightColorForCell:(id)cell {
//    return nil;
//}


- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {
    if (!_isSelectAll) {
        NSColor* bgColor = Nil;
        if ([[self window] isMainWindow] && [[self window] isKeyWindow]) {
            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)];
        } else {
            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)];
        }
        
        NSIndexSet* selectedRowIndexes = [self selectedRowIndexes];
        if ([selectedRowIndexes containsIndex:row]) {
            [bgColor setFill];
            NSRectFill([self rectOfRow:row]);
        }
        
    }
    [super drawRow:row clipRect:clipRect];
}

- (void)drawBackgroundInClipRect:(NSRect)clipRect {
    
    NSRect rect = self.bounds;
    if (self.usesAlternatingRowBackgroundColors) {
        [super drawBackgroundInClipRect:clipRect];
        CGFloat height = rect.size.height;
        CGFloat rowheight = [self rowHeight];
        CGFloat width = rect.size.width;
        NSInteger rowCount = floor(height/rowheight);
        for (int i = 0; i<rowCount;i++) {
            NSRect rowRect = NSMakeRect(0, i*rowheight, width, rowheight);
            if (i%2==0) {
                [[NSColor clearColor] setFill];
                NSRectFill(rowRect);
                [_alternatingEvenRowBackgroundColor setFill];
                NSRectFill(rowRect);
            }else
            {
                [[NSColor clearColor] setFill];
                NSRectFill(rowRect);
                [_alternatingOddRowBackgroundColor  setFill];
                NSRectFill(rowRect);
            }
            
        }
        
        if (rowCount*rowheight<height) {
            NSRect rect = NSMakeRect(0, rowCount*rowheight, width, height-rowCount*rowheight);
            if (rowCount%2 == 0) {
                [_alternatingEvenRowBackgroundColor setFill];
            }else
            {
                [_alternatingOddRowBackgroundColor setFill];
            }
            NSRectFill(rect);
        }
    }else
    {
        [super drawBackgroundInClipRect:clipRect];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent {
//    [self setNeedsDisplay:YES];
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    long preRow = curRow;
    long row = [self rowAtPoint:point];
    int sizeColPos = (int)[self columnWithIdentifier:@"Btn"];
    if (curRow != row) {
        id fromBindingData = nil;
        if (preRow != -1) {
            id cell = [self preparedCellAtColumn:sizeColPos row:preRow];
            if ([cell isKindOfClass:[IMBiCloudTableCell class]]) {
                fromBindingData = ((IMBiCloudTableCell*)cell).bindingEntity;
//                [self setNeedsDisplay:YES];
            }
        }
        id toBindingData = nil;
        if (row != -1) {
            id cell = [self preparedCellAtColumn:sizeColPos row:row];
            if ([cell isKindOfClass:[IMBiCloudTableCell class]]) {
                toBindingData = ((IMBiCloudTableCell*)cell).bindingEntity;
//                [self setNeedsDisplay:YES];
            }
        }
        curRow = row;
        if (self.mouseDelegate != nil && [self.mouseDelegate respondsToSelector:@selector(changeFromBindingData:toBindingData:withControlView:)]) {
            [self.mouseDelegate changeFromBindingData:fromBindingData toBindingData:toBindingData withControlView:self];
        }
    }
//    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    long preRow = curRow;
    int sizeColPos = (int)[self columnWithIdentifier:@"Size"];
    id fromBindingData = nil;
    if (preRow != -1) {
        id cell = [self preparedCellAtColumn:sizeColPos row:preRow];
        if ([cell isKindOfClass:[IMBiCloudTableCell class]]) {
            fromBindingData = ((IMBiCloudTableCell*)cell).bindingEntity;
//            [self setNeedsDisplay:YES];
        }
        
    }
    curRow = -1;
    id toBindingData = nil;
    if (self.mouseDelegate != nil && [self.mouseDelegate respondsToSelector:@selector(changeFromBindingData:toBindingData:withControlView:)]) {
        [self.mouseDelegate changeFromBindingData:fromBindingData toBindingData:toBindingData withControlView:self];
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
//    if (_isSelectAll) {

        NSPoint aPoint =[self convertPoint:theEvent.locationInWindow fromView:nil];
        NSInteger row = [self rowAtPoint:aPoint];

        NSInteger colum = [self columnAtPoint:aPoint];
        NSRect rect = [self rectOfRow:row];
        BOOL inner = NSMouseInRect(aPoint, rect, [self isFlipped]);
        if (colum != 6 && inner) {
            if (_dataAry != nil && _dataAry.count != 0) {
                IMBiCloudBackupBindingEntity *selectEntity = [_dataAry objectAtIndex:row];
                if (selectEntity.loadType == iCloudDataComplete||selectEntity.loadType == iCloudDataDelete) {
                    if ([self.mouseDelegate respondsToSelector:@selector(clickTableViewRow:withRow:)]) {
                        [self.mouseDelegate clickTableViewRow:self withRow:(int)row];
                    }
                    [super mouseDown:theEvent];
                }
            }else{
                [super mouseDown:theEvent];
            }
        }else{
            
        }
//    }else {
    
//    }
}

- (void)scrollWheel:(NSEvent *)theEvent {
    [super scrollWheel:theEvent];
    [self mouseMoved:theEvent];
}

@end
