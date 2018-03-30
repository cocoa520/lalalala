//
//  CNGridView.m
//
//  Created by cocoa:naut on 06.10.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2012 Frank Gregor, <phranck@cocoanaut.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <QuartzCore/QuartzCore.h>
#import "NSColor+CNGridViewPalette.h"
#import "NSView+CNGridView.h"
#import "CNGridView.h"
#import "CNGridViewItemLayout.h"
#import "IMBNoTitleBarWindow.h"
#import "IMBNoTitleBarContentView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"

//#if !__has_feature(objc_arc)
//#error "Please use ARC for compiling this file."
//#endif

#pragma mark Notifications

const int CNSingleClick = 1;
const int CNDoubleClick = 2;
const int CNTrippleClick = 3;

NSString *const CNGridViewSelectAllItemsNotification = @"CNGridViewSelectAllItems";
NSString *const CNGridViewDeSelectAllItemsNotification = @"CNGridViewDeSelectAllItems";

NSString *const CNGridViewWillHoverItemNotification = @"CNGridViewWillHoverItem";
NSString *const CNGridViewWillUnhoverItemNotification = @"CNGridViewWillUnhoverItem";
NSString *const CNGridViewWillSelectItemNotification = @"CNGridViewWillSelectItem";
NSString *const CNGridViewDidSelectItemNotification = @"CNGridViewDidSelectItem";
NSString *const CNGridViewWillDeselectItemNotification = @"CNGridViewWillDeselectItem";
NSString *const CNGridViewDidDeselectItemNotification = @"CNGridViewDidDeselectItem";
NSString *const CNGridViewWillDeselectAllItemsNotification = @"CNGridViewWillDeselectAllItems";
NSString *const CNGridViewDidDeselectAllItemsNotification = @"CNGridViewDidDeselectAllItems";
NSString *const CNGridViewDidClickItemNotification = @"CNGridViewDidClickItem";
NSString *const CNGridViewDidDoubleClickItemNotification = @"CNGridViewDidDoubleClickItem";
NSString *const CNGridViewRightMouseButtonClickedOnItemNotification = @"CNGridViewRightMouseButtonClickedOnItem";

NSString *const CNGridViewItemKey = @"gridViewItem";
NSString *const CNGridViewItemIndexKey = @"gridViewItemIndex";
NSString *const CNGridViewSelectedItemsKey = @"CNGridViewSelectedItems";
NSString *const CNGridViewItemsIndexSetKey = @"CNGridViewItemsIndexSetKey";


CNItemPoint CNMakeItemPoint(NSUInteger aColumn, NSUInteger aRow) {
	CNItemPoint point;
	point.column = aColumn;
	point.row = aRow;
	return point;
}

#pragma mark CNSelectionFrameView

@interface CNSelectionFrameView : NSView
@end

#pragma mark CNGridView


//@interface CNGridView () {
//	NSMutableDictionary *keyedVisibleItems;
//	NSMutableDictionary *reuseableItems;
//	NSMutableDictionary *selectedItems;
//	NSMutableDictionary *selectedItemsBySelectionFrame;
//	CNSelectionFrameView *selectionFrameView;
//	NSNotificationCenter *nc;
//	NSMutableArray *clickEvents;
//	NSTrackingArea *gridViewTrackingArea;
//	NSTimer *clickTimer;
//	NSInteger lastHoveredIndex;
//	NSInteger lastSelectedItemIndex;
//	NSInteger numberOfItems;
//	CGPoint selectionFrameInitialPoint;
//	BOOL isInitialCall;
//	BOOL mouseHasDragged;
//	BOOL abortSelection;
//
//	CGFloat _contentInset;
//}
//@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
#import "IMBNotificationDefine.h"
#import "IMBCommonDefine.h"

@implementation CNGridView
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize gridViewTitle = _gridViewTitle;
@synthesize backgroundColor = _backgroundColor;
@synthesize scrollElasticity = _scrollElasticity;
@synthesize itemSize = _itemSize;
@synthesize allowsSelection = _allowsSelection;
@synthesize allowsMultipleSelection = _allowsMultipleSelection;
@synthesize allowsMultipleSelectionWithDrag = _allowsMultipleSelectionWithDrag;
@synthesize allowsDragAndDrop = _allowsDragAndDrop;
@synthesize useSelectionRing = _useSelectionRing;
@synthesize useHover = _useHover;
@synthesize itemContextMenu = _itemContextMenu;
@synthesize headerView = _headerView;
@synthesize useCenterAlignment = _useCenterAlignment;
@synthesize isAppItem =_isAppItem;
@synthesize isPhotoView = _isPhotoView;
@synthesize isFileManager = _isFileManager;
@synthesize isSelectView = _isSelectView;
@synthesize allowClickMultipleSelection = _allowClickMultipleSelection;


#pragma mark - Initialization
- (id)init {
	self = [super init];
	if (self) {
		[self setupDefaults];
		_delegate = nil;
		_dataSource = nil;
	}
	return self;
}

- (void)dealloc {
    NSLog(@"cngridview dealloc");
    NSClipView *clipView = [[self enclosingScrollView] contentView];
	[clipView setPostsBoundsChangedNotifications:NO];
	[nc removeObserver:self];
    
    if (keyedVisibleItems != nil) {
        [keyedVisibleItems release];
        keyedVisibleItems = nil;
    }
    if (reuseableItems != nil) {
        [reuseableItems release];
        reuseableItems = nil;
    }
    if (selectedItems != nil) {
        [selectedItems release];
        selectedItems = nil;
    }
    if (selectedItemsBySelectionFrame != nil) {
        [selectedItemsBySelectionFrame release];
        selectedItemsBySelectionFrame = nil;
    }
    if (clickEvents != nil) {
        [clickEvents release];
        clickEvents = nil;
    }
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setupDefaults];
		_delegate = nil;
		_dataSource = nil;
	}

	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupDefaults];
	}
	return self;
}

- (void)setupDefaults {
//    _eventCount = 0;
	keyedVisibleItems = [[NSMutableDictionary alloc] init];
	reuseableItems = [[NSMutableDictionary alloc] init];
	selectedItems = [[NSMutableDictionary alloc] init];
	selectedItemsBySelectionFrame = [[NSMutableDictionary alloc] init];
	clickEvents = [[NSMutableArray alloc] init];
	nc = [NSNotificationCenter defaultCenter];
	lastHoveredIndex = NSNotFound;
	lastSelectedItemIndex = NSNotFound;
    selectionFrameInitialPoint = NSZeroPoint;
	clickTimer = nil;
	isInitialCall = YES;
	abortSelection = NO;
	mouseHasDragged = NO;
	selectionFrameView = nil;
    //[nc addObserver:self selector:@selector(lisenterMouseEvent:) name:NOTIFY_MOUSE_EVENT object:nil];

	// properties
	_backgroundColor = [NSColor controlColor];
	_itemSize = [CNGridViewItem defaultItemSize];
	_gridViewTitle = nil;
	_scrollElasticity = YES;
	_allowsSelection = YES;
	_allowsMultipleSelection = NO;
	_allowsMultipleSelectionWithDrag = NO;
    _allowClickMultipleSelection = NO;
    _allowsDragAndDrop = YES;
	_useSelectionRing = YES;
	_useHover = YES;

    _isDrag = NO;
    _dragTimer = nil;
    
    _isMouseDrag = NO;

	[[self enclosingScrollView] setDrawsBackground:YES];
	NSClipView *clipView = [[self enclosingScrollView] contentView];
	[clipView setPostsBoundsChangedNotifications:YES];
	[nc addObserver:self selector:@selector(updateVisibleRect) name:NSViewBoundsDidChangeNotification object:clipView];
    
    //drop
    [self registerForDraggedTypes];
    

}

- (void)lisenterMouseEvent:(NSNotification *)noti {
    if (_isMouseDrag) {
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"mouseUp"]) {
            NSEvent *event = [dic objectForKey:@"mouseUp"];
            [self mouseUp:event];
        }else if ([dic.allKeys containsObject:@"mouseDrag"]) {
            NSEvent *event = [dic objectForKey:@"mouseDrag"];
            [self mouseDragged:event];
        }
    }
}

#pragma mark - Accessors

- (void)setItemSize:(NSSize)itemSize {
	if (!NSEqualSizes(_itemSize, itemSize)) {
		_itemSize = itemSize;
		[self refreshGridViewAnimated:NO initialCall:NO];
	}
}

- (void)setScrollElasticity:(BOOL)scrollElasticity {
	_scrollElasticity = scrollElasticity;
	NSScrollView *scrollView = [self enclosingScrollView];
	if (_scrollElasticity) {
//		[scrollView setHorizontalScrollElasticity:NSScrollElasticityAllowed];
		[scrollView setVerticalScrollElasticity:NSScrollElasticityAllowed];
	}
	else {
		[scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
		[scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
	}
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	_backgroundColor = backgroundColor;
	[[self enclosingScrollView] setBackgroundColor:_backgroundColor];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
	_allowsMultipleSelection = allowsMultipleSelection;
	if (selectedItems.count > 0 && !allowsMultipleSelection) {
		[nc postNotificationName:CNGridViewDeSelectAllItemsNotification object:self];
		[selectedItems removeAllObjects];
	}
}

#pragma mark - Private Helper
- (void)_refreshInset {
	if (self.useCenterAlignment) {
		NSRect clippedRect  = [self clippedRect];
		NSUInteger columns  = [self columnsInGridView];
		_contentInset = floorf((clippedRect.size.width - columns * self.itemSize.width) / 2);
	}
	else {
		_contentInset = 0;
	}
}

- (void)updateVisibleRect {
	[self updateReuseableItems];
	[self updateVisibleItems];
    [self reloadSelecdImage];
	[self arrangeGridViewItemsAnimated:NO];
}

- (void)refreshGridViewAnimated:(BOOL)animated initialCall:(BOOL)initialCall {
	isInitialCall = initialCall;

	NSSize size = self.frame.size;
    NSUInteger allOverRows = [self allOverRowsInGridView];
	CGFloat newHeight = allOverRows * self.itemSize.height + _contentInset * 2 + 10;
    if (newHeight < self.enclosingScrollView.frame.size.height) {
        NSScrollView *scrollView = [self enclosingScrollView];
        newHeight = scrollView.frame.size.height;
    }
	if (ABS(newHeight - size.height) > 1) {
		size.height = newHeight;
		[super setFrameSize:size];
	}

//	[self _refreshInset];
//	__weak typeof(self) wSelf = self;
    CNGridView *wSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
	    [wSelf _refreshInset];
	    [wSelf updateReuseableItems];
	    [wSelf updateVisibleItems];
	    [wSelf arrangeGridViewItemsAnimated:animated];
	});
}

- (void)updateReuseableItems {
	//Do not mark items as reusable unless there are no selected items in the grid as recycling items when doing range multiselect
	if (self.selectedIndexes.count == 0) {
		NSRange visibleItemRange = [self visibleItemRange];

		[[keyedVisibleItems allValues] enumerateObjectsUsingBlock: ^(CNGridViewItem *item, NSUInteger idx, BOOL *stop) {
		    if (!NSLocationInRange(item.index, visibleItemRange) /*&& [item isReuseable]*/) {
		        [keyedVisibleItems removeObjectForKey:@(item.index)];
		        [item removeFromSuperview];
//		        [item prepareForReuse];
//
//		        NSMutableSet *reuseQueue = [reuseableItems objectForKey:item.reuseIdentifier];
//		        if (reuseQueue == nil) {
//					reuseQueue = [NSMutableSet set];
//                }
//		        [reuseQueue addObject:item];
////		        reuseableItems[item.reuseIdentifier] = reuseQueue;
//                [reuseableItems setObject:reuseQueue forKey:item.reuseIdentifier];
                [reuseableItems setObject:item forKey:@(item.index)];
			}
		}];
	}
}

- (void)updateVisibleItems {
	NSRange visibleItemRange = [self visibleItemRange];
	NSMutableIndexSet *visibleItemIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:visibleItemRange];

	[visibleItemIndexes removeIndexes:[self indexesForVisibleItems]];

	// update all visible items
    if (visibleItemIndexes.count > 0) {
        [self gridViewCancelAllOperations:self];
    }
	[visibleItemIndexes enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
	    CNGridViewItem *item = [self gridView:self itemAtIndex:idx inSection:0];
	    if (item) {
	        item.index = idx;
	        if (isInitialCall) {
	            [item setAlphaValue:0.0];
	            [item setFrame:[self rectForItemAtIndex:idx]];
			}
	        [keyedVisibleItems setObject:item forKey:@(item.index)];
	        [self addSubview:item];
		}
	}];
}

- (NSIndexSet *)indexesForVisibleItems {
	__block NSMutableIndexSet *indexesForVisibleItems = [[[NSMutableIndexSet alloc] init] autorelease];
	[keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, CNGridViewItem *item, BOOL *stop) {
	    [indexesForVisibleItems addIndex:item.index];
	}];
	return indexesForVisibleItems;
}

- (void)arrangeGridViewItemsAnimated:(BOOL)animated {
	// on initial call (aka application startup) we will fade all items (after loading it) in
	if (isInitialCall && [keyedVisibleItems count] > 0) {
		isInitialCall = NO;

		[[NSAnimationContext currentContext] setDuration:0.35];
		[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
		    [keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, CNGridViewItem *item, BOOL *stop) {
		        [[item animator] setAlphaValue:1.0];
			}];
		} completionHandler:nil];
	}

	else if ([keyedVisibleItems count] > 0) {
		[[NSAnimationContext currentContext] setDuration:(animated ? 0.15 : 0.0)];
		[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
		    [keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, CNGridViewItem *item, BOOL *stop) {
		        NSRect newRect = [self rectForItemAtIndex:item.index];
		        [[item animator] setFrame:newRect];
			}];
		} completionHandler:nil];
	}
}

- (NSRange)visibleItemRange {
	NSRect clippedRect  = [self clippedRect];
	NSUInteger columns  = [self columnsInGridView];
	NSUInteger rows     = [self visibleRowsInGridView];

	NSUInteger rangeStart = 0;
	if (clippedRect.origin.y > (self.itemSize.height)) {
		rangeStart = (ceilf(clippedRect.origin.y / (self.itemSize.height)) * columns) - columns;
	}
	NSUInteger rangeLength = MIN(numberOfItems, (columns * rows) + columns);
	rangeLength = ((rangeStart + rangeLength) > numberOfItems ? numberOfItems - rangeStart : rangeLength);

	NSRange rangeForVisibleRect = NSMakeRange(rangeStart, rangeLength);
	return rangeForVisibleRect;
}

- (NSRect)rectForItemAtIndex:(NSUInteger)index {
	NSUInteger columns = [self columnsInGridView];
	NSRect itemRect = NSMakeRect((index % columns) * self.itemSize.width + _contentInset,
	                             ((index - (index % columns)) / columns) * self.itemSize.height + _contentInset,
	                             self.itemSize.width +10,
	                             self.itemSize.height);
	return itemRect;
}

- (NSRect)rectForSelectedItems:(NSMutableDictionary *)items {
    NSUInteger columns = [self columnsInGridView];
    int maxIndex = [[items.allKeys valueForKeyPath:@"@max.intValue"] intValue];
    int minIndex = [[items.allKeys valueForKeyPath:@"@min.intValue"] intValue];
    
    NSRect itemRect1 = NSMakeRect((minIndex % columns) * self.itemSize.width + _contentInset, ((minIndex - (minIndex % columns)) / columns) * self.itemSize.height + _contentInset,self.itemSize.width +10,self.itemSize.height);
    
    NSRect itemRect2 = NSMakeRect((maxIndex % columns) * self.itemSize.width + _contentInset, ((maxIndex - (maxIndex % columns)) / columns) * self.itemSize.height + _contentInset,self.itemSize.width +10,self.itemSize.height);
    NSRect rect = NSMakeRect(itemRect1.origin.x,itemRect2.origin.y , itemRect2.origin.x + itemRect2.size.width - itemRect1.origin.x, itemRect1.origin.y + itemRect1.size.height - itemRect2.origin.y);

    return rect;
}

- (NSUInteger)columnsInGridView {
	NSRect visibleRect  = [self clippedRect];
	NSUInteger columns = floorf((float)NSWidth(visibleRect) / (self.itemSize.width));
	columns = (columns < 1 ? 1 : columns);
	return columns;
}

- (NSUInteger)allOverRowsInGridView {
	NSUInteger allOverRows = ceilf((float)numberOfItems / [self columnsInGridView]);
	return allOverRows;
}

- (NSUInteger)visibleRowsInGridView {
	NSRect visibleRect  = [self clippedRect];
	NSUInteger visibleRows = ceilf((float)NSHeight(visibleRect) / self.itemSize.height);
	return visibleRows;
}

- (NSRect)clippedRect {
//    NSRect rect = [[[self enclosingScrollView] contentView] bounds];
//    rect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 2000);
	return /*rect;/*/[[[self enclosingScrollView] contentView] bounds];
}

- (NSUInteger)indexForItemAtLocation:(NSPoint)location {
	NSPoint point = [self convertPoint:location fromView:nil];
	NSUInteger indexForItemAtLocation;
	if (point.x > ((self.itemSize.width) * [self columnsInGridView] + _contentInset)) {
		indexForItemAtLocation = NSNotFound;
	}else {
		NSUInteger currentColumn = floor((point.x - _contentInset) / self.itemSize.width);
		NSUInteger currentRow = floor((point.y - _contentInset) / self.itemSize.height);
		indexForItemAtLocation = currentRow * [self columnsInGridView] + currentColumn;
		indexForItemAtLocation = (indexForItemAtLocation > (numberOfItems - 1) ? NSNotFound : indexForItemAtLocation);
        
        //点击item之前的空隙，设为NSNotFound
        if (indexForItemAtLocation != NSNotFound) {
            NSRect curItemRect = [self rectForItemAtIndex:indexForItemAtLocation];
            float defaultInset = DefaultItemContentInset;
//            NSRect itemRect = NSMakeRect(curItemRect.origin.x + defaultInset, curItemRect.origin.y + defaultInset, curItemRect.size.width - defaultInset * 2, curItemRect.size.height - defaultInset * 2);
            CGRect itemRect = CGRectMake(curItemRect.origin.x + defaultInset, curItemRect.origin.y + defaultInset, curItemRect.size.width - defaultInset * 2, curItemRect.size.height - defaultInset * 2);
            CGPoint cgPoint = CGPointMake(point.x, point.y);
            if (!CGRectContainsPoint(itemRect, cgPoint)) {
                indexForItemAtLocation = NSNotFound;
            }
        }
	}
	return indexForItemAtLocation;
}

- (CNItemPoint)locationForItemAtIndex:(NSUInteger)itemIndex {
	NSUInteger columnsInGridView = [self columnsInGridView];
	NSUInteger row = floor(itemIndex / columnsInGridView) + 1;
	NSUInteger column = itemIndex - floor((row - 1) * columnsInGridView) + 1;
	CNItemPoint location = CNMakeItemPoint(column, row);
	return location;
}

#pragma mark - Creating GridView Items

- (id)dequeueReusableItemWithIdentifier:(id)identifier {
	CNGridViewItem *reusableItem = nil;
//	NSMutableSet *reuseQueue = [reuseableItems objectForKey:identifier];//reuseableItems[identifier];
//	if (reuseQueue != nil && [reuseQueue count] > 0) {
//		reusableItem = [reuseQueue anyObject];
//		[reuseQueue removeObject:reusableItem];
////		reuseableItems[identifier] = reuseQueue;
//        [reuseableItems setObject:reuseQueue forKey:identifier];
//		reusableItem.representedObject = nil;
//	}
    
    reusableItem = [reuseableItems objectForKey:identifier];
    
	return reusableItem;
}

#pragma mark - Reloading GridView Data

- (void)reloadData {
	[self reloadDataAnimated:NO];
}

- (void)reloadDataAnimated:(BOOL)animated {
	numberOfItems = [self gridView:self numberOfItemsInSection:0];
	[keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
	    [(CNGridViewItemBase *)obj removeFromSuperview];
	}];
	[keyedVisibleItems removeAllObjects];
	[reuseableItems removeAllObjects];
	[self refreshGridViewAnimated:animated initialCall:YES];
}

-(void)reloadMinSelecdImage{
//    numberOfItems = [self gridView:self numberOfItemsInSection:0];
	[keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
//        if ([(CNGridViewItem *)obj selected] == YES) {
//            [(CNGridViewItem *)obj setSeledImg:[NSImage imageNamed:@"app_photo_sel"]];
//        }
//        else {
//            [(CNGridViewItem *)obj setSeledImg:nil];
//        }
        [(CNGridViewItem *)obj setNeedsDisplay:YES];
	}];
}

- (void)reloadSelecdImage{
//	numberOfItems = [self gridView:self numberOfItemsInSection:0];
	[keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
//        if ([(CNGridViewItem *)obj selected] == YES) {
//            [(CNGridViewItem *)obj setSeledImg:[NSImage imageNamed:@"photo_sel"]];
//        }else {
//            [(CNGridViewItem *)obj setSeledImg:nil];
//        }
        [(CNGridViewItem *)obj setNeedsDisplay:YES];
	}];
}

//- (void)reloadDataAnimated:(BOOL)animated {
//	numberOfItems = [self gridView:self numberOfItemsInSection:0];
//	[keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
//        //	    [(CNGridViewItemBase *)obj removeFromSuperview];
//        if ([(CNGridViewItem *)obj selected] == YES) {
//            [(CNGridViewItem *)obj setSeledImg:[NSImage imageNamed:@"photo_sel"]];
//        }else {
//            [(CNGridViewItem *)obj setSeledImg:nil];
//        }
//        [(CNGridViewItem *)obj setNeedsDisplay:YES];
//	}];
//    //	[keyedVisibleItems removeAllObjects];
//    //	[reuseableItems removeAllObjects];
//    //	[self refreshGridViewAnimated:animated initialCall:YES];
//}

#pragma mark - animating KVO changes

- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated {
	NSUInteger count = keyedVisibleItems.count;
	if (count) {
		NSMutableArray *affected = [NSMutableArray arrayWithCapacity:count];
		// adjust the index
		[[keyedVisibleItems allValues] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		    CNGridViewItemBase *item = (CNGridViewItemBase *)obj;
		    NSUInteger i = item.index;
		    if (i >= index) {
		        NSUInteger acount = affected.count;
		        NSUInteger insertPos = acount;
		        for (NSUInteger j = 0; j < acount; j++) {
		            CNGridViewItemBase *p = [affected objectAtIndex:j];
		            if (i > p.index) {
		                insertPos = j;
		                break;
					}
				}
		        [affected insertObject:item atIndex:insertPos];
			}
		}];

		if (affected.count) {
			for (CNGridViewItemBase *item in affected) {
				NSInteger index = item.index;
				NSInteger newIndex = index + 1;

				[keyedVisibleItems removeObjectForKey:@(index)];
				[keyedVisibleItems setObject:item forKey:@(newIndex)];
				item.index = newIndex;
			}
			if (animated) {
				[[NSAnimationContext currentContext] setDuration:(animated ? 0.15 : 0.0)];
				[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
				    for (CNGridViewItemBase * item in affected) {
				        NSInteger index = item.index;
				        NSRect newRect = [self rectForItemAtIndex:index];
				        [[item animator] setFrame:newRect];
					}
				} completionHandler:nil];
			}
			else {
				for (CNGridViewItemBase *item in affected) {
					NSInteger index = item.index;
					NSRect newRect = [self rectForItemAtIndex:index];
					[item setFrame:newRect];
				}
			}
		}
	}
	numberOfItems++;
	[self refreshGridViewAnimated:animated initialCall:YES];
}

- (void)insertItemsAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated {
	NSUInteger first = indexes.firstIndex;
	if (NSNotFound == first) {
		return;
	}

	NSUInteger count = keyedVisibleItems.count;
	if (count) {
		NSMutableArray *affected = [NSMutableArray arrayWithCapacity:count];
		// adjust the index
		[[keyedVisibleItems allValues] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		    CNGridViewItemBase *item = (CNGridViewItemBase *)obj;
		    NSUInteger i = item.index;
		    if (i >= first) {
		        NSUInteger acount = affected.count;
		        NSUInteger insertPos = acount;
		        for (NSUInteger j = 0; j < acount; j++) {
		            CNGridViewItemBase *p = [affected objectAtIndex:j];
		            if (i > p.index) {
		                insertPos = j;
		                break;
					}
				}
		        [affected insertObject:item atIndex:insertPos];
			}
		}];

		if (affected.count) {
			for (CNGridViewItemBase *item in affected) {
				NSInteger index = item.index;

				// check the number of new index before the index;
				__block NSUInteger ncount = 0;
				[indexes enumerateRangesUsingBlock: ^(NSRange range, BOOL *stop) {
				    if (range.location < index) {
				        ncount += range.length;
					}
				}];

				NSInteger newIndex = index + ncount;
				[keyedVisibleItems removeObjectForKey:@(index)];
				[keyedVisibleItems setObject:item forKey:@(newIndex)];
				item.index = newIndex;
			}
			if (animated) {
				[[NSAnimationContext currentContext] setDuration:(animated ? 0.15 : 0.0)];
				[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
				    for (CNGridViewItemBase * item in affected) {
				        NSInteger index = item.index;
				        NSRect newRect = [self rectForItemAtIndex:index];
				        [[item animator] setFrame:newRect];
					}
				} completionHandler:nil];
			}
			else {
				for (CNGridViewItemBase *item in affected) {
					NSInteger index = item.index;
					NSRect newRect = [self rectForItemAtIndex:index];
					[item setFrame:newRect];
				}
			}
		}
	}

	numberOfItems += indexes.count;
	[self refreshGridViewAnimated:animated initialCall:NO];
}

- (void)reloadItemsAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated {
	NSUInteger first = indexes.firstIndex;
	if (NSNotFound == first) {
		return;
	}

	NSUInteger count = keyedVisibleItems.count;
	if (count) {
		NSMutableArray *affected = [NSMutableArray arrayWithCapacity:count];
		// adjust the index
		[[keyedVisibleItems allValues] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		    CNGridViewItemBase *item = (CNGridViewItemBase *)obj;
		    NSUInteger i = item.index;
		    if ([indexes containsIndex:i]) {
		        NSUInteger acount = affected.count;
		        NSUInteger insertPos = acount;
		        for (NSUInteger j = 0; j < acount; j++) {
		            CNGridViewItemBase *p = [affected objectAtIndex:j];
		            if (i > p.index) {
		                insertPos = j;
		                break;
					}
				}
		        [affected insertObject:item atIndex:insertPos];
			}
		}];

		if (affected.count) {
			for (CNGridViewItemBase *item in affected) {
				NSInteger index = item.index;
				[keyedVisibleItems removeObjectForKey:@(index)];
			}
			if (animated) {
				[[NSAnimationContext currentContext] setDuration:(animated ? 0.15 : 0.0)];
				[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
				    for (CNGridViewItemBase * item in affected) {
				        [item setAlphaValue:1.0];
					}
				} completionHandler: ^() {
				    for (CNGridViewItemBase * item in affected) {
				        [item removeFromSuperview];
					}
				}];
			}
			else {
				for (CNGridViewItemBase *item in affected) {
					NSInteger index = item.index;
					NSRect newRect = [self rectForItemAtIndex:index];
					[item setFrame:newRect];
				}
			}
		}
	}

	isInitialCall = YES;
	[self refreshGridViewAnimated:animated initialCall:NO];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated {
	NSUInteger first = indexes.firstIndex;
	if (NSNotFound == first) {
		return;
	}

	NSUInteger count = keyedVisibleItems.count;
	if (count) {
		NSMutableArray *affected = [NSMutableArray arrayWithCapacity:count];
		// adjust the index
		[[keyedVisibleItems allValues] enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		    CNGridViewItemBase *item = (CNGridViewItemBase *)obj;
		    NSUInteger i = item.index;
		    if (i >= first) {
		        NSUInteger acount = affected.count;
		        NSUInteger insertPos = acount;
		        for (NSUInteger j = 0; j < acount; j++) {
		            CNGridViewItemBase *p = [affected objectAtIndex:j];
		            if (i > p.index) {
		                insertPos = j;
		                break;
					}
				}
		        [affected insertObject:item atIndex:insertPos];
			}
		}];

		if (affected.count) {
			for (CNGridViewItemBase *item in affected) {
				NSInteger index = item.index;
				[keyedVisibleItems removeObjectForKey:@(index)];
			}
			if (animated) {
				[[NSAnimationContext currentContext] setDuration:(animated ? 0.15 : 0.0)];
				[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
				    for (CNGridViewItemBase * item in affected) {
				        [item setAlphaValue:1.0];
					}

				} completionHandler: ^() {
				    for (CNGridViewItemBase * item in affected) {
				        [item removeFromSuperview];
					}
				}];
			}
			else {
				for (CNGridViewItemBase *item in affected) {
					[item removeFromSuperview];
					[item prepareForReuse];
					NSString *cellID = item.identifier;
					NSMutableSet *reuseQueue =[reuseableItems objectForKey:cellID]; //reuseableItems[cellID];
					if (reuseQueue == nil)
						reuseQueue = [NSMutableSet set];
					[reuseQueue addObject:item];
//                    reuseableItems[cellID] = reuseQueue;
                    [reuseableItems setObject:reuseQueue forKey:cellID];
				}
			}
		}
	}

	numberOfItems -= indexes.count;
	[self refreshGridViewAnimated:animated initialCall:NO];
}

- (void)beginUpdates {
	// no function at the moment
	// just to please the code ported from tableview
}

- (void)endUpdates {
	// no function at the moment
	// just to please the code ported from tableview
}

#pragma mark - Selection Handling

- (void)hoverItemAtIndex:(NSInteger)index {
	// inform the delegate
	[self gridView:self willHoverItemAtIndex:index inSection:0];

	lastHoveredIndex = index;
	CNGridViewItem *item = [keyedVisibleItems objectForKey:[NSNumber numberWithInteger:index]];//keyedVisibleItems[@(index)];
	item.hovered = YES;
}

- (void)unHoverItemAtIndex:(NSInteger)index {
	// inform the delegate
	[self gridView:self willUnhoverItemAtIndex:index inSection:0];

	CNGridViewItem *item = [keyedVisibleItems objectForKey:[NSNumber numberWithInteger:index]];//keyedVisibleItems[@(index)];
	item.hovered = NO;
}

- (void)selectItemAtIndex:(NSUInteger)selectedItemIndex usingModifierFlags:(NSUInteger)modifierFlags {
	if (selectedItemIndex == NSNotFound)
		return;

	CNGridViewItem *gridViewItem = nil;
    
    //选择另一个，取消其他
    if (!_allowClickMultipleSelection) {
        if (lastSelectedItemIndex != NSNotFound && lastSelectedItemIndex != selectedItemIndex) {
            gridViewItem = keyedVisibleItems[@(lastSelectedItemIndex)];
            [self deSelectItem:gridViewItem];
        }
    }
    
	gridViewItem = [keyedVisibleItems objectForKey:[NSNumber numberWithInteger:selectedItemIndex]];//keyedVisibleItems[@(selectedItemIndex)];

	if (gridViewItem) {
		if (self.allowsMultipleSelection) {
            
            if (!_allowClickMultipleSelection) {
                //选中方式为点击一个取消其他，按住command key和shift key可以多选
                if (!gridViewItem.selected && !(modifierFlags & NSShiftKeyMask) && !(modifierFlags & NSCommandKeyMask)) {
                    //Select a single item and deselect all other items when the shift or command keys are NOT pressed.
                    [self deselectAllItems];//取消全部选中
                    [self selectItem:gridViewItem];
                }
                
                else if (gridViewItem.selected && modifierFlags & NSCommandKeyMask) {
                    //If the item clicked is already selected and the command key is down, remove it from the selection.
                    [self deSelectItem:gridViewItem];
                }
                
                else if (!gridViewItem.selected && modifierFlags & NSCommandKeyMask) {
                    //If the item clicked is NOT selected and the command key is down, add it to the selection
                    [self selectItem:gridViewItem];
                }
                
                else if (modifierFlags & NSShiftKeyMask) {
                    //Select a range of items between the current selection and the item that was clicked when the shift key is down.
                    NSUInteger lastIndex = [[self selectedIndexes] lastIndex];
                    
                    //If there were no previous items selected then
                    if (lastIndex == NSNotFound) {
                        [self selectItem:gridViewItem];
                    }
                    else {
                        //Find range to select
                        NSUInteger high;
                        NSUInteger low;
                        
                        if (((NSInteger)lastIndex - (NSInteger)selectedItemIndex) < 0) {
                            high = selectedItemIndex;
                            low = lastIndex;
                        }
                        else {
                            high = lastIndex;
                            low = selectedItemIndex;
                        }
                        high++; //Avoid off by one
                        
                        //Select all the items that are not already selected
                        for (NSUInteger idx = low; idx < high; idx++) {
                            gridViewItem = keyedVisibleItems[@(idx)];
                            if (gridViewItem && !gridViewItem.selected) {
                                [self selectItem:gridViewItem];
                            }
                        }
                    }
                }
                
                else if (gridViewItem.selected) {
                    [self deselectAllItems];
                    [self selectItem:gridViewItem];
                }
            } else {
                //选中方式为点击选中，在点击同一个就取消，点击另一个继续选中，其他不取消；
                if (gridViewItem.selected && modifierFlags) {
                    [self deSelectItem:gridViewItem];
                }else {
                    [self selectItem:gridViewItem];
                }
            }
		}

		else {
			if (modifierFlags & NSCommandKeyMask) {
				if (gridViewItem.selected) {
					[self deSelectItem:gridViewItem];
				}
				else {
					[self selectItem:gridViewItem];
				}
			}
			else {
				[self selectItem:gridViewItem];
			}
		}
		lastSelectedItemIndex = (self.allowsMultipleSelection ? NSNotFound : selectedItemIndex);
	}
}

- (void)selectAllItems {
    NSRange visibleItemRange = [self visibleItemRange];
    NSMutableIndexSet *visibleItemIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:visibleItemRange];
    [visibleItemIndexes enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
        CNGridViewItem *item = [self gridView:self itemAtIndex:idx inSection:0];
        item.selected = YES;
        item.index = idx;
        [nc postNotificationName:CNGridViewSelectAllItemsNotification object:item];
    }];
    
    [keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [(CNGridViewItem *)obj setSelected:YES];
    }];
    
//	NSUInteger number = [self gridView:self numberOfItemsInSection:0];
//	for (NSUInteger idx = 0; idx < number; idx++) {
//		CNGridViewItem *item = [self gridView:self itemAtIndex:idx inSection:0];
//		item.selected = YES;
//		item.index = idx;
////		[selectedItems setObject:item forKey:@(item.index)];
//        [nc postNotificationName:CNGridViewSelectAllItemsNotification object:self.subviews];
//	}
}

- (void)deselectAllItems {
//	if (selectedItems.count > 0) {
		// inform the delegate
//		[self gridView:self willDeselectAllItems:[self selectedItems]];
		[nc postNotificationName:CNGridViewDeSelectAllItemsNotification object:self];
		[selectedItems removeAllObjects];

		// inform the delegate
		[self gridViewDidDeselectAllItems:self];
//	}
}

- (void)selectItem:(CNGridViewItem *)theItem {
//    if (![selectedItems objectForKey:[NSNumber numberWithInteger:theItem.index]]) {
		// inform the delegate
//		[self gridView:self willSelectItemAtIndex:theItem.index inSection:0];

		theItem.selected = YES;
//		selectedItems[@(theItem.index)] = theItem;
        [selectedItems setObject:theItem forKey:[NSNumber numberWithInteger:theItem.index]];
		// inform the delegate
		[self gridView:self didSelectItemAtIndex:theItem.index inSection:0];
//	}
}

- (void)deSelectItem:(CNGridViewItem *)theItem {
//	if ([selectedItems objectForKey:[NSNumber numberWithInteger:theItem.index]]) {
		// inform the delegate
//		[self gridView:self willDeselectItemAtIndex:theItem.index inSection:0];

		theItem.selected = NO;
		[selectedItems removeObjectForKey:@(theItem.index)];

		// inform the delegate
		[self gridView:self didDeselectItemAtIndex:theItem.index inSection:0];
//	}
}

- (NSArray *)selectedItems {
	return [selectedItems allValues];
}

- (NSArray *)keyedVisibleItems {
    return [keyedVisibleItems allValues];
}

- (NSIndexSet *)selectedIndexes {
	NSMutableIndexSet *mutableIndex = [NSMutableIndexSet indexSet];
	for (CNGridViewItem *gridItem in [self selectedItems]) {
		[mutableIndex addIndex:gridItem.index];
	}
	return mutableIndex;
}

- (NSIndexSet *)visibleIndexes {
	return [NSIndexSet indexSetWithIndexesInRange:[self visibleItemRange]];
}

- (void)handleClicks:(NSTimer *)theTimer {
	switch ([clickEvents count]) {
		case CNSingleClick: {
			NSEvent *theEvent = [clickEvents lastObject];
			NSUInteger index = [self indexForItemAtLocation:theEvent.locationInWindow];
			[self handleSingleClickForItemAtIndex:index];
			break;
		}

		case CNDoubleClick: {
			NSUInteger indexClick1 = [self indexForItemAtLocation:[[clickEvents objectAtIndex:0] locationInWindow]];
			NSUInteger indexClick2 = [self indexForItemAtLocation:[[clickEvents objectAtIndex:1] locationInWindow]];
			if (indexClick1 == indexClick2) {
				[self handleDoubleClickForItemAtIndex:indexClick1];
                [clickEvents removeAllObjects];
			}
			else {
				[self handleSingleClickForItemAtIndex:indexClick1];
				[self handleSingleClickForItemAtIndex:indexClick2];
			}
			break;
		}

		case CNTrippleClick: {
			NSUInteger indexClick1 = [self indexForItemAtLocation:[[clickEvents objectAtIndex:0] locationInWindow]];
			NSUInteger indexClick2 = [self indexForItemAtLocation:[[clickEvents objectAtIndex:1] locationInWindow]];
			NSUInteger indexClick3 = [self indexForItemAtLocation:[[clickEvents objectAtIndex:2] locationInWindow]];
			if (indexClick1 == indexClick2 == indexClick3) {
				[self handleDoubleClickForItemAtIndex:indexClick1];
			}

			else if ((indexClick1 == indexClick2) && (indexClick1 != indexClick3)) {
				[self handleDoubleClickForItemAtIndex:indexClick1];
				[self handleSingleClickForItemAtIndex:indexClick3];
			}

			else if ((indexClick1 != indexClick2) && (indexClick2 == indexClick3)) {
				[self handleSingleClickForItemAtIndex:indexClick1];
				[self handleDoubleClickForItemAtIndex:indexClick3];
			}

			else if (indexClick1 != indexClick2 != indexClick3) {
				[self handleSingleClickForItemAtIndex:indexClick1];
				[self handleSingleClickForItemAtIndex:indexClick2];
				[self handleSingleClickForItemAtIndex:indexClick3];
			}
			break;
		}
	}
	[clickEvents removeAllObjects];
}

- (void)handleSingleClickForItemAtIndex:(NSUInteger)selectedItemIndex {
	if (selectedItemIndex == NSNotFound)
		return;

	// inform the delegate
	[self gridView:self didClickItemAtIndex:selectedItemIndex inSection:0];
}

- (void)handleDoubleClickForItemAtIndex:(NSUInteger)selectedItemIndex {
	if (selectedItemIndex == NSNotFound)
		return;

	// inform the delegate
	[self gridView:self didDoubleClickItemAtIndex:selectedItemIndex inSection:0];
}

- (void)drawSelectionFrameForMousePointerAtLocation:(NSPoint)location {
	if (!selectionFrameView) {
		selectionFrameInitialPoint = location;
		selectionFrameView = [[CNSelectionFrameView alloc] init];
		selectionFrameView.frame = NSMakeRect(location.x, location.y, 0, 0);
		if (![self containsSubView:selectionFrameView])
			[self addSubview:selectionFrameView];
	}else {
//		NSRect clippedRect = [self clippedRect];
        NSRect selfRect = self.frame;//clippedRect;//NSMakeRect(clippedRect.origin.x, clippedRect.origin.y, self.frame.size.width, self.frame.size.height);
		NSUInteger columnsInGridView = [self columnsInGridView];

		CGFloat posX = ceil((location.x > selectionFrameInitialPoint.x ? selectionFrameInitialPoint.x : location.x));
		posX = (posX < NSMinX(selfRect) ? NSMinX(selfRect) : posX);

		CGFloat posY = ceil((location.y > selectionFrameInitialPoint.y ? selectionFrameInitialPoint.y : location.y));
		posY = (posY < NSMinY(selfRect) ? NSMinY(selfRect) : posY);

		CGFloat width = (location.x > selectionFrameInitialPoint.x ? location.x - selectionFrameInitialPoint.x : selectionFrameInitialPoint.x - posX);
		width = (posX + width >= (columnsInGridView * self.itemSize.width) ? (columnsInGridView * self.itemSize.width) - posX - 1 : width);
        if (width < 0) {
            width = 0;
        }

		CGFloat height = (location.y > selectionFrameInitialPoint.y ? location.y - selectionFrameInitialPoint.y : selectionFrameInitialPoint.y - posY);
		height = (posY + height > NSMaxY(selfRect) ? NSMaxY(selfRect) - posY : height);
        if (height < 0) {
            height = 0;
        }

		NSRect selectionFrame = NSMakeRect(posX, posY, width, height);
		selectionFrameView.frame = selectionFrame;
//        NSLog(@"selectionFrame:%f  %f   %f   %f",posX, posY, width, height);
	}
}

- (NSUInteger)boundIndexForItemAtLocation:(NSPoint)location {
	NSPoint point = location;//[self convertPoint:location fromView:nil];
	NSUInteger indexForItemAtLocation;
	CGFloat currentWidth = (self.itemSize.width * [self columnsInGridView]);

	if (point.x > currentWidth)
		point.x = currentWidth;

	NSUInteger currentColumn = floor(point.x / self.itemSize.width);
	NSUInteger currentRow = floor(point.y / self.itemSize.height);
	indexForItemAtLocation = currentRow * [self columnsInGridView] + currentColumn;

	return indexForItemAtLocation;
}

- (void)selectItemsCoveredBySelectionFrame:(NSRect)selectionFrame usingModifierFlags:(NSUInteger)modifierFlags {
    float defaultInset = DefaultItemContentInset;
	NSUInteger topLeftItemIndex = [self boundIndexForItemAtLocation:NSMakePoint(NSMinX(selectionFrame) + defaultInset, NSMinY(selectionFrame) + defaultInset)];
	NSUInteger bottomRightItemIndex = [self boundIndexForItemAtLocation:NSMakePoint(NSMaxX(selectionFrame) - defaultInset, NSMaxY(selectionFrame) - defaultInset)];

	CNItemPoint topLeftItemPoint = [self locationForItemAtIndex:topLeftItemIndex];
	CNItemPoint bottomRightItemPoint = [self locationForItemAtIndex:bottomRightItemIndex];

	// handle all "by selection frame" selected items beeing now outside
	// the selection frame
	[[self indexesForVisibleItems] enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
#if 0  //用于选中框选部分 + 之前框选的部分
	    CNGridViewItem *selectedItem = [selectedItems objectForKey:[NSNumber numberWithInteger:idx]];
	    CNGridViewItem *selectionFrameItem = [selectedItems objectForKey:[NSNumber numberWithInteger:idx]];
#else //用于选中框选部分
        
        CNGridViewItem *selectedItem = selectedItems[@(idx)];
        CNGridViewItem *selectionFrameItem = selectedItemsBySelectionFrame[@(idx)];
#endif
	    if (selectionFrameItem) {
	        CNItemPoint itemPoint = [self locationForItemAtIndex:selectionFrameItem.index];

	        // handle all 'out of selection frame range' items
	        if ((itemPoint.row < topLeftItemPoint.row)              ||  // top edge out of range
	            (itemPoint.column > bottomRightItemPoint.column)    ||  // right edge out of range
	            (itemPoint.row > bottomRightItemPoint.row)          ||  // bottom edge out of range
	            (itemPoint.column < topLeftItemPoint.column)) {         // left edge out of range
	                                                                    // ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
	                                                                    // if it there is selected too. If it so, keep it untouched!

	            // so, the current item wasn't selected, we can restore its old state (to unselected)
	            if (![selectionFrameItem isEqual:selectedItem]) {
	                selectionFrameItem.selected = NO;
	                [selectedItemsBySelectionFrame removeObjectForKey:@(selectionFrameItem.index)];
				}

	            // the current item already was selected, so reselect it.
	            else {
	                selectionFrameItem.selected = YES;
                    [selectedItemsBySelectionFrame setObject:selectionFrameItem forKey:[NSNumber numberWithInteger:selectionFrameItem.index]];
//	                selectedItemsBySelectionFrame[@(selectionFrameItem.index)] = selectionFrameItem;
				}
			}
		}
	}];

	// Verify selection frame was inside gridded area
	BOOL validSelectionFrame = (NSWidth(selectionFrame) > 0) && (NSHeight(selectionFrame) > 0);

	NSUInteger columnsInGridView = [self columnsInGridView];
	NSUInteger allOverRows = ceilf((float)numberOfItems / columnsInGridView);

	topLeftItemPoint.row = MIN(topLeftItemPoint.row, allOverRows);
	topLeftItemPoint.column = MIN(topLeftItemPoint.column, columnsInGridView);
	bottomRightItemPoint.row = MIN(bottomRightItemPoint.row, allOverRows);
	bottomRightItemPoint.column = MIN(bottomRightItemPoint.column, columnsInGridView);

	// update all items that needs to be selected
	for (NSUInteger row = topLeftItemPoint.row; row <= bottomRightItemPoint.row; row++) {
		for (NSUInteger col = topLeftItemPoint.column; col <= bottomRightItemPoint.column; col++) {
			NSUInteger itemIndex = ((row - 1) * columnsInGridView + col) - 1;
//			CNGridViewItem *selectedItem = [selectedItems objectForKey:[NSNumber numberWithInteger:itemIndex]];//selectedItems[@(itemIndex)];
//			CNGridViewItem *itemToSelect = [keyedVisibleItems objectForKey:[NSNumber numberWithInteger:itemIndex]];//keyedVisibleItems[@(itemIndex)];
            CNGridViewItem *selectedItem = selectedItems[@(itemIndex)];
            CNGridViewItem *itemToSelect = keyedVisibleItems[@(itemIndex)];
			if (itemToSelect && validSelectionFrame) {
                [selectedItemsBySelectionFrame setObject:itemToSelect forKey:[NSNumber numberWithInteger:itemToSelect.index]];
//				selectedItemsBySelectionFrame[@(itemToSelect.index)] = itemToSelect;
				if (modifierFlags & NSCommandKeyMask) {
					itemToSelect.selected = ([itemToSelect isEqual:selectedItem] ? NO : YES);
				}
				else {
					itemToSelect.selected = YES;
				}
			}
		}
	}
}


#pragma mark - drop
- (void)registerForDraggedTypes {
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType, NSFilenamesPboardType,NSStringPboardType,nil]];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingEntered");
    if (_allowsDragAndDrop) {
        NSPasteboard *pboard = [sender draggingPasteboard];
        if ([[pboard types] containsObject:NSFilenamesPboardType]) {
            NSArray *paths = [pboard propertyListForType:NSFilenamesPboardType];
            for (NSString *path in paths) {
                return NSDragOperationCopy;
            }
        }
        return NSDragOperationEvery;
    }else {
        return NSDragOperationNone;
    }
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingExited");
    //    NSPoint mouse    = [self convertPoint:[sender draggingLocation] fromView:nil];
    //    NSUInteger index = [layoutManager indexOfItemAtPoint:mouse];
    //
    //    if (index == NSNotFound) {
    //        [self setNeedsDisplayInRect:[layoutManager rectOfItemAtIndex:dragHoverIndex]];
    //        [self setDragHoverIndex:NSNotFound];
    //
    //        if ([_delegate respondsToSelector:@selector(collectionView:draggingExited:)])
    //            [_delegate collectionView:self draggingExited:sender];
    //    }
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender  {
//    NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pastboard = [sender draggingPasteboard];
    NSArray *boarditemsArray = [pastboard pasteboardItems];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSPasteboardItem *item in boarditemsArray) {
        NSString *urlPath = [item stringForType:@"public.file-url"];
        NSURL *url = [NSURL URLWithString:urlPath];
        NSString *path = [url relativePath];
        if(![StringHelper stringIsNilOrEmpty:path]) {
            [itemArray addObject:path];
        }
    }
    if (itemArray.count >0) {
        if ([_delegate respondsToSelector:@selector(dropToCollectionViewTableViewWithpaths:)]) {
            [_delegate dropToCollectionViewTableViewWithpaths:itemArray];
        }
        return YES;
    }else{
        return NO;
    }

}



#pragma mark - drag & drop
- (void)initiateDraggingSessionWithEvent:(NSEvent *)anEvent {
    NSLog(@"initiateDraggingSessionWithEvent");
    NSUInteger index = [self indexForItemAtLocation:anEvent.locationInWindow];
    if (index == NSNotFound) {
        return;
    }
    
//    //设置拖拽时，鼠标点击的那个选中；
//    CNGridViewItem *gridViewItem = nil;
//    gridViewItem = keyedVisibleItems[@(index)];
//    if (gridViewItem) {
//        [self selectItem:gridViewItem];
//    }

    NSRect itemRect = [self rectForItemAtIndex:index];
//    NSView *currentView = [[self viewControllerForItemAtIndex:index] view];
//    NSData *imageData   = [gridViewItem dataWithPDFInsideRect:NSMakeRect(0,0,NSWidth(itemRect),NSHeight(itemRect))];
//    NSImage *pdfImage   = /*[NSImage imageNamed:@"creeps_0001"];/*/[[[NSImage alloc] initWithData:imageData] autorelease];
//    NSImage *dragImage  = [[[NSImage alloc] initWithSize:[pdfImage size]] autorelease];
//    
//    if ([dragImage size].width > 0 && [dragImage size].height > 0) {
//        [dragImage lockFocus];
//        [pdfImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.8];
//        [dragImage unlockFocus];
//    }
    
//    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];

//    [pasteboard setPropertyList:[NSArray arrayWithObject:@"Export"] forType:NSFilesPromisePboardType];
//    [self delegateWriteIndexes:selectionIndexes toPasteboard:pasteboard];
//    [self retain];
    [self dragPromisedFilesOfTypes:[NSArray arrayWithObject:NSPasteboardTypeTIFF] fromRect:itemRect source:self slideBack:YES event:anEvent];
//    [self dragImage:dragImage
//                 at:NSMakePoint(NSMinX(itemRect), NSMaxY(itemRect))
//             offset:NSMakeSize(0, 0)
//              event:anEvent
//         pasteboard:pasteboard
//             source:self
//          slideBack:YES];
}

- (void)dragImage:(NSImage *)anImage at:(NSPoint)viewLocation offset:(NSSize)initialOffset event:(NSEvent *)event pasteboard:(NSPasteboard *)pboard source:(id)sourceObj slideBack:(BOOL)slideFlag {
    NSLog(@"dragImage offset");
    
    NSUInteger index = [self indexForItemAtLocation:event.locationInWindow];
    if (index == NSNotFound) {
        return;
    }
    
    //设置拖拽时，鼠标点击的那个选中；
    CNGridViewItem *gridViewItem = nil;
    gridViewItem = [keyedVisibleItems objectForKey:[NSNumber numberWithInteger:index]];//keyedVisibleItems[@(index)];
    if (gridViewItem) {
        [self selectItem:gridViewItem];
    }
    
    NSImage *dragImage = [self gridView:self draggingImageForItemsAtIndexes:[self selectedIndexes] withEvent:event];
    if (dragImage == nil) {
        
//        NSRect itemRect     = [self rectForItemAtIndex:index];

        NSData *imageData   = [gridViewItem dataWithPDFInsideRect:NSMakeRect(gridViewItem.seledImgFrame.origin.x,gridViewItem.seledImgFrame.origin.y,gridViewItem.seledImgFrame.size.width,gridViewItem.seledImgFrame.size.height)];
        NSImage *pdfImage   = [[[NSImage alloc] initWithData:imageData] autorelease];
        

        NSData *dragData = [IMBHelper suchAsScalingImage:pdfImage width:gridViewItem.seledImgFrame.size.width height:gridViewItem.seledImgFrame.size.height];
        dragImage  = [[[NSImage alloc] initWithData:dragData] autorelease];
    }
    
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(dragImage.size.width, dragImage.size.height)];
    [scalingimage lockFocus];
    [[NSColor clearColor] setFill];
    NSRectFill(NSMakeRect(0, 0, scalingimage.size.width/1.5, scalingimage.size.height/1.5));
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
    [dragImage drawInRect:NSMakeRect(0, 0, scalingimage.size.width/1.5, scalingimage.size.height/1.5) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    NSArray *selectedArray = [self selectedItems];
    int count = (int)[selectedArray count];
    NSString *countstr = [NSString stringWithFormat:@"%d",count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:countstr?:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, str.length)];
    NSRect drawRect = NSMakeRect((scalingimage.size.width/1.5 - (str.size.width + 8))/2.0, (scalingimage.size.height/1.5 - (str.size.width + 8))/2.0, str.size.width + 8, str.size.width + 8);
    
    NSBezierPath *path = nil;
    path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:(str.size.width + 8)/2.0 yRadius:(str.size.width + 8)/2.0];
    
    [[NSColor redColor] setFill];
    [path fill];
    [[NSColor whiteColor] setStroke];
    [path stroke];
    [str drawInRect: NSMakeRect(drawRect.origin.x+4,drawRect.origin.y +(drawRect.size.height - str.size.height )/2.0 + 1, str.size.width+8, str.size.height)];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, dragImage.size.width/1.5, dragImage.size.height/1.5)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    NSImage *dragImage2 = [[[NSImage alloc] initWithData:tempdata] autorelease];
    
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    
    NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    NSPoint atPoint = NSMakePoint(point.x - dragImage2.size.width / 2, point.y + dragImage2.size.height / 2);
    [super dragImage:dragImage2 at:atPoint offset:initialOffset event:event pasteboard:pasteboard source:sourceObj slideBack:slideFlag];

    
}

- (void)draggedImage:(NSImage *)anImage beganAt:(NSPoint)aPoint {
    NSLog(@"draggedImage begin");
}

- (void)draggedImage:(NSImage *)anImage endedAt:(NSPoint)aPoint operation:(NSDragOperation)operation {
    if (operation == NSDragOperationCopy) {
        NSLog(@"draggedImage end NSDragOperationCopy");
    }else {
        NSLog(@"draggedImage end NSDragOperationCopy");
    }
}



//- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
//    NSLog(@"draggingUpdated");
////    if (dragHoverIndex != NSNotFound)
////        [self setNeedsDisplayInRect:[layoutManager rectOfItemAtIndex:dragHoverIndex]];
////    
////    NSPoint mouse    = [self convertPoint:[sender draggingLocation] fromView:nil];
////    NSUInteger index = [layoutManager indexOfItemAtPoint:mouse];
//    
//    NSDragOperation operation = NSDragOperationNone;
////    if ([sender draggingSource] == self) {
////        if ([selectionIndexes containsIndex:index])
////            [self setDragHoverIndex:NSNotFound];
////        else if ([self delegateCanDrop:sender onIndex:index]) {
////            [self setDragHoverIndex:index];
////            operation = NSDragOperationMove;
////        } else
////            [self setDragHoverIndex:NSNotFound];
////    } else {
////        if ([self delegateCanDrop:sender onIndex:index]) {
////            [self setDragHoverIndex:index];
////            operation = NSDragOperationCopy;
////        }
////    }http://longtimenoc.com/archives/cocoa-drag-and-drop-简单实现
////    https://msdn.microsoft.com/en-us/library/ms973845.aspx
////    if (dragHoverIndex != NSNotFound)
////        [self setNeedsDisplayInRect:[layoutManager rectOfItemAtIndex:dragHoverIndex]];
//    
//    return operation;
//}

- (void)draggingEnded:(id <NSDraggingInfo>)sender {
    NSLog(@"draggingEnded");
//    if (dragHoverIndex != NSNotFound)
//        [self setNeedsDisplayInRect:[layoutManager rectOfItemAtIndex:dragHoverIndex]];
//    
//    [self setDragHoverIndex:NSNotFound];
    
//    if ([_delegate respondsToSelector:@selector(collectionView:draggingEnded:)])
//        [_delegate collectionView:self draggingEnded:sender];
}





- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    NSLog(@"dragging Session");
    switch (context) {
        case NSDraggingContextOutsideApplication:
            return NSDragOperationCopy;
            break;
        case NSDraggingContextWithinApplication:
            return NSDragOperationNone;
            break;
        default:
            return NSDragOperationCopy;
            break;
    }
}

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination {
    NSLog(@"names Of Promised Files Dropped At Destination:%@",dropDestination.path);
    return [self gridView:self namesOfPromisedFilesDroppedAtDestination:dropDestination forDraggedItemsAtIndexes:[self selectedIndexes]];
}

- (void)determineDragTimer:(NSTimer *)timer {
    _isDrag = YES;
    NSEvent *theEvent = timer.userInfo;
    [self initiateDraggingSessionWithEvent:theEvent];
    
    if (_dragTimer != nil) {
        [_dragTimer setFireDate:[NSDate distantFuture]];
        [_dragTimer invalidate];
        _dragTimer = nil;
    }
}

#pragma mark - Managing the Content

- (NSUInteger)numberOfVisibleItems {
	return [keyedVisibleItems count];
}

#pragma mark - NSView

- (BOOL)isFlipped {
	return YES;
}

- (void)setFrame:(NSRect)frameRect {
	BOOL animated = NO;//(self.frame.size.width == frameRect.size.width ? NO : YES);
	[super setFrame:frameRect];
	[self refreshGridViewAnimated:animated initialCall:NO];
}

- (void)updateTrackingAreas {
	if (gridViewTrackingArea) {
		[self removeTrackingArea:gridViewTrackingArea];
        [gridViewTrackingArea release];
        gridViewTrackingArea = nil;
    }
	gridViewTrackingArea = [[NSTrackingArea alloc] initWithRect:self.frame
	                                                    options:NSTrackingMouseMoved | NSTrackingActiveInKeyWindow
	                                                      owner:self
	                                                   userInfo:nil];
	[self addTrackingArea:gridViewTrackingArea];
}

#pragma mark - NSResponder

- (BOOL)canBecomeKeyView {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
	lastHoveredIndex = NSNotFound;
}

- (void)mouseMoved:(NSEvent *)theEvent {
//    NSLog(@"mouse move");
//    [self mouseUp:theEvent];
//	if (!self.useHover)
//		return;
//
//	NSUInteger hoverItemIndex = [self indexForItemAtLocation:theEvent.locationInWindow];
//	if (hoverItemIndex != NSNotFound || hoverItemIndex != lastHoveredIndex) {
//		// unhover the last hovered item
//		if (lastHoveredIndex != NSNotFound && lastHoveredIndex != hoverItemIndex) {
//			[self unHoverItemAtIndex:lastHoveredIndex];
//		}
//
//		// inform the delegate
//		if (lastHoveredIndex != hoverItemIndex) {
//			[self hoverItemAtIndex:hoverItemIndex];
//		}
//	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
//    NSLog(@"mouse Dragged");
    _isMouseDrag = YES;
    if (_dragTimer != nil) {
        [_dragTimer setFireDate:[NSDate distantFuture]];
        [_dragTimer invalidate];
        _dragTimer = nil;
    }
	if (!self.allowsMultipleSelection || !self.allowsMultipleSelectionWithDrag)
		return;

    [self autoscroll:theEvent];
	mouseHasDragged = YES;
	[NSCursor closedHandCursor];
    
	if (!abortSelection) {
        if (!_isDrag) {
            NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
            [self drawSelectionFrameForMousePointerAtLocation:location];
            [self selectItemsCoveredBySelectionFrame:selectionFrameView.frame usingModifierFlags:theEvent.modifierFlags];
        }
	}
    [super mouseDragged:theEvent];
//    [self initiateDraggingSessionWithEvent:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
//    NSLog(@"mouse Up");
//    if (_eventCount > 0) {
//        _eventCount --;
//        [NSEvent removeMonitor:_eventMonitor];
//    }

    _isMouseDrag = NO;
    if (_dragTimer != nil) {
        [_dragTimer setFireDate:[NSDate distantFuture]];
        [_dragTimer invalidate];
        _dragTimer = nil;
    }
	[NSCursor arrowCursor];

    _isDrag = NO;
    
	abortSelection = NO;
	// this happens just if we have multiselection ON and dragged the
	// mouse over items. In this case we have to handle this selection.
	if (self.allowsMultipleSelection && mouseHasDragged) {
		mouseHasDragged = NO;

		// remove selection frame
        if (selectionFrameView != nil) {
            [[selectionFrameView animator] setAlphaValue:0];
            [selectionFrameView removeFromSuperview];
            [selectionFrameView release];
            selectionFrameView = nil;
        }
        
//        id window = [[[[[[[[self superview] superview] superview] superview] superview] superview] superview] superview] ;
//        IMBNoTitleBarContentView *titlebarView = (IMBNoTitleBarContentView *)window;
//        IMBNoTitleBarWindow *titleBarWindow = (IMBNoTitleBarWindow *)titlebarView.window;
//        [titleBarWindow reloadNeedDisplayView];
		// catch all newly selected items that was selected by selection frame
		[selectedItemsBySelectionFrame enumerateKeysAndObjectsUsingBlock: ^(id key, CNGridViewItem *item, BOOL *stop) {
		    if ([item selected] == YES) {
		        [self selectItem:item];
			}else {
		        [self deSelectItem:item];
			}
		}];
		[selectedItemsBySelectionFrame removeAllObjects];
        
        NSLog(@"selectedItems.count:%lu",(unsigned long)selectedItems.count);
	}

	// otherwise it was a real click on an item
	else {
		[clickEvents addObject:theEvent];
		clickTimer = nil;
       //if (clickEvents.count == 2) {
            clickTimer = [NSTimer scheduledTimerWithTimeInterval:[NSEvent doubleClickInterval] target:self selector:@selector(handleClicks:) userInfo:nil repeats:NO];
       //}
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	if (!self.allowsSelection)
		return;
    
    _isDrag = NO;
    
	NSPoint location = [theEvent locationInWindow];
	NSUInteger index = [self indexForItemAtLocation:location];
   
    _eventNumber = theEvent.eventNumber;
    _presssureVal = theEvent.pressure;
	if (index != NSNotFound) {
        CNGridViewItem *keyGridViewItem = [keyedVisibleItems objectForKey:[NSNumber numberWithInteger:index]];

        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        NSRect rect;
        if (_isAppItem ) {
            rect = NSMakeRect(keyGridViewItem.frame.origin.x +18+2 , keyGridViewItem.frame.origin.y , 113, 113);
        }else if (_isPhotoView){
            rect = NSMakeRect(keyGridViewItem.frame.origin.x +18 , keyGridViewItem.frame.origin.y + 14 +20, 136, 136);
        }else if (_isFileManager){
            rect = NSMakeRect(keyGridViewItem.frame.origin.x + 32, keyGridViewItem.frame.origin.y + 36, 102, 100);
        }else{
            rect = NSMakeRect(keyGridViewItem.frame.origin.x +18 , keyGridViewItem.frame.origin.y + 14, 136, 136);
        }

        BOOL inner = NSMouseInRect(point, rect, [keyGridViewItem isFlipped]);
        if (inner) {
            //如果当前点击的index包含在之前选中的里面，选中的不改变
            //否则，选中当前点击的index
//            if ([[self selectedIndexes] containsIndex:index]) {
//                
//            }else {
                [self selectItemAtIndex:index usingModifierFlags:theEvent.modifierFlags];
//            }
            
            if (!self.allowsDragAndDrop || index == NSNotFound) {
                return;
            }
            
            if (_dragTimer != nil) {
                [_dragTimer setFireDate:[NSDate distantFuture]];
                [_dragTimer invalidate];
                _dragTimer = nil;
            }
            _dragTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(determineDragTimer:) userInfo:theEvent repeats:NO];
            
        }else {
            [self deselectAllItems];
        }
	}else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_HIDE_ICLOUDDETAIL object:nil];
		[self deselectAllItems];
	}
}

- (void)rightMouseDown:(NSEvent *)theEvent {
	NSPoint location = [theEvent locationInWindow];
	NSUInteger index = [self indexForItemAtLocation:location];

	if (index != NSNotFound) {
		NSIndexSet *indexSet = [self selectedIndexes];
		BOOL isClickInSelection = [indexSet containsIndex:index];

		if (!isClickInSelection) {
			indexSet = [NSIndexSet indexSetWithIndex:index];
			[self deselectAllItems];
			CNGridViewItem *item = [keyedVisibleItems objectForKey:[NSNumber numberWithInteger:index]];//keyedVisibleItems[@(index)];
			[self selectItem:item];
		}

		if (_itemContextMenu) {
			NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:NSRightMouseDown
			                                             location:location
			                                        modifierFlags:0
			                                            timestamp:0
			                                         windowNumber:[self.window windowNumber]
			                                              context:nil
			                                          eventNumber:0
			                                           clickCount:0
			                                             pressure:0];

			for (NSMenuItem *menuItem in _itemContextMenu.itemArray) {
				[menuItem setRepresentedObject:indexSet];
			}
			[NSMenu popUpContextMenu:_itemContextMenu withEvent:fakeMouseEvent forView:self];

			// inform the delegate
			[self gridView:self didActivateContextMenuWithIndexes:indexSet inSection:0];
		}
    } else {
        if (_itemContextMenu) {
            NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:NSRightMouseDown
                                                         location:location
                                                    modifierFlags:0
                                                        timestamp:0
                                                     windowNumber:[self.window windowNumber]
                                                          context:nil
                                                      eventNumber:0
                                                       clickCount:0
                                                         pressure:0];
            
            [NSMenu popUpContextMenu:_itemContextMenu withEvent:fakeMouseEvent forView:self];
        } else {
            [self deselectAllItems];
        }
    }
}

- (void)keyDown:(NSEvent *)theEvent {
	switch ([theEvent keyCode]) {
		case 53: {  // escape
			abortSelection = YES;
			break;
		}
	}
    [super keyDown:theEvent];
}

#pragma mark - CNGridView Delegate Calls

- (void)gridView:(CNGridView *)gridView willHoverItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewWillHoverItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView willHoverItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView willUnhoverItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewWillUnhoverItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView willUnhoverItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView willSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewWillSelectItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView willSelectItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewDidSelectItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView didSelectItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView willDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewWillDeselectItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView willDeselectItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView didDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewDidDeselectItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView didDeselectItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView willDeselectAllItems:(NSArray *)theSelectedItems {
	[nc postNotificationName:CNGridViewWillDeselectAllItemsNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:theSelectedItems forKey:CNGridViewSelectedItemsKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView willDeselectAllItems:theSelectedItems];
	}
}

- (void)gridViewDidDeselectAllItems:(CNGridView *)gridView {
	[nc postNotificationName:CNGridViewDidDeselectAllItemsNotification object:gridView userInfo:nil];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridViewDidDeselectAllItems:gridView];
	}
}

- (void)gridView:(CNGridView *)gridView didClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewDidClickItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView didClickItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewDidDoubleClickItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:@(index) forKey:CNGridViewItemIndexKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView didDoubleClickItemAtIndex:index inSection:section];
	}
}

- (void)gridView:(CNGridView *)gridView didActivateContextMenuWithIndexes:(NSIndexSet *)indexSet inSection:(NSUInteger)section {
	[nc postNotificationName:CNGridViewRightMouseButtonClickedOnItemNotification
	                  object:gridView
	                userInfo:[NSDictionary dictionaryWithObject:indexSet forKey:CNGridViewItemsIndexSetKey]];
	if ([self.delegate respondsToSelector:_cmd]) {
		[self.delegate gridView:gridView didActivateContextMenuWithIndexes:indexSet inSection:section];
	}
}

- (NSImage *)gridView:(CNGridView *)gridView draggingImageForItemsAtIndexes:(NSIndexSet *)indexSet withEvent:(NSEvent *)event {
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate gridView:gridView draggingImageForItemsAtIndexes:indexSet withEvent:event];
    }else {
        return nil;
    }
}

- (NSArray *)gridView:(CNGridView *)gridView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropURL forDraggedItemsAtIndexes:(NSIndexSet *)indexes {
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate gridView:gridView namesOfPromisedFilesDroppedAtDestination:dropURL forDraggedItemsAtIndexes:indexes];
    }else {
        return nil;
    }
}

- (void)gridViewCancelAllOperations:(CNGridView *)gridView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridViewCancelAllOperations:gridView];
    }
}

#pragma mark - CNGridView DataSource Calls

- (NSUInteger)gridView:(CNGridView *)gridView numberOfItemsInSection:(NSInteger)section {
	if ([self.dataSource respondsToSelector:_cmd]) {
		return [self.dataSource gridView:gridView numberOfItemsInSection:section];
	}
	return NSNotFound;
}

- (CNGridViewItem *)gridView:(CNGridView *)gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section {
	if ([self.dataSource respondsToSelector:_cmd]) {
		return [self.dataSource gridView:gridView itemAtIndex:index inSection:section];
	}
	return nil;
}

- (NSUInteger)numberOfSectionsInGridView:(CNGridView *)gridView {
	if ([self.dataSource respondsToSelector:_cmd]) {
		return [self.dataSource numberOfSectionsInGridView:gridView];
	}
	return NSNotFound;
}

- (NSString *)gridView:(CNGridView *)gridView titleForHeaderInSection:(NSInteger)section {
	if ([self.dataSource respondsToSelector:_cmd]) {
		return [self.dataSource gridView:gridView titleForHeaderInSection:section];
	}
	return nil;
}

- (NSArray *)sectionIndexTitlesForGridView:(CNGridView *)gridView {
	if ([self.dataSource respondsToSelector:_cmd]) {
		return [self.dataSource sectionIndexTitlesForGridView:gridView];
	}
	return nil;
}

- (NSMutableDictionary *)getSelectedItemsDic{
    return selectedItems;
}

- (NSMutableDictionary *)getkeyedVisibleItemsDic {
    return keyedVisibleItems;
}

@end




#pragma mark - CNSelectionFrameView

@implementation CNSelectionFrameView

- (void)drawRect:(NSRect)rect {
    //画框选框
	NSRect dirtyRect = NSMakeRect(0.5, 0.5, floorf(NSWidth(self.bounds)) - 1, floorf(NSHeight(self.bounds)) - 1);
	NSBezierPath *selectionFrame = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:0 yRadius:0];

	[[[NSColor blackColor] colorWithAlphaComponent:0.15] setFill];
	[selectionFrame fill];

	[[NSColor whiteColor] set];
	[selectionFrame setLineWidth:1];
	[selectionFrame stroke];
}

- (BOOL)isFlipped {
	return YES;
}

@end
#pragma clang diagnostic pop
