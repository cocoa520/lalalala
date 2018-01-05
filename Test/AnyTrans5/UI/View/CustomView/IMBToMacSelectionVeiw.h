//
//  IMBToMacSelectionVeiw.h
//  iMobieTrans
//
//  Created by iMobie on 7/24/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBlankDraggableCollectionView.h"

@interface IMBToMacSelectionVeiw : NSView {
    NSTrackingArea *_trackingArea;
    BOOL _isEntered;
    BOOL _isClicked;
    id _delegate;
}

@property (nonatomic, readwrite) BOOL isEntered;
@property (nonatomic, readwrite) BOOL isClicked;
@property (nonatomic, readwrite ,retain) id delegate;

@end
