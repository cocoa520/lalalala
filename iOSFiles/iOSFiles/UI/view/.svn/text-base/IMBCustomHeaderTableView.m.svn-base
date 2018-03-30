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
@synthesize refresh = _refresh;
@synthesize isNote = _isNote;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupHeaderCell];
        [self _setupCornerView];
        _selectionColor = [COLOR_TRABLEVIEW_ENTER_BG retain];
        _alternatingEvenRowBackgroundColor = [COLOR_View_NORMAL retain];
        _alternatingOddRowBackgroundColor = [[NSColor colorWithDeviceRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.000] retain];
        _canSelect = YES;
    }
    return self;
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

- (void)setupHeaderCell {
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

- (void)doSelectAll:(id)sender {
    IMBCheckButton *btn = _checkBoxCell.checkButton;
    [[self window] makeFirstResponder:self];

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
        if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow]) {
            if (_isTranferView) {
                if (row == _moveRow) {
                    bgColor = COLOR_TRABLEVIEW_SELECTE_BG;
                }else{
                    if (_selectionColor) {
                        bgColor = _selectionColor;
                    } else {
                        bgColor = [NSColor colorWithDeviceRed:181.0/255 green:214.0/255 blue:244.0/255 alpha:1.0];
                    }
                }
            }else {
                if (_clickSpace) {
                    bgColor = COLOR_TABLEVIEW_CLICK;
                } else {
                    bgColor = COLOR_TABLEVIEW_CLICK;
                }
            }
        }else {

            if (self == [[self window] firstResponder] ) {
                
                bgColor = COLOR_TABLEVIEW_CLICK;
                
            }else {
                
                bgColor = COLOR_TABLEVIEW_CLICK;
            }
  
        }
        
        NSIndexSet* selectedRowIndexes = [self selectedRowIndexes];
        if ([selectedRowIndexes containsIndex:row]||(row == _moveRow && _isTranferView) ) {
            [[NSColor clearColor] setFill];
            NSRectFill([self rectOfRow:row]);
            [bgColor setFill];
            NSRectFill([self rectOfRow:row]);
        }
        [super drawRow:row clipRect:clipRect];
        
    }else {
        
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

- (void)updateTrackingAreas {
    
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
    if (_canSelect) {
        [super selectRowIndexes:indexes byExtendingSelection:extend];
        [self setNeedsDisplay:YES];
        if ([_listener respondsToSelector:@selector(tableView:WithSelectIndexSet:)]) {
            [_listener tableView:self WithSelectIndexSet:indexes];
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSInteger clickCount = theEvent.clickCount;
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    int row = (int)[self rowAtPoint:point];
    if ( row >=0 ) {
        NSRect rect = [self rectOfRow:row];
        _clickSpace = NO;
        if (NSMouseInRect(point, rect, [self isFlipped])) {
            [super mouseDown:theEvent];
            
        }else {
            [super mouseDown:theEvent];
        }
        if (clickCount == 2) {
            if ([_listener respondsToSelector:@selector(tableViewDoubleClick:row:)]) {
                [_listener tableViewDoubleClick:self row:row];
            }
        }
    } else {
        _clickSpace = YES;
        if ([_listener respondsToSelector:@selector(tableView:WithSelectIndexSet:)]) {
            [_listener tableView:self WithSelectIndexSet:nil];
        }
    }
    
}

- (void)mouseMoved:(NSEvent *)theEvent {
    if (_isTranferView) {
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        int row = (int)[self rowAtPoint:point];
        _moveRow = row;
        //add to Gehry
        [self setNeedsDisplay:YES];
    }else{
        [super mouseMoved:theEvent];
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

- (void)showVisibleRextPhoto {
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
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_View_NORMAL range:NSMakeRange(0, str.length)];
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
    [COLOR_View_NORMAL setStroke];
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
    [super dealloc];
}
@end
