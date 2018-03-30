//
//  IMBTranferShowCompleteViewController.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCustomHeaderTableView.h"
#import "IMBImageAndTitleButton.h"
@interface IMBTranferShowCompleteViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate>
{
    NSMutableArray *_dataAry;

    IBOutlet NSBox *_rootBox;
    IBOutlet IMBCustomHeaderTableView *_tableView;
    IBOutlet NSView *_nodataView;
    IBOutlet NSImageView *_nodataImageView;
    IBOutlet NSTextField *_noTipTextField;
    IBOutlet NSView *_dataView;
    IMBImageAndTitleButton *_findFileBtn;
    IMBImageAndTitleButton *_deleteFileBtn;
    int count;
    id _delegate;
}
@property (nonatomic,assign)id delegate;
- (void)addDataAry:(NSMutableArray *)dataAry;
- (void)removeAllData;
@end
