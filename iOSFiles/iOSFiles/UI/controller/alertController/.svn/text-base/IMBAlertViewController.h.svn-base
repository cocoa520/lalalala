//
//  IMBAlertViewController.h
//  iOSFiles
//
//  Created by smz on 18/3/28.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBorderRectAndColorView.h"
#import "IMBScrollView.h"
#import "IMBWhiteView.h"
#import "IMBCustomHeaderTableView.h"
#import "IMBGridientButton.h"
#import "StringHelper.h"
#import "IMBDriveEntity.h"

@interface IMBAlertViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate> {
    //选择文件夹弹框
    IBOutlet IMBBorderRectAndColorView *_selectFolderAlertView;
    IBOutlet NSTextField *_selectFolderAlertTitle;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet IMBCustomHeaderTableView *_selectFolderAlertDetailView;
    IBOutlet IMBGridientButton *_selectFolderAlertCancelBtn;
    IBOutlet IMBGridientButton *_selectFolderAlertOKBtn;
    IBOutlet IMBWhiteView *_backgroundBorderView;
    NSMutableArray *_folderArray;
    IMBDriveEntity *_curEntity;
    
    //单按钮  单句  弹框
    IBOutlet IMBBorderRectAndColorView *_warningAlertView;
    IBOutlet NSImageView *_warnAlertImage;
    IBOutlet NSTextField *_warningTextField;
    IBOutlet IMBGridientButton *_okBtn;
    
    id _delegete;
    NSView *_mainView;
}
@property (nonatomic, assign) id delegete;
/*
 * 选择文件夹弹框
 */
- (void)showSelectFolderAlertViewWithSuperView:(NSView *)superView WithFolderArray:(NSMutableArray *)folderArray;

//单按钮  单句  弹框
- (void)showAlertText:(NSString *)alertText WithButtonTitle:(NSString *)buttonTitle WithSuperView:(NSView *)superView;

@end
