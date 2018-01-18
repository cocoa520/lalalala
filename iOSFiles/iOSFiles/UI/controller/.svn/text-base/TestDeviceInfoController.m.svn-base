//
//  TestDeviceInfoController.m
//  iOSFiles
//
//  Created by iMobie on 18/1/17.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "TestDeviceInfoController.h"
#import "IMBDeviceInfo.h"
#import "IMBiPod.h"


@interface TestDeviceInfoController ()<NSTableViewDelegate,NSTableViewDataSource>
{
    @private
    NSTableView *_tableView;
}


@end

@implementation TestDeviceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
   [self setupView]; 
}

- (void)setupView {
    _tableView = [[NSTableView alloc] init];
    _tableView.frame = NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor cyanColor].CGColor;
    
    NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"infoColumn1"];
    NSTableColumn *column2 = [[NSTableColumn alloc] initWithIdentifier:@"infoColumn2"];
    
    column2.width = self.view.frame.size.width/2.0;
    column2.minWidth = self.view.frame.size.width/2.0;
    column2.maxWidth = self.view.frame.size.width/2.0;
    column2.editable = NO ;
    column2.headerToolTip = @"Detail Info";
    column2.hidden = NO;
    column2.sortDescriptorPrototype = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
    
    [_tableView addTableColumn:column1];
    [_tableView addTableColumn:column2];
    if (_ipod) {
        IMBDeviceInfo *info = _ipod.deviceInfo;
    }
    
    
}

- (void)dealloc {
    
    [_tableView release];
    _tableView = nil;
    
    [super dealloc];
}
#pragma mark -- tableviewdelegate tableviewdatasource
@end
