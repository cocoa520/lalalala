//
//  IMBiCloudDriverDListViewController.h
//  AnyTrans
//
//  Created by LuoLei on 2017-02-17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckButton.h"
#import "IMBDownloadButton.h"
#import "IMBBasedViewTableView.h"
#import "IMBBorderRectAndColorView.h"
#import "IMBWhiteView.h"
#import "IMBCustomHeaderTableView.h"
@class IMBBackgroundBorderView;
@class IMBScrollView;
@interface IMBiCloudDriverDListViewController : NSViewController
{
    IBOutlet IMBCustomHeaderTableView *_tableView;
    IBOutlet NSTextField *_titleField;
    IBOutlet NSTextField *_subTitleField;
    IMBCheckButton *_allCheckBoxButton;
    IBOutlet IMBDownloadButton *_cancelButton;
    IBOutlet IMBDownloadButton *_cDownloadButton;
    IBOutlet NSTextField *_selectAllTextField;
    NSMutableArray *_dataSourceArray;
    IBOutlet IMBBorderRectAndColorView *_continueDownListView;
    NSView *_mainView;
    id _target;
    IBOutlet IMBWhiteView *_bgView;
    
    
    
}
@property (nonatomic,retain)NSMutableArray *dataSourceArray;
@property (nonatomic,assign)id target;
- (void)showDownListView:(NSView *)superView;
- (void)cancelContinuDown:(id)sender;
@end
