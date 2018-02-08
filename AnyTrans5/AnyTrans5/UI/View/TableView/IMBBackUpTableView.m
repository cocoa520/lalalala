//
//  IMBBackUpTableView.m
//  AnyTrans
//
//  Created by long on 16-7-26.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackUpTableView.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBCheckBoxCell.h"
#import "IMBCustomCornerView.h"
#import "IMBBackupViewController.h"
#import "IMBNotificationDefine.h"
#define CELL_HEADER_HEIGHT 24
@implementation IMBBackUpTableView
@synthesize headCheckCell = _headCheckCell;
@synthesize checkBoxCell = _checkBoxCell;
@synthesize selectionColor = _selectionColor;
@synthesize alternatingEvenRowBackgroundColor = _alternatingEvenRowBackgroundColor;
@synthesize alternatingOddRowBackgroundColor = _alternatingOddRowBackgroundColor;
@synthesize isHighLight = _isHighLight;
@synthesize canSelect = _canSelect;
@synthesize clickCheckBox = _clickCheckBox;
@synthesize refresh = _refresh;
@synthesize clikeRow = _clikeRow;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupHeaderCell];
        [self _setupCornerView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];

        _selectionColor = [[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)] retain];
        _alternatingEvenRowBackgroundColor = [[StringHelper getColorFromString:CustomColor(@"tableView_evenBgColor", nil)] retain];
        _alternatingOddRowBackgroundColor = [[StringHelper getColorFromString:CustomColor(@"tableView_oddBgColor", nil)] retain];
        _canSelect = YES;
        
    }
    return self;
}

- (void)changeSkin:(NSNotification *)notification
{

    [self setSelectionColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_FocusColor", nil)]];
    [self setAlternatingEvenRowBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_evenBgColor", nil)]];
    [self setAlternatingOddRowBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_oddBgColor", nil)]];

    for (NSTableColumn *tableColumn in [self tableColumns]) {
        NSTextFieldCell *fieldCell = (NSTextFieldCell *)tableColumn.dataCell;
        if ([fieldCell isKindOfClass:[IMBCenterTextFieldCell class]]) {
            [((IMBCenterTextFieldCell *)fieldCell) setTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [((IMBCenterTextFieldCell *)fieldCell) setHilightTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
        }else if ([fieldCell isKindOfClass:[IMBCheckBoxCell class]]){
            [((IMBCheckBoxCell *)fieldCell) reloadImage];
        }
    }
    
    for (NSTableColumn *column in [self tableColumns]) {
        NSTableHeaderCell *cell = [column headerCell];
        NSTableHeaderCell *newCell;
        if ([@"CheckCol" isEqualToString:column.identifier]) {
            _headCheckCell = [[IMBCheckHeaderCell alloc] initWithCell:cell];
            [_headCheckCell.checkButton setTarget:self];
            [_headCheckCell.checkButton setAction:@selector(clickHeadCheckButton:)];
            newCell = _headCheckCell;
        }else{
            
            NSString *newTitleKey = [NSString stringWithFormat:CustomLocalizedString(@"List_Header_id_%@", nil),column.identifier];
            NSString *newTitle = CustomLocalizedString(newTitleKey, nil);
            if ([column.identifier isEqualToString:@"Btn"]||[column.identifier isEqualToString:@"headCell"]) {
                cell.stringValue = @"";
            }else{
                cell.stringValue = CustomLocalizedString(newTitle, nil);
            }
            newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
        }
        [column setHeaderCell:newCell];
        [newCell release];
    }



}

- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSTableColumn *column in [self tableColumns]) {
            NSTableHeaderCell *cell = [column headerCell];
            NSTableHeaderCell *newCell;
            if ([@"CheckCol" isEqualToString:column.identifier]) {
                _headCheckCell = [[IMBCheckHeaderCell alloc] initWithCell:cell];
                [_headCheckCell.checkButton setTarget:self];
                [_headCheckCell.checkButton setAction:@selector(clickHeadCheckButton:)];
                newCell = _headCheckCell;
            }else{
                
                NSString *newTitleKey = [NSString stringWithFormat:CustomLocalizedString(@"List_Header_id_%@", nil),column.identifier];
                NSString *newTitle = CustomLocalizedString(newTitleKey, nil);
                if ([column.identifier isEqualToString:@"Btn"]||[column.identifier isEqualToString:@"headCell"]) {
                    cell.stringValue = @"";
                }else{
                    cell.stringValue = CustomLocalizedString(newTitle, nil);
                }
                newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
            }
            [column setHeaderCell:newCell];
            [newCell release];
        }

    });
 }


- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingMouseMoved;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}


- (void)setListener:(id<IMBImageRefreshListListener>)listener {
    _listener = listener;
}

- (void)_setupCornerView
{
	NSView* cornerView = [self cornerView];
    NSTableColumn *colum = [self.tableColumns objectAtIndex:0];
    if (![colum.identifier isEqualToString:cornerView.identifier]) {
        IMBCustomCornerView* newCornerView = [[IMBCustomCornerView alloc] initWithFrame:cornerView.frame];
        [self setCornerView:newCornerView];
        [newCornerView release];
    }
}

- (void)setupHeaderCell{
    NSTableHeaderView *tableHeaderView = [self headerView];
    [tableHeaderView setFrameSize:NSMakeSize(tableHeaderView.frame.size.width, CELL_HEADER_HEIGHT)];
    
    for (NSTableColumn *column in [self tableColumns]) {
        NSTableHeaderCell *cell = [column headerCell];
        NSTableHeaderCell *newCell;
        if ([@"CheckCol" isEqualToString:column.identifier]) {
            _headCheckCell = [[IMBCheckHeaderCell alloc] initWithCell:cell];
            [_headCheckCell.checkButton setTarget:self];
            [_headCheckCell.checkButton setAction:@selector(clickHeadCheckButton:)];
            newCell = _headCheckCell;
        }else{
            NSString *newTitleKey = [NSString stringWithFormat:CustomLocalizedString(@"List_Header_id_%@", nil),column.identifier];
            NSString *newTitle = CustomLocalizedString(newTitleKey, nil);
            cell.stringValue = CustomLocalizedString(newTitle, nil);
            newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
        }
        [column setHeaderCell:newCell];

        [newCell release];
    }
}
- (void)setHeaderTextAlignment:(NSTextAlignment)alignment{
    for (NSTableColumn *colum in [self tableColumns]) {
        
        id cell = [colum headerCell];
        
        if ([colum.identifier isEqualToString:@"CheckCol"] && [cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            
            IMBCustomHeaderCell *cell = [colum headerCell];
            [cell setTextAlignment:NSLeftTextAlignment];
        }
    }
}

- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect
{
    if (!_isHighLight) {
        NSColor* bgColor = Nil;
        if ((self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow]))//||_canSelect
        {
            if (_selectionColor) {
                bgColor = _selectionColor;
            } else {
                bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_row_noselected_bg", nil)];
            }
        }else{
            if (_selectionColor) {
                bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_LoseFocusColor", nil)];
            } else {
                bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_row_noselected_bg", nil)];
            }
            
        }
        
        NSIndexSet* selectedRowIndexes = [self selectedRowIndexes];
        if ([selectedRowIndexes containsIndex:row])
        {
            [[NSColor clearColor] setFill];
            NSRectFill([self rectOfRow:row]);
            [bgColor setFill];
            NSRectFill([self rectOfRow:row]);
        }
        
        
        [super drawRow:row clipRect:clipRect];
        
    }else{
        [super drawRow:row clipRect:clipRect];
    }
}
- (void)drawBackgroundInClipRect:(NSRect)clipRect
{
    
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
                [[NSColor clearColor] setFill];
                NSRectFill(rect);
                [_alternatingEvenRowBackgroundColor setFill];
            }else
            {    [[NSColor clearColor] setFill];
                NSRectFill(rect);
                [_alternatingOddRowBackgroundColor setFill];
            }
            NSRectFill(rect);
        }
    }else
    {
        [super drawBackgroundInClipRect:clipRect];
    }
}

- (void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend
{
    if (!_clickCheckBox&&_canSelect) {
        [super selectRowIndexes:indexes byExtendingSelection:extend];
        [self setNeedsDisplay:YES];
    }
    _clickCheckBox = NO;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    int row = (int)[self rowAtPoint:point];
    if ( row <0 ) {
        return;
    }
    NSRect rect = [self rectOfRow:row];
    int column1 = (int)[self columnWithIdentifier:@"CheckCol"];
    NSRect columRect = [self rectOfColumn:column1];
    //    IMBCheckBoxCell *cell = (IMBCheckBoxCell *)[self preparedCellAtColumn:column1 row:row];
    NSSize size = NSMakeSize(14, 14);//[cell cellSize];

    NSRect chekRect = NSMakeRect(0, 0, size.width, size.height);
    chekRect.origin.x = rect.origin.x +(columRect.size.width - size.width)/2+8;
    chekRect.origin.y = rect.origin.y + (rect.size.height - size.height)/2.0;
    if (NSMouseInRect(point, chekRect, [self isFlipped])) {
        _clickCheckBox = YES;
        [super mouseDown:theEvent];
        if ([_listener respondsToSelector:@selector(tableView:row:)]) {
            [_listener tableView:self row:row];
        }
    }else {
        _clickCheckBox = NO;
        [super mouseDown:theEvent];
    }
//    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
//    if ([_listener respondsToSelector:@selector(loadViewBtn)]) {
//        [_listener loadViewBtn];
//    }
}

- (void)viewWillDraw {
    [super viewWillDraw];
    NSRange newVisibleRows = [self rowsInRect:self.visibleRect];
    BOOL visibleRowsNeedsUpdate = !NSEqualRanges(newVisibleRows, _visibleRows);
    NSRange oldVisibleRows = _visibleRows;
    if (visibleRowsNeedsUpdate) {
        _visibleRows = newVisibleRows;
        if ([_listener respondsToSelector:@selector(loadingThumbnilImage:withNewVisibleRows:)]) {
            [_listener loadingThumbnilImage:oldVisibleRows withNewVisibleRows:_visibleRows];
        }
    }else {
        if (_refresh) {
            if ([_listener respondsToSelector:@selector(loadingThumbnilImage:withNewVisibleRows:)]) {
                [_listener loadingThumbnilImage:oldVisibleRows withNewVisibleRows:_visibleRows];
            }
            _refresh = NO;
        }
    }
}

-(void)mouseMoved:(NSEvent *)theEvent{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    long row = [self rowAtPoint:point];
    if (row != _clikeRow) {
        _clikeRow = row;
        [_listener loadButtonCell:(int)row withOutlineView:self];
    }
}

-(void)mouseExited:(NSEvent *)theEvent {
    NSPoint aPoint =[self convertPoint:theEvent.locationInWindow fromView:nil];
    NSInteger row = [self rowAtPoint:aPoint];
    _clikeRow = -1;
    [_listener loadButtonMouseExitedCell:(int)row withOutlineView:self];
}

- (void)clickHeadCheckButton:(id)sender {
    
}

- (void)dealloc
{
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [_selectionColor release],_selectionColor = nil;
    [_checkBoxCell release],_checkBoxCell = nil;
    [_alternatingEvenRowBackgroundColor release],_alternatingEvenRowBackgroundColor = nil;
    [_alternatingOddRowBackgroundColor release],_alternatingOddRowBackgroundColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}


@end
