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
#import "IMBFileSystemExport.h"
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

-(void)awakeFromNib {
    [_rootView setBackgroundColor:[NSColor redColor]];
    if (_transferType == TransferToDevice) {
        _baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:_uniquekey importTracks:_toDevicePathAry withCurrentPath:_currentPath withDelegate:self];
      
    }else if (_transferType == TransferExport) {
        _baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:_uniquekey exportTracks:_toDevicePathAry exportFolder:_currentPath withDelegate:self];
    }
    [_baseTransfer startTransfer];
    
}

@end
