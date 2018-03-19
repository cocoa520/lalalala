//
//  IMBDevViewController.m
//  iOSFiles
//
//  Created by iMobie on 18/1/25.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDevViewController.h"
#import "IMBDeviceConnection.h"
#import "IMBSelectedDeviceTextfield.h"


CGFloat const IMBDevViewControllerRowH = 30.0f;
static CGFloat const labelY = 5.0f;

@interface IMBDevViewController ()<NSTableViewDelegate,NSTableViewDataSource>
{
@private
    IBOutlet NSTableView *_tableView;
    
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
        [_tableView reloadData];
    }
    
}

/**
 *  初始化方法
 */
- (void)awakeFromNib {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [_tableView.layer setBackgroundColor:[NSColor clearColor].CGColor];
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
    
    [super dealloc];
    
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

#pragma mark - tableviewdelegate  tableviewdatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _devices.count;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return IMBDevViewControllerRowH;
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
        aView = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, IMBDevViewControllerRowH)];
    } else {
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    }
    IMBBaseInfo *baseInfo = [_devices objectAtIndex:row];
    
    IMBSelectedDeviceTextfield *textField = [[IMBSelectedDeviceTextfield alloc] initWithFrame:CGRectMake(0, labelY, tableView.frame.size.width, IMBDevViewControllerRowH - 2*labelY)];
    textField.iconX = _iconX;
    textField.textX = _textX;
    textField.textString = [NSString stringWithFormat:@"%@",baseInfo.deviceName];
    textField.font = [NSFont fontWithName:@"PingFangSC-Regular" size:14.f];
    textField.drawsBackground = NO;
    textField.bordered = NO;
    textField.focusRingType = NSFocusRingTypeNone;
    textField.editable = NO;
    [textField setTextColor:IMBGrayColor(188)];
    [aView addSubview:textField];
    return aView;
}

@end
