//
//  IMBiCloudPhotoVideoViewController.h
//  AnyTrans
//
//  Created by long on 2/28/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "LoadingView.h"
#import "IMBScrollView.h"
#import "IMBImageAndTitleButton.h"

@interface IMBiCloudPhotoVideoViewController : IMBBaseViewController
{
    IBOutlet NSView *_dataView;
    IBOutlet NSBox *_rootBox;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet NSView *_noDataView;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet IMBCustomHeaderTableView *_leftTableView;
    IBOutlet IMBScrollView *_scrollView;
    NSMutableDictionary *_contentDic;
    IBOutlet NSBox *_rightBox;
    IMBToiCloudPhotoEntity *_currentEntity;
    NSViewController *_currentContorller;
    int _currentSelectView;
    IBOutlet IMBImageAndTitleButton *_addAlbumBtn;
    IBOutlet NSView *_leftRootView;
    int _moveRow;
    IBOutlet NSImageView *_noDataImage;
    IBOutlet NSTextField *_nodataLable;
    BOOL _isLoading;
    IMBToiCloudPhotoEntity *_photoEntity;
}
- (void)settoAlbumMenuItem:(NSMenuItem *)item;
- (void)repToolBarView:(IMBToolBarView *)toolBar;

@end
