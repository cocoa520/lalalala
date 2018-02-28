//
//  IMBTransferViewController.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/2/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseTransfer.h"

typedef enum TransferMode {
    TransferExport = 1,
    TransferImport = 2,
    TransferToiTunes = 3,
    TransferToDevice = 4,
    TransferToContact = 5,
    TransferImportContacts = 6,
    TransferDownLoad = 7,
    TransferUpLoading = 8,
    TransferSync = 9,
    TransferToiCloud = 10, //设备到iCloud
    TransferAllAndroidToiOSDevice = 11,
    TransferAllAndroidToiCloud = 12,
    TransferAllAndroidToiTunes = 13,
} TransferModeType;

@interface IMBTransferViewController : NSViewController
{
    NSMutableArray *_toDevicePathAry;
    NSString *_uniquekey;
    NSString *_currentPath;
    IMBBaseTransfer *_baseTransfer;
    TransferModeType _transferType;
}
- (id)initWithToDevicePath:(NSMutableArray*)paths WithiPodKey:(NSString *)uniqueKey curFolder:(NSString *)currentPath;
- (id)initWithUniqueKey:(NSString *)uniqueKey withSelectedAry:(NSMutableArray *)selectedAry exportFolder:(NSString *)exportFolder withDelegate:(id)delegate;
@end
