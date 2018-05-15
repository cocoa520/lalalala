//
//  IMBHomeFileViewController.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/6.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBHomeFileViewController.h"
#import "IMBDriveModel.h"
#import "IMBHomePageViewController.h"

@interface IMBHomeFileViewController ()

@end

@implementation IMBHomeFileViewController
@synthesize dataAry = _dataAry;

- (id)initWithDelegate:(id)delegate {
    if (self = [super initWithNibName:@"IMBHomeFileViewController" bundle:nil]) {
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib {
    _dataAry = [[NSMutableArray alloc] init];
    [self.view addSubview:_scrollView];
    [_collectionView setWantsLayer:YES];
}

- (void)loadDataAry:(int)showCount {
    [_dataAry removeAllObjects];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < showCount - 1; i++) {
        NSArray *fileAry = [[IMBCloudManager singleton] userTable].fileHisArray;
        if (fileAry.count > i) {
            IMBDriveModel *driveModel = [fileAry objectAtIndex:i];
            [array addObject:driveModel];
        }
    }
    
    IMBDriveModel *driveModel = [[IMBDriveModel alloc] init];
    driveModel.iConimage = [NSImage imageNamed:@"def_morefiles"];
    driveModel.fileName = CustomLocalizedString(@"Menu_MoreCloud_Tips", nil);
    driveModel.createdDateString = @"";
    driveModel.itemIDOrPath = @"moreHistoryID";
    
    [array addObject:driveModel];
    [driveModel release];
    driveModel = nil;
    
    [_arrayController addObjects:array];
    [array release];
}

//- (IBAction)starFile:(id)sender {
//    NSLog(@"star File");
//}
//
//- (IBAction)shareFile:(id)sender {
//    NSLog(@"share File");
//}
//
//- (IBAction)syncFile:(id)sender {
//    NSLog(@"sync File");
//}

- (IBAction)operationFile:(id)sender {
    NSLog(@"operation File");
    [_delegate fileHistoryButtonClick:sender];
}

- (void)dealloc {
    [_dataAry release], _dataAry = nil;
    [super dealloc];
}

@end

@implementation IMBHomeFileCollectionViewItem

@end
