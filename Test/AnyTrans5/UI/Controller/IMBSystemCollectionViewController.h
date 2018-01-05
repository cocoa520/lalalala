//
//  IMBSystemCollectionViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "LoadingView.h"
#import "IMBScrollView.h"
@class HoverButton;
@class IMBBackgroundBorderView;
@class IMBFileSystemManager;
@interface IMBSystemCollectionViewController : IMBBaseViewController
{
    IBOutlet IMBBackgroundBorderView *_backandnextView;
    IBOutlet NSTextField *_itemTitleField;
    IBOutlet HoverButton *advanceButton;
    IBOutlet HoverButton *backButton;
    IBOutlet IMBScrollView *_scrollView;

    IBOutlet NSView *_noDataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSView *_detailView;
    IBOutlet NSBox *_mainBox;
    IBOutlet IMBWhiteView *_bgView;
    IMBFileSystemManager *systemManager;
//    NSSegmentedControl *backandnext;
    NSMutableArray *_backContainer;
    NSMutableArray *_nextContainer;
    int currentIndex;
    NSMutableArray *_currentArray;
    NSString *_currentDevicePath;
    NSNotificationCenter *nc;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    
    int _deleteTotalItems;
}
@property(nonatomic,retain)NSMutableArray *currentArray;
@property (nonatomic,retain)NSString *currentDevicePath;

- (void)setDeleteCurItems:(int)curItem;

@end
