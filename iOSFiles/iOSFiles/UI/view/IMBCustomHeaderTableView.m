//
//  IMBCustomHeaderTableView.m
//  MacClean
//
//  Created by Gehry on 1/20/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBCustomHeaderTableView.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBCheckBoxCell.h"
#import "IMBCustomCornerView.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"
#import "IMBCheckButton.h"
@class IMBAppDetailsViewController;

#define CELL_HEADER_HEIGHT 24
@implementation IMBCustomHeaderTableView
@synthesize headCheckCell = _headCheckCell;
@synthesize checkBoxCell = _checkBoxCell;
@synthesize selectionColor = _selectionColor;
@synthesize alternatingEvenRowBackgroundColor = _alternatingEvenRowBackgroundColor;
@synthesize alternatingOddRowBackgroundColor = _alternatingOddRowBackgroundColor;
@synthesize isHighLight = _isHighLight;
@synthesize canSelect = _canSelect;
@synthesize clickCheckBox = _clickCheckBox;
@synthesize refresh = _refresh;
@synthesize isNote = _isNote;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSTableColumn *column in [self tableColumns]) {
            NSTableHeaderCell *cell = [column headerCell];
            NSTableHeaderCell *newCell;
            if ([@"CheckCol" isEqualToString:column.identifier]) {
                int state = _headCheckCell.checkButton.state;
                [_headCheckCell.checkButton setState:state];
                [_headCheckCell.checkButton setTarget:self];
                [_headCheckCell.checkButton setAction:@selector(clickHeadCheckButton:)];
                [_headCheckCell.checkButton setNeedsDisplay:YES];
                newCell = [_headCheckCell retain];
            }else{
                NSString *newTitleKey = column.identifier;//[NSString stringWithFormat:CustomLocalizedString(@"List_Header_id_%@", nil),column.identifier];
                NSString *newTitle = newTitleKey;//CustomLocalizedString(newTitleKey, nil);
                cell.stringValue = newTitle;//CustomLocalizedString(newTitle, nil);
                newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
            }
            [column setHeaderCell:newCell];
            if ([newCell isKindOfClass:[IMBCheckHeaderCell class]]) {
                _checkBoxCell = [(IMBCheckHeaderCell *)newCell retain];
                [[_checkBoxCell checkButton] setTarget:self];
                [_checkBoxCell.checkButton setAction:@selector(doSelectAll:)];
            }
            [newCell release];
        }
    });

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupHeaderCell];
        [self _setupCornerView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        _selectionColor = [[NSColor colorWithDeviceRed:50.0/255 green:177.0/255 blue:250.0/255 alpha:1.000] retain];
        _alternatingEvenRowBackgroundColor = [COLOR_PROMPTBTN_BORDER retain];
        _alternatingOddRowBackgroundColor = [[NSColor colorWithDeviceRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.000] retain];
        _canSelect = YES;
    }
    return self;
}

- (void)changeSkin:(NSNotification *)notification
{
    [self setAlternatingEvenRowBackgroundColor:COLOR_PROMPTBTN_BORDER];
    [self setAlternatingOddRowBackgroundColor:[NSColor colorWithDeviceRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.000]];
    [self setSelectionColor:[NSColor colorWithDeviceRed:50.0/255 green:177.0/255 blue:250.0/255 alpha:1.000]];
    
    for (NSTableColumn *column in [self tableColumns]) {
        NSTableHeaderCell *cell = [column headerCell];
        NSTableHeaderCell *newCell;
        if ([@"CheckCol" isEqualToString:column.identifier]) {
//            _headCheckCell = [[IMBCheckHeaderCell alloc] initWithCell:cell];
            int state = _headCheckCell.checkButton.state;
            [_headCheckCell.checkButton setState:state];
            [_headCheckCell.checkButton setTarget:self];
            [_headCheckCell.checkButton setAction:@selector(clickHeadCheckButton:)];
            [_headCheckCell.checkButton setNeedsDisplay:YES];
            
            newCell = [_headCheckCell retain];
        }else{
            NSString *newTitleKey = column.identifier;//[NSString stringWithFormat:CustomLocalizedString(@"List_Header_id_%@", nil),column.identifier];
            NSString *newTitle = newTitleKey;//CustomLocalizedString(newTitleKey, nil);
            cell.stringValue = newTitle;//CustomLocalizedString(newTitle, nil);
            newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
        }
        [column setHeaderCell:newCell];
        if ([newCell isKindOfClass:[IMBCheckHeaderCell class]]) {
            _checkBoxCell = [(IMBCheckHeaderCell *)newCell retain];
            [[_checkBoxCell checkButton] setTarget:self];
            [_checkBoxCell.checkButton setAction:@selector(doSelectAll:)];
        }
        [newCell release];
    }
    for (NSTableColumn *tableColumn in [self tableColumns]) {
        NSTextFieldCell *fieldCell = (NSTextFieldCell *)tableColumn.dataCell;
        if ([fieldCell isKindOfClass:[IMBCenterTextFieldCell class]]) {
            [((IMBCenterTextFieldCell *)fieldCell) setTitleColor:COLOR_TEXT_ORDINARY];
             [((IMBCenterTextFieldCell *)fieldCell) setHilightTitleColor:COLOR_PROMPTBTN_BORDER];
        }else if ([fieldCell isKindOfClass:[IMBCheckBoxCell class]]){
            [((IMBCheckBoxCell *)fieldCell) reloadImage];
        }
    }
}

- (void)setListener:(id<IMBImageRefreshListListener>)listener {
    _listener = listener;
}

- (void)_setupCornerView {
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
            newCell = _headCheckCell ;
        }else{
            NSString *newTitleKey = column.identifier;//[NSString stringWithFormat:CustomLocalizedString(@"List_Header_id_%@", nil),column.identifier];
            NSString *newTitle = newTitleKey;//CustomLocalizedString(newTitleKey, nil);
            cell.stringValue = newTitle;//CustomLocalizedString(newTitle, nil);
            newCell = [[IMBCustomHeaderCell alloc] initWithCell:cell];
        }
        [column setHeaderCell:newCell];
        if ([newCell isKindOfClass:[IMBCheckHeaderCell class]]) {
            _checkBoxCell = [(IMBCheckHeaderCell *)newCell retain];
            [[_checkBoxCell checkButton] setTarget:self];
             [_checkBoxCell.checkButton setAction:@selector(doSelectAll:)];
        }
        [newCell release];
    }
}

- (void) doSelectAll:(id)sender {
    IMBCheckBtn *btn = _checkBoxCell.checkButton;
    [[self window] makeFirstResponder:self];
//    if (btn.state == true) {
//        _clickCheckBox = NO;
//        [self selectAll:nil];
//       
//    } else {
//        [self deselectAll:nil];
//    }

    if ([_listener respondsToSelector:@selector(setAllselectState:)]) {
        [_listener setAllselectState:(CheckStateEnum)btn.state];
    }
    
    if ([_listener respondsToSelector:@selector(setselectState:WithTableView:)]) {
        [_listener setselectState:(CheckStateEnum)btn.state WithTableView:self];
    }
}

- (void)changeHeaderCheckState:(NSInteger)state {
    [_checkBoxCell.checkButton setState:state];
}

- (void)setHeaderTextAlignment:(NSTextAlignment)alignment {
    for (NSTableColumn *colum in [self tableColumns]) {
        
        id cell = [colum headerCell];
        
        if ([colum.identifier isEqualToString:@"CheckCol"] && [cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            
            IMBCustomHeaderCell *cell = [colum headerCell];
            [cell setTextAlignment:NSLeftTextAlignment];
        }
    }
}

- (void)drawRow:(NSInteger)row clipRect:(NSRect)clipRect {
    if (!_isHighLight) {
        NSColor* bgColor = Nil;
        if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow])
        {
            if (_selectionColor) {
                bgColor = _selectionColor;
            } else {
                bgColor = [NSColor colorWithDeviceRed:181.0/255 green:214.0/255 blue:244.0/255 alpha:0.2];
            }
        }else{
//            if (_selectionColor) {
//                bgColor = TableView_Cell_isNOFirstResponder;
//            } else {
//                bgColor = TableView_Cell_isNOFirstResponder;
//            }
            if (self == [[self window] firstResponder] ) {
                if (_selectionColor) {
                    bgColor = [NSColor colorWithDeviceRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:0.2];
//                    bgColor = _selectionColor;
                } else {
                    bgColor = [NSColor colorWithDeviceRed:181.0/255 green:214.0/255 blue:244.0/255 alpha:0.2];
                }
            }else{
                if (_isNote) {
                    if (_selectionColor) {
                        bgColor = _selectionColor;
                    } else {
                        bgColor = [NSColor colorWithDeviceRed:181.0/255 green:214.0/255 blue:244.0/255 alpha:0.2];
                    }
                }else {
                   bgColor = [NSColor colorWithDeviceRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:0.2];
                }
                
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
                [[NSColor clearColor] setFill];
                NSRectFill(rect);
                [_alternatingEvenRowBackgroundColor setFill];
            }else
            {
                [[NSColor clearColor] setFill];
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


- (void)updateTrackingAreas{
    
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseMoved|NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend {
    if (!_clickCheckBox&&_canSelect) {
        [super selectRowIndexes:indexes byExtendingSelection:extend];
        [self setNeedsDisplay:YES];
    }
    _clickCheckBox = NO;
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    int row = (int)[self rowAtPoint:point];
    if ( row <0 ) {
        return;
    }
    NSRect rect = [self rectOfRow:row];
    int column1 = (int)[self columnWithIdentifier:@"CheckCol"];
    NSRect columRect = [self rectOfColumn:column1];
   IMBCheckBoxCell *cell = (IMBCheckBoxCell *)[self preparedCellAtColumn:column1 row:row];
    NSSize size = /*NSMakeSize(14, 14);/*/[cell cellSize];
    
    NSRect chekRect = NSMakeRect(0, 0, size.width, size.height);
    if (cell.outlineCheck) {
        chekRect.origin.x = rect.origin.x +(columRect.size.width - size.width)/2 +6;
        chekRect.origin.y = rect.origin.y + (rect.size.height - size.height)/2.0+1;
    }else {
        chekRect.origin.x = rect.origin.x +(columRect.size.width - size.width)/2;
        chekRect.origin.y = rect.origin.y + (rect.size.height - size.height)/2.0+1;
    }
    
    if (NSMouseInRect(point, chekRect, [self isFlipped])) {
        _clickCheckBox = YES;
        [super mouseDown:theEvent];
        if ([_listener respondsToSelector:@selector(tableView:row:)]) {
            [_listener tableView:self row:row];
        }
//        _clickCheckBox = YES;
    }else {
//        if (_checkBoxCell.checkButton.state == NSOnState) {
//             _clickCheckBox = NO;
//            [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
//        }else {
            _clickCheckBox = NO;
            [super mouseDown:theEvent];
//        }
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    int row = (int)[self rowAtPoint:point];
    if ( row <0 ) {
        return;
    }
    NSRect rect = [self rectOfRow:row];
    
    if (NSMouseInRect(point, rect, [self isFlipped])) {
        _clickCheckBox = NO;
        if ([_listener respondsToSelector:@selector(tableView:rightDownrow:)]) {
            [_listener tableView:self rightDownrow:row];
        }
    }
    [super rightMouseDown:theEvent];
}

- (void)viewWillDraw {
    [super viewWillDraw];
    [self showVisibleRextPhoto];
}

-(void)showVisibleRextPhoto{
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

- (NSImage *)dragImageForRowsWithIndexes:(NSIndexSet *)dragRows tableColumns:(NSArray *)tableColumns event:(NSEvent *)dragEvent offset:(NSPointPointer)dragImageOffset {
    NSPoint point = [self convertPoint:dragEvent.locationInWindow fromView:nil];
    NSImage * image = [super dragImageForRowsWithIndexes:dragRows tableColumns:tableColumns event:dragEvent offset:&point];

    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(300, image.size.height)];
    
    [scalingimage lockFocus];
    
    [[NSColor clearColor] setFill];
    NSRectFill(NSMakeRect(0, 0, scalingimage.size.width, scalingimage.size.height));
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
    [image drawInRect:NSMakeRect(0, 0, scalingimage.size.width, scalingimage.size.height) fromRect:NSMakeRect(0, 0, scalingimage.size.width, scalingimage.size.height) operation:NSCompositeSourceOver fraction:1.0];
    
    NSIndexSet *set = [self selectedRowIndexes];
    int count = [set count];
    NSString *countstr = [NSString stringWithFormat:@"%d",count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:countstr?:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_PROMPTBTN_BORDER range:NSMakeRange(0, str.length)];
//    NSRect drawRect = NSMakeRect((scalingimage.size.width-(str.size.width+8))/2.0+15, scalingimage.size.height/2.0-10, str.size.width+8, 20);
    NSRect drawRect = NSMakeRect((scalingimage.size.width - (str.size.width + 8) )/2.0, (scalingimage.size.height - (str.size.width + 8))/2.0, str.size.width + 8, str.size.width + 8);
    NSBezierPath *path = nil;
//    if (count <= 9) {
        path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:(str.size.width + 8)/2.0 yRadius:(str.size.width + 8)/2.0];
//    }else
//    {
//        path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:8 yRadius:8];
//    }
    
    [[NSColor colorWithDeviceRed:255.0/255 green:0 blue:0 alpha:1] setFill];
    [path fill];
    [COLOR_PROMPTBTN_BORDER setStroke];
    [path stroke];
    
    [str drawInRect: NSMakeRect(drawRect.origin.x+4,drawRect.origin.y +(drawRect.size.height - str.size.height )/2.0, str.size.width+8, str.size.height)];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, scalingimage.size.width, scalingimage.size.height)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    
    [scalingimage unlockFocus];
    [scalingimage release];
    NSImage *dragImage = [[[NSImage alloc] initWithData:tempdata] autorelease];
    return dragImage;
}

- (void)clickHeadCheckButton:(id)sender {
    
}

- (void)dealloc {
    [_selectionColor release],_selectionColor = nil;
    [_checkBoxCell release],_checkBoxCell = nil;
    [_alternatingEvenRowBackgroundColor release],_alternatingEvenRowBackgroundColor = nil;
    [_alternatingOddRowBackgroundColor release],_alternatingOddRowBackgroundColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}
@end
