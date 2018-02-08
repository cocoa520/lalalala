//
//  IMBBlankDraggableCollectionView.h
//  iMobieTrans
//
//  Created by iMobie on 8/4/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define NOTIFY_DONE @"notify_done"
//#import "IMBBackupExplorerViewController.h"
#import "IMBScrollView.h"

@protocol IMBImageRefreshCollectionListener
@optional
- (void)loadingCollectionThumbnilImage:(NSRange)oldVisibleRows withNewVisibleRows:(NSRange)newVisibleRows;
- (NSIndexSet *)itemCanSelected:(NSIndexSet *)indexes;
@end

@interface IMBBlankDraggableCollectionView : NSCollectionView <IMBCollectionListener>
{
    IBOutlet NSCollectionViewItem *_collectionItem;
    BOOL _isShowBgVeiw;
    dispatch_queue_t queue;
//    FileExploreType _exploreType;
    BOOL _topBorder;
    NSImage *backgroundImage;
    CategoryNodesEnum _category;
    NSImage *_defaultImage;
    BOOL _dragFinished;
    BOOL _isDropBefore;
    BOOL _forBidClick;
    
    NSRange _visibleRows;
    id _listener;
    BOOL _refresh;
    int _totalCount;
    int _column;
    NSColor *_borderColor;
    NSColor *_backGroundColor;
}
@property (nonatomic,retain)NSColor *borderColor;
@property (nonatomic,retain)NSColor *backGroundColor;
@property (nonatomic,retain)NSImage *backgroundImage;
@property (nonatomic, retain) NSCollectionViewItem *collectionItem;
@property (nonatomic, readwrite) BOOL isShowBgVeiw;
//@property (nonatomic,assign)FileExploreType exploreType;
@property (nonatomic,assign)BOOL topBorder;
@property (nonatomic,assign)  CategoryNodesEnum category;
@property (nonatomic,assign)BOOL dragFinished;
@property (nonatomic,assign)BOOL isDropBefore;
@property (nonatomic,assign)BOOL forBidClick;

@property (assign)BOOL refresh;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int column;

- (void)setListener:(id<IMBImageRefreshCollectionListener>)listener;
- (void)setSelectionIndexes:(NSIndexSet *)indexes;
//- (void) _selectWithEvent: (NSEvent *)theEvent index: (NSUInteger)index;
- (NSInteger) _indexAtPoint: (NSPoint)point;
//- (BOOL) _startDragOperationWithEvent: (NSEvent*)event
//                         clickedIndex: (NSUInteger)index;

@end

@interface IMBBindItem : NSObject
{
    NSColor *_textColor;
}
@property(nonatomic,retain)NSColor *textColor;

@end
