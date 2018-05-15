//
//  IMBHistoryViewController.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBHistoryViewController.h"

@interface IMBHistoryViewController ()

@end

@implementation IMBHistoryViewController

- (id)initWithDelegate:(id)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        _historyViewController = [[IMBAllCloudViewController alloc] initWithDelegate:self];
        [_nc addObserver:self selector:@selector(loadFileHistoryRecords) name:HistoryDriveSuccessedNotification object:nil];
        [_nc addObserver:self selector:@selector(loadFileHistoryRecords) name:HistoryDriveErroredNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [_nc removeObserver:self name:HistoryDriveSuccessedNotification object:nil];
    [_nc removeObserver:self name:HistoryDriveErroredNotification object:nil];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.view addSubview:_historyViewController.view];
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    if (cloudManager.userTable.fileHisArray.count <= 0) {
        [cloudManager getContentList:@"history"];
    }else {
        [self loadFileHistoryRecords];
    }
}

- (void)loadFileHistoryRecords {
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    [_historyViewController changeContentViewWithDataArr:cloudManager.userTable.fileHisArray];
}

@end
