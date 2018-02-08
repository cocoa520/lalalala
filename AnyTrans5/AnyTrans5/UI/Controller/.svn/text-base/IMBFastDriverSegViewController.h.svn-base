//
//  IMBFastDriverSegViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "LoadingView.h"
#import "IMBLackCornerView.h"
@class IMBFastDriverCollectionViewController;
@class IMBBackgroundBorderView;
@class IMBFastDriverTreeViewController;
@interface IMBFastDriverSegViewController : IMBBaseViewController
{
    IBOutlet IMBBackgroundBorderView *separateLine;
    IBOutlet HoverButton *_homePage;
    IBOutlet NSBox *_contentBox;
    IBOutlet HoverButton *_backButton;
    IBOutlet HoverButton *_nextButton;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet IMBLackCornerView *_selectPromptView;
    IBOutlet NSTextField *_selectPromptTitle;
    
    IMBFastDriverCollectionViewController *_fastDriverCollecitonVC;
    IMBFastDriverTreeViewController *_fastDriverTreeVC;
    IBOutlet NSTextField *_pathFiled;
    int _curViewId;
    int _threadCount;
    long long _totalSize;
}
- (id)initWithIpod:(IMBiPod *)ipod  withDelegate:(id)delegate;

- (NSArray *)doDelete:(NSArray *)selectedTracks;
- (void)doReloadDelete:(NSArray *)newArray;
- (void)doRename:(SimpleNode *)seletednode withName:(NSString *)name;
- (void)setSelectWord:(int)totalCount withSelectCount:(int)selectCount;
- (void)loadFastDriverCollecitonVC;

 @end
