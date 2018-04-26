//
//  IMBBlankDraggableCollectionView.m
//  iMobieTrans
//
//  Created by iMobie on 8/4/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBlankDraggableCollectionView.h"
#import "IMBNotificationDefine.h"
//#import "IMBSystemCollectionViewController.h"
#import "StringHelper.h"
@class IMBCollectionImageView;
@implementation IMBBlankDraggableCollectionView
@synthesize collectionItem = _collectionItem;
@synthesize isShowBgVeiw = _isShowBgVeiw;
//static int i=0;
//@synthesize exploreType = _exploreType;
@synthesize topBorder = _topBorder;
@synthesize backgroundImage = backgroundImage;
@synthesize category = _category;
@synthesize dragFinished = _dragFinished;
@synthesize isDropBefore = _isDropBefore;
@synthesize forBidClick = _forBidClick;
@synthesize refresh = _refresh;
@synthesize totalCount = _totalCount;
@synthesize column = _column;
@synthesize backGroundColor = _backGroundColor;
@synthesize borderColor = _borderColor;
- (void)setListener:(id<IMBImageRefreshCollectionListener>)listener {
    _listener = listener;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isShowBgVeiw = NO;
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object
{
    NSCollectionViewItem *viewItem = [super newItemForRepresentedObject:object];
//    NSView *view = viewItem.view;
//    if (_category == Category_Movies) {
//        IMBCollectionImageView *imageView = [view viewWithTag:101];
//        if (_defaultImage == nil) {
//            _defaultImage = [[StringHelper imageNamed:@"movies_show"] retain];
//        }
//        [imageView setImage:_defaultImage];
//    }else if (_category == Category_Music||_category == Category_CloudMusic||_category == Category_MusicVideo)
//    {
//        IMBCollectionImageView *imageView = [view viewWithTag:101];
//        if (_defaultImage == nil) {
//            _defaultImage = [[NSImage imageNamed:@"music_show"] retain];
//        }
//        [imageView setImage:_defaultImage];
//
//    }else if (_category == Category_TVShow)
//    {
//        IMBCollectionImageView *imageView = [view viewWithTag:101];
//        if (_defaultImage == nil) {
//            _defaultImage = [[StringHelper imageNamed:@"tv_show"] retain];
//        }
//        [imageView setImage:_defaultImage];
//        
//    }else if (_category == Category_Ringtone)
//    {
//        IMBCollectionImageView *imageView = [view viewWithTag:101];
//        if (_defaultImage == nil) {
//            _defaultImage = [[StringHelper imageNamed:@"ringtone_show"] retain];
//        }
//        [imageView setImage:_defaultImage];
//    }
//    else if (_category == Category_iCloudDriver)
//    {
//        IMBCollectionImageView *imageView = [view viewWithTag:101];
//        if (_defaultImage == nil) {
//            _defaultImage = [[StringHelper imageNamed:@"annoy_file_three"] retain];
//        }
//        [imageView setImage:_defaultImage];
//    }
    return viewItem;
}

- (void)setBackGroundColor:(NSColor *)backGroundColor
{
    if (_backGroundColor != backGroundColor) {
        [_backGroundColor release];
        _backGroundColor = [backGroundColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setBorderColor:(NSColor *)borderColor
{
    if (_borderColor != borderColor) {
        [_borderColor release];
        _borderColor = [borderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if (_backGroundColor) {
        [_backGroundColor setFill];
        NSRectFill(dirtyRect);
    }
    
    if (_borderColor) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
        [_borderColor setStroke];
        [path stroke];
    }
    
    if (_topBorder) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width,0)];
        [[NSColor colorWithDeviceRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1] setStroke];
        [path stroke];
     }
    if (backgroundImage) {
        int totalRows = ceil(self.frame.size.height/248.0);
        for(int i = 0; i< totalRows;i++){
            float originY = (i + 1)*248-36-backgroundImage.size.height;
            [backgroundImage drawInRect:NSMakeRect(0, originY, 800, backgroundImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }

    }
    
    NSPoint origin = dirtyRect.origin;
    NSSize size = dirtyRect.size;
    NSPoint oppositeOrigin = NSMakePoint (origin.x + size.width, origin.y + size.height);
    
    NSInteger firstIndexInRect = MAX(0, [self _indexAtPoint: origin]);
    NSInteger lastIndexInRect = MIN([[self content] count] - 1, [self _indexAtPoint: oppositeOrigin]);
    if ([[self content] count] == 0) {
        lastIndexInRect = -1;
    }
    
    for (NSInteger index = firstIndexInRect; index <= lastIndexInRect; index++)
    {
        // Calling itemAtIndex: will eventually instantiate the collection view item,
        // if it hasn't been done already.
        NSCollectionViewItem *collectionItem = [self itemAtIndex: index];
        NSView *view = [collectionItem view];
        NSRect rect = [self frameForItemAtIndex: index];
        [view setFrame: rect];
        if (![view superview]) {
            [self addSubview:view];

        }
    }
 }

- (void)viewWillMoveToSuperview:(NSView *)newSuperview{
    [super viewWillMoveToSuperview:newSuperview];
}

- (void)viewWillDraw{
    [super viewWillDraw];
    [self setFrame:self.frame];
    [self.window makeKeyWindow];
    [self.window makeMainWindow];
    [self.window setViewsNeedDisplay:YES];
    
    
    
}

/*- (void)enteredShowBgView {
    NSArray *subviews = self.subviews;
    
    NSPoint point = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
    for (NSView *view in subviews) {
        
        NSView *sonView = nil;
        if (view.subviews.count > 0) {
            sonView = [[view subviews] objectAtIndex:0];
        }
        
        BOOL mouseInside = FALSE;
        NSRect bounds = NSZeroRect;
        if (sonView != nil) {
            int count = [subviews indexOfObject:view];
            int row = count/self.maxNumberOfColumns;
            int column = count - row*self.maxNumberOfColumns;
            float originX = column * view.frame.size.width;
            float originY = 0;
            originY = row * view.frame.size.height;
            float offset = view.frame.size.height - sonView.frame.origin.y - sonView.frame.size.height;
            bounds = NSMakeRect(originX + sonView.frame.origin.x, originY + offset, sonView.frame.size.width, sonView.frame.size.height);
        }
        mouseInside = NSPointInRect(point, bounds);
        
        if (mouseInside) {
            if ([sonView respondsToSelector:@selector(setIsEntered:)]) {
                [sonView setIsEntered:true];
            }
        }else {
            
            if ([sonView respondsToSelector:@selector(setIsEntered:)]) {
                [sonView setIsEntered:false];
            }
        }
    }
}*/

- (void)showVisibleRextPhoto {
    NSRect rect = self.visibleRect;
    //    NSLog(@"rect (%f,%f,%f,%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    NSRange newVisibleRows = [self rangeIndexAtVisibleRect:rect];
    
//    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"newVisibleRows:%@",NSStringFromRange(newVisibleRows)]];
    
    BOOL visibleRowsNeedsUpdate = !NSEqualRanges(newVisibleRows, _visibleRows);
    NSRange oldVisibleRows = _visibleRows;
    if (visibleRowsNeedsUpdate) {
        _visibleRows = newVisibleRows;
        if ([_listener respondsToSelector:@selector(loadingCollectionThumbnilImage:withNewVisibleRows:)]) {
            [_listener loadingCollectionThumbnilImage:oldVisibleRows withNewVisibleRows:_visibleRows];
        }
    }
    if (_refresh) {
        if ([_listener respondsToSelector:@selector(loadingCollectionThumbnilImage:withNewVisibleRows:)]) {
            [_listener loadingCollectionThumbnilImage:oldVisibleRows withNewVisibleRows:_visibleRows];
        }
        _refresh = NO;
    }
}

- (NSRange)rangeIndexAtVisibleRect:(NSRect)visibleRect {
    NSRect itemRect = [self frameForItemAtIndex:0];//3*5
    int minRow = visibleRect.origin.y / itemRect.size.height;
    int maxRow = (visibleRect.origin.y + visibleRect.size.height) / itemRect.size.height;
    //    NSLog(@"minRow:%d  maxRow:%d",minRow,maxRow);
    _column = visibleRect.size.width / itemRect.size.width;
    int minIndex = minRow * _column;
    int maxIndex = maxRow * _column;
    maxIndex = _totalCount > maxIndex ? maxIndex:_totalCount;
    //    NSLog(@"minIndex:%d  maxIndex:%d",minIndex,maxIndex);
    return NSMakeRange(minIndex, maxIndex - minIndex);
}

- (NSInteger) _indexAtPoint: (NSPoint)point
{
    NSInteger row = floor(point.y / (_collectionItem.view.frame.size.height + 0));
    NSInteger column = floor(point.x / (_collectionItem.view.frame.size.width + 0));
    return (column + (row * floor((NSWidth(self.frame)/NSWidth(_collectionItem.view.frame)))));
}

- (void)mouseDown:(NSEvent *)theEvent{
    
    _dragFinished = NO;
   [super mouseDown:theEvent];
    _dragFinished = YES;
    if ([[self selectionIndexes] count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemSingleClick object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DONE object:[NSNumber numberWithBool:YES]];
}

- (NSRect) _frameForRowOfItemAtIndex: (NSUInteger)theIndex
{
    NSRect itemFrame = [self frameForItemAtIndex: theIndex];
    
    return NSMakeRect (0, itemFrame.origin.y, [self bounds].size.width, itemFrame.size.height);
}

// Returns the frame of an item's row with the row above and the row below
- (NSRect) _frameForRowsAroundItemAtIndex: (NSUInteger)theIndex
{
    NSRect itemRowFrame = [self _frameForRowOfItemAtIndex: theIndex];
    CGFloat y = MAX (0, itemRowFrame.origin.y - itemRowFrame.size.height);
    CGFloat height = MIN (itemRowFrame.size.height * 3, [self bounds].size.height);
    
    return NSMakeRect(0, y, itemRowFrame.size.width, height);
}

- (void)setTopBorder:(BOOL)topBorder
{
    if (_topBorder != topBorder) {
        _topBorder = topBorder;
        [self setNeedsDisplay:YES];
    }
}

- (BOOL)mouseDownCanMoveWindow
{
    return YES;
}

- (void)dealloc
{

    [backgroundImage release],backgroundImage = nil;
    [_defaultImage release],_defaultImage = nil;
    [super dealloc];
}


- (void)mouseDragged:(NSEvent *)theEvent
{
    [super mouseDragged:theEvent];
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    if ([self.delegate respondsToSelector:@selector(dragExited:)]) {
        [self.delegate dragExited:sender];
    }
}


- (void)setSelectionIndexes:(NSIndexSet *)indexes
{
    if ([_listener respondsToSelector:@selector(itemCanSelected:)]) {
        indexes  = [_listener itemCanSelected:indexes];
    }
    [super setSelectionIndexes:indexes];
}

- (BOOL)canBecomeKeyView{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

- (BOOL)canDrawSubviewsIntoLayer
{
    return YES;
}

- (BOOL)acceptsFirstResponder{
    return YES;
}

- (BOOL)canDraw{
    return YES;
}


@end

@implementation IMBBindItem
@synthesize textColor = _textColor;

- (void)awakeFromNib
{
    _textColor = [[NSColor redColor] retain];
}

- (NSArray *)exposedBindings
{
    return [NSArray arrayWithObject:@"textColor"];
}

-(void)dealloc
{
    [_textColor release],_textColor = nil;
    [super dealloc];
}


@end
