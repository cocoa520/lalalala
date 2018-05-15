//
//  IMBHomePageViewController.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/16.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBTextLinkButton.h"
#import "IMBLineView.h"
#import "IMBProgressView.h"
#import "IMBCanClickText.h"
#import "IMBBaseViewController.h"
#import "IMBMoreMenuView.h"
#import "IMBCloudHistoryView.h"
#import "IMBFileHistoryView.h"
#import "IMBHomeCloudViewController.h"
#import "IMBHomeFileViewController.h"

@interface IMBHomePageViewController : IMBBaseViewController {
    
    IBOutlet NSImageView *_headImageView;
    IBOutlet NSTextField *_homePageTitle;
    IBOutlet IMBTextLinkButton *_upgradeBtn;
    IBOutlet IMBLineView *_spaceLine;
    IBOutlet IMBTextLinkButton *_editPersonBtn;
    
    IBOutlet IMBProgressView *_memoryProgress;
    IBOutlet IMBCanClickText *_memoryDescription;
    
    IBOutlet NSView *_midView;
    IBOutlet NSTextField *_midViewTitle;
    
    IBOutlet NSView *_bottomView;
    IBOutlet NSTextField *_bottomViewTitle;
    IBOutlet NSTextField *_bottomNoDataText;
    IBOutlet NSBox *_midBox;
    IBOutlet NSBox *_bottomBox;
    
    NSMutableArray *_fileHistoryArr;
    int _oldItemCount1;
    int _fileItemCount;
    int _oldItemCount2;
    
    BOOL _isChanging;
    BOOL _isChangingFile;
    
    IMBMoreMenuView *_moreMenu;
    BOOL _isOpenMenu;
    
    IMBFileHistoryView *_fileHistoryView;
    IMBFileItemView *_fileItemView;
    IMBHomeCloudViewController *_cloudViewController;
    IMBHomeFileViewController *_fileViewController;
}

- (void)fileHistoryButtonClick:(id)sender;

//最近访问云历史记录信息
- (void)configRecentlyVisitsView;

@end
