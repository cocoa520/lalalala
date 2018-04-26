//
//  IMBTransferViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/2/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTransferViewController.h"
#import "IMBDeviceConnection.h"
#import "IMBiPod.h"
#import "IMBImageAndTextFieldCell.h"
#import "IMBFileSystemExport.h"
#import "IMBTranferViewCell.h"
static id _instance = nil;
@interface IMBTransferViewController ()
{
    IMBiPod *_iPod;
}


@end

@implementation IMBTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
//addItem
- (id)initWithToDevicePath:(NSMutableArray*)paths WithiPodKey:(NSString *)uniqueKey curFolder:(NSString *)currentPath{
    if ([super initWithNibName:@"IMBTransferViewController" bundle:nil]) {
        _currentPath = currentPath;
        _toDevicePathAry = paths;
        _uniquekey = uniqueKey;
        _transferType = TransferToDevice;
    }
    return self;
}
//export
- (id)initWithUniqueKey:(NSString *)uniqueKey withSelectedAry:(NSMutableArray *)selectedAry exportFolder:(NSString *)exportFolder withDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBTransferViewController" bundle:nil]) {
        _toDevicePathAry = selectedAry;
        _currentPath = exportFolder;
        _uniquekey = uniqueKey;
        _transferType = TransferExport;
        _iPod = [[[IMBDeviceConnection singleton] getiPodByKey:uniqueKey] retain];
    }
    return self;
}
//  _baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:_ipodKey exportTracks:_selectedItems exportFolder:_exportFolder withDelegate:self];
+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMBDeviceConnection alloc] init];
    });
    return _instance;
}

-(void)awakeFromNib {
//    [_rootView setBackgroundColor:[NSColor redColor]];
    _dataArray = [[NSMutableArray alloc]init];
    IMBTransferModel *transferModel = [[IMBTransferModel alloc]init];
    transferModel.image = [NSImage imageNamed:@"nodata_myfiles"];
    transferModel.fileName = @"Basic";
    transferModel.destination = @"DropBox";
    transferModel.size = 12212121;
    [_dataArray addObject:transferModel];
    [_tableView setDelegate:self];
//    if (_transferType == TransferToDevice) {
//        _baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:_uniquekey importTracks:_toDevicePathAry withCurrentPath:_currentPath withDelegate:self];
//      
//    }else if (_transferType == TransferExport) {
//        _baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:_uniquekey exportTracks:_toDevicePathAry exportFolder:_currentPath withDelegate:self];
//    }
//    [_baseTransfer startTransfer];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _dataArray.count;
}


- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    IMBTransferModel *transferModel = [_dataArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"image"]) {
        IMBImageAndTextFieldCell *cell1 = (IMBImageAndTextFieldCell *)cell;
        cell1.imageSize = NSMakeSize(33, 38);
        cell1.marginX = 4;
        cell1.paddingX = 0;
        cell1.image = [NSImage imageNamed:@"nodata_myfiles"];
        cell1.imageName = @"nodata_myfiles";
    }else {
        IMBTranferViewCell *cell2 = (IMBTranferViewCell *)cell;
        cell2.transferModel = transferModel;
    }
}

-(void)dealloc {
    [super dealloc];
    if (_dataArray) {
        [_dataArray release];
        _dataArray = nil;
    }
}

@end
