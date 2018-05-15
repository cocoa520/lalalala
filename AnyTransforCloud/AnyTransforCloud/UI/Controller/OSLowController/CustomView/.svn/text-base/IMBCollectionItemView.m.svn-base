//
//  IMBCollectionItemView.m
//  AnyTransforCloud
//
//  Created by iMobie on 5/3/18.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBCollectionItemView.h"
#import "IMBCloudEntity.h"
#import "StringHelper.h"
#import "IMBDriveModel.h"

@implementation IMBCollectionItemView
@synthesize done = _done;

-(void)awakeFromNib {
//    [_bgImageView setImage:[StringHelper imageNamed:@"photo_selected"]];
    [_titleTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_numberTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved| NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSImageView *imageView = [self viewWithTag:101];
    BOOL overClose = NSMouseInRect(mousePt,[imageView frame], [self isFlipped]);
    if (overClose) {
        if (theEvent.clickCount == 2) {
            _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
//            if ([_blankDraggableView.collectionItem isKindOfClass:[IMBPhotoCollectionViewItem class]]||[_blankDraggableView.collectionItem isKindOfClass:[IMBBackupCollectionViewItem class]]) {
//                NSArray *contentArray = _blankDraggableView.content;
//                
//                //                NSPoint initialLocation = [theEvent locationInWindow];
//                //                NSPoint location = [_blankDraggableView convertPoint:initialLocation fromView:nil];
//                //                NSInteger index = [_blankDraggableView _indexAtPoint: location];
//                NSIndexSet *set= [_blankDraggableView selectionIndexes];
//                if (set.count <= 0) {
//                    return;
//                }
//                NSInteger index = [set firstIndex];
//                IMBPhotoEntity *entity = [contentArray objectAtIndex:index];
//                
//                NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:entity, @"ENTITY", nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OPEN_PHOTO_PREVIEW object:nil userInfo:userDic];
//            }
        }else if (theEvent.clickCount == 1) {
//            _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
//            if ([_blankDraggableView.collectionItem isKindOfClass:[IMBCollectionViewItem class]]) {
//                NSPoint initialLocation = [theEvent locationInWindow];
//                NSPoint location = [_blankDraggableView convertPoint:initialLocation fromView:nil];
//                NSInteger index = [_blankDraggableView _indexAtPoint:location];
//                NSArray *contentArray = _blankDraggableView.content;
//                IMBCloudEntity *entity = [contentArray objectAtIndex:index];
//                [[NSNotificationCenter defaultCenter] postNotificationName:ClickCollectionEvent object:entity userInfo:nil];
//            }else {
                [super mouseDown:theEvent];
//            }
        }
    }else
    {
        _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
        [_blankDraggableView setSelectionIndexes:[NSIndexSet indexSet]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyDone:) name:NOTIFY_DONE object:nil];
        NSPoint initialLocation = [theEvent locationInWindow];
        
        _done = NO;
        NSUInteger eventMask = (NSLeftMouseUpMask | NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSPeriodicMask);
        NSEvent *lastEvent = theEvent;
        while (!_done) {
            lastEvent = [NSApp nextEventMatchingMask:eventMask untilDate:[NSDate date] inMode:NSEventTrackingRunLoopMode dequeue:YES];
            NSEventType eventType = [lastEvent type];
            NSPoint mouseLocationWin = [lastEvent locationInWindow];
            switch (eventType)
            {
                case NSLeftMouseDown:
                    break;
                case NSLeftMouseDragged:
                    if (fabs(mouseLocationWin.x - initialLocation.x) >= 2
                        || fabs(mouseLocationWin.y - initialLocation.y) >= 2)
                    {
                        [super mouseDown:theEvent];
                    }
                    break;
                case NSLeftMouseUp:
                    //                    [_blankDraggableView _selectWithEvent:theEvent index: index];
                    _done = YES;
                    NSLog(@"mouse up");
                    break;
                default:
                    _done = NO;
                    break;
            }
            
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_DONE object:nil];
    }
}

- (void)notifyDone:(NSNotification *)notification {
    NSNumber *number = [notification object];
    BOOL isDone = [number boolValue];
    [self setDone:isDone];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    _done = YES;
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSImageView *imageView = [self viewWithTag:101];
    BOOL overClose = NSMouseInRect(mousePt,[imageView frame], [self isFlipped]);
    if (overClose) {
        if (theEvent.clickCount <= 1) {
            _blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
            if ([_blankDraggableView.collectionItem isKindOfClass:[IMBCollectionViewItem class]] || [_blankDraggableView.collectionItem isKindOfClass:[IMBHomeCollectionViewItem class]]) {
                NSPoint initialLocation = [theEvent locationInWindow];
                NSPoint location = [_blankDraggableView convertPoint:initialLocation fromView:nil];
                NSInteger index = [_blankDraggableView _indexAtPoint:location];
                NSArray *contentArray = _blankDraggableView.content;
                IMBCloudEntity *entity = [contentArray objectAtIndex:index];
                if ([_blankDraggableView.collectionItem isKindOfClass:[IMBCollectionViewItem class]]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ClickCollectionEvent object:entity userInfo:nil];
                }else if ([_blankDraggableView.collectionItem isKindOfClass:[IMBHomeCollectionViewItem class]]) {
//                    BOOL isClick = YES;
//                    if ([entity.driveID isEqualToString:@"HomeAddID"]) {
//                        NSRect rect = NSMakeRect([imageView frame].origin.x, [imageView frame].origin.y, 148, 92);
//                        isClick = NSMouseInRect(mousePt, rect, [self isFlipped]);
//                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:HomeClickCollectionEvent object:entity userInfo:nil];
                }
            }else if ([_blankDraggableView.collectionItem isKindOfClass:[IMBHomeFileCollectionViewItem class]]) {
                NSPoint initialLocation = [theEvent locationInWindow];
                NSPoint location = [_blankDraggableView convertPoint:initialLocation fromView:nil];
                NSInteger index = [_blankDraggableView _indexAtPoint:location];
                NSArray *contentArray = _blankDraggableView.content;
                IMBDriveModel *entity = [contentArray objectAtIndex:index];
                if ([entity.itemIDOrPath isEqualToString:@"moreHistoryID"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:HomeFileClickCollectionEvent object:entity userInfo:nil];
                }
            }else {
                [super mouseDown:theEvent];
            }
        }
    }
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_OPEN_PHOTO_PREVIEW object:nil];
    [super dealloc];
}

@end
