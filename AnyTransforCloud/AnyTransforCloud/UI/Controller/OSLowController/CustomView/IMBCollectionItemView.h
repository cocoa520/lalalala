//
//  IMBCollectionItemView.h
//  AnyTransforCloud
//
//  Created by iMobie on 5/3/18.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBlankDraggableCollectionView.h"
#import "IMBLowAddCloudViewController.h"
#import "IMBHomeCloudViewController.h"
#import "IMBHomeFileViewController.h"

#define ClickCollectionEvent @"Click_Collection_Event"
#define HomeClickCollectionEvent @"Home_Click_Collection_Event"
#define HomeFileClickCollectionEvent @"Home_File_Click_Collection_Event"

@interface IMBCollectionItemView : NSView {
    IMBBlankDraggableCollectionView *_blankDraggableView;
    BOOL _done;
    NSTrackingArea *_trackingArea;
    IBOutlet NSImageView *_bgImageView;
    IBOutlet NSTextField *_numberTextField;
    BOOL _hasLargeImage;
    IBOutlet NSTextField *_titleTextField;
}
@property (nonatomic,assign) BOOL done;

@end
