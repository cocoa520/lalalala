//
//  IMBTransferViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/2/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTransferViewController.h"

@interface IMBTransferViewController ()

@end

@implementation IMBTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (id)initWithToDevicePath:(NSMutableArray*)paths WithiPodKey:(NSString *)uniqueKey curFolder:(NSString *)currentPath{
    if ([super initWithNibName:@"IMBTransferViewController" bundle:nil]) {
        _currentPath = currentPath;
        _toDevicePathAry = paths;
        _uniquekey = uniqueKey;
    }
    return self;
}

-(void)awakeFromNib {
     _baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:_uniquekey importTracks:_toDevicePathAry withCurrentPath:_currentPath withDelegate:self];
    [_baseTransfer startTransfer];
}

@end
