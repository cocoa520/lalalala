//
//  IMBDevViewController.m
//  iOSFiles
//
//  Created by iMobie on 18/1/25.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDevViewController.h"
#import "IMBDeviceConnection.h"
//#import "IMBSelectedDeviceTextfield.h"
#import "IMBCommonDefine.h"

CGFloat const IMBDevViewControllerRowH = 34.0f;
//static CGFloat const labelY = 5.0f;

@interface IMBDevViewController ()<NSTableViewDelegate,NSTableViewDataSource>
{
@private
    IBOutlet NSTableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation IMBDevViewController

#pragma mark - synthesize
@synthesize iconX = _iconX;
@synthesize textX = _textX;
@synthesize devices = _devices;

#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[NSColor clearColor].CGColor];
    
    
    if (_devices.count) {
        _dataArray = [[NSMutableArray alloc] init];
        for (IMBBaseInfo *baseInfo in _devices) {
            if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                [_dataArray addObject:[baseInfo retain]];
            }
            if (_dataArray.count) {
                [_tableView reloadData];
            }
        }
        
    }
    
}

/**
 *  初始化方法
 */
- (void)awakeFromNib {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[NSColor clearColor]];
    
}

- (void)dealloc {
    
    if (_devices) {
        [_devices release];
        _devices = nil;
    }
    if (_tableView) {
        [_tableView release];
        _tableView = nil;
    }
    if (_dataArray) {
        [_dataArray release];
        _dataArray = nil;
    }
    
    [super dealloc];
    
}


#pragma mark - tableviewdelegate  tableviewdatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _dataArray.count;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return IMBDevViewControllerRowH;
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    if (_dataArray.count) {
        IMBBaseInfo *selectBaseInfo = [_dataArray objectAtIndex:row];
        [[NSNotificationCenter defaultCenter] postNotificationName:IMBSelectedDeviceDidChangeNotiWithParams object:selectBaseInfo];
        NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
        [queue addOperationWithBlock:^{
            IMBFLog(@"%@",[NSThread currentThread]);
            IMBBaseInfo *baseInfo = [_dataArray objectAtIndex:row];
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
        aView = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, IMBDevViewControllerRowH)];
    } else {
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    }
    IMBBaseInfo *baseInfo = [_dataArray objectAtIndex:row];
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(_textX,(aView.frame.size.height - 22)/2 + 4, tableView.frame.size.width, 22)];
    [textField setStringValue:baseInfo.deviceName];
    [textField setBordered:NO];
    textField.font = [NSFont fontWithName:@"PingFangSC-Regular" size:14.f];
    [textField setTextColor:IMBGrayColor(188)];
    [aView addSubview:textField];
    
    NSImageView *imageView = [[NSImageView alloc]initWithFrame:NSMakeRect(_iconX , (aView.frame.size.height - 22)/2, 22, 22)];
    [imageView setImage:[NSImage imageNamed:@"device_icon_iPhone_gray"]];
    [aView addSubview:imageView];
    
    [textField release];
    textField = nil;
    [imageView release];
    imageView = nil;
    return aView;
}

@end
