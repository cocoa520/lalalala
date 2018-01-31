//
//  IMBDevViewController.m
//  iOSFiles
//
//  Created by iMobie on 18/1/25.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDevViewController.h"
#import "IMBDeviceConnection.h"


CGFloat const rowH = 40.0f;
CGFloat const labelY = 10.0f;

@interface IMBDevViewController ()<NSTableViewDelegate,NSTableViewDataSource>
{
@private
    IBOutlet NSTableView *_tableView;
}
@end

@implementation IMBDevViewController

@synthesize devices = _devices;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

/**
 *  初始化方法
 */
- (void)awakeFromNib {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
- (void)dealloc {
//    [super dealloc];
    
    if (_devices) {
        [_devices release];
        _devices = nil;
    }
    if (_tableView) {
        [_tableView release];
        _tableView = nil;
    }
    
    
    
}
/**
 *  属性设置
 */
- (void)setDevices:(NSMutableArray *)devices {
    _devices = devices;
    
    if (devices.count) {
        [_tableView reloadData];
    }
}

#pragma mark -- tableviewdelegate  tableviewdatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _devices.count;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return rowH;
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    if (_devices.count) {
        IMBBaseInfo *selectBaseInfo = [_devices objectAtIndex:row];
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBSelectedDeviceDidChangeNotiWithParams object:selectBaseInfo];
        NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
        [queue addOperationWithBlock:^{
            IMBFLog(@"%@",[NSThread currentThread]);
            IMBBaseInfo *baseInfo = [_devices objectAtIndex:row];
            IMBiPod *ipod = [[IMBDeviceConnection singleton] getiPodByKey:baseInfo.uniqueKey];
            if (ipod) {
                [[NSNotificationCenter defaultCenter] postNotificationName:IMBSelectedDeviceDidChangeNoti object:ipod];
            }
        }];
    }
    return YES;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *strIdt = [tableColumn identifier];
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView) {
        aView = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, rowH)];
    } else {
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    }
    IMBBaseInfo *baseInfo = [_devices objectAtIndex:row];
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, labelY, tableColumn.width, rowH - 2*labelY)];
    
    textField.stringValue = [NSString stringWithFormat:@"%@: %.01f GB Free/%.01f GB",baseInfo.deviceName,baseInfo.kyDeviceSize/1024.0f/1024.0f/1024.0f,baseInfo.allDeviceSize/1024.0f/1024.0f/1024.0f];
    
    textField.font = [NSFont systemFontOfSize:12.0f];
//    textField.alignment = NSCenterTextAlignment;
    textField.drawsBackground = NO;
    textField.bordered = NO;
    textField.focusRingType = NSFocusRingTypeNone;
    textField.editable = NO;
    [aView addSubview:textField];
    return aView;
}
@end
