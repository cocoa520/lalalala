//
//  ObjectTableRowView.m
//  MacClean
//
//  Created by LuoLei on 15-12-9.
//  Copyright (c) 2015年 imobie. All rights reserved.
//

#import "ObjectTableRowView.h"
#import "DownloadCellView.h"
#import "VideoBaseInfoEntity.h"
@implementation ObjectTableRowView
@synthesize objectValue = _objectValue;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
    }
}

#pragma mark - Mouse Actions
- (void)mouseEntered:(NSEvent *)theEvent
{
    if ([_objectValue isKindOfClass:[VideoBaseInfoEntity class]]) {
        VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)_objectValue;
        if (entity.downloadState == TransferFinishSuccess || entity.downloadState == TransferFinishFail) {
            entity.downloadState = DownloadFinish;
            NSTableView *tableView = (NSTableView *)[self superview];
            [tableView reloadData];
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    
}

- (void)dealloc {
    self.objectValue = nil;
    [_trackingArea release],_trackingArea = nil;
    [super dealloc];
}

@end
