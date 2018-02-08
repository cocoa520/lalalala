//
//  SimpleNode.h
//  iMobieTrans
//
//  Created by iMobie on 14-3-3.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBackupDecrypt.h"
#import "IMBCommonEnum.h"
#import "IMBMyDrawCommonly.h"
#import "IMBBaseTransfer.h"
@class IMBAnimateProgressBar;
@class HoverButton;
typedef enum {

    iPhoneType=0,
    iPodTouchType=1,
    iPadType=2,
    iPhonexType=3

}DevieType;


@interface SimpleNode : NSObject <TransferDelegate>
{
    NSString *_fileName;
    NSImage  *_image;
    BOOL     _container;
    NSString *_key;           //于此对应的备份文件的名称
    NSString *_path;
    NSMutableArray *_childrenArray;
    NSString *_domain;
    
    BOOL _isLoading;
    
    //扩展
    NSString *_udid;
    NSString *_backupDate;
    NSString *_deviceName;
    NSString *_backupPath;
    NSString *_productVersion;
    DevieType _productType;
    NSString *_uniqueID;
    NSString *_parentPath;
    BOOL _isDeviceNode;
    BOOL _isBackupNode;
    int _snapshotID;
    BOOL _isEncrypt;
    NSString *_decryptKey;
    int64_t _itemSize;
    //扩展
    IMBBackupDecrypt *_backupDecrypt;
    
    NSString *_decryptPath;
    
    NSString *_type;
    NSString *_serialNumber;
    IMBMyDrawCommonly *_deleteBtn;
    CheckStateEnum _checkState;
    NSString *_iosProductTye;
    BOOL _isCoping; //正在拷贝
    BOOL _isStop;
    IMBAnimateProgressBar *_listprogressBar;
    IMBAnimateProgressBar *_coprogressBar;
    NSString *_creatDate;
    HoverButton *_listCloseButton;
    HoverButton *_coCloseButton;
    id _controller;
    IMBBaseTransfer *_transfer;
    NSString *_sourcePath;
}
@property(nonatomic,retain) NSString *decryptPath;
@property(nonatomic,retain) NSString *sourcePath;
@property(nonatomic,assign) IMBBaseTransfer *transfer;
@property(nonatomic,assign) id controller;
@property(nonatomic,assign) BOOL isStop;
@property(nonatomic,retain) IMBAnimateProgressBar *listprogressBar;
@property(nonatomic,retain) IMBAnimateProgressBar *coprogressBar;
@property(nonatomic,retain) HoverButton *listCloseButton;
@property(nonatomic,retain) HoverButton *coCloseButton;
@property(nonatomic,retain) IMBMyDrawCommonly *deleteBtn;
@property(nonatomic,retain) NSString *serialNumber;
@property(nonatomic,retain) NSString *iosProductTye;
@property(nonatomic,assign) int64_t itemSize;
@property(nonatomic,assign) BOOL isLoading;
@property(nonatomic,assign) BOOL isCoping;
@property(nonatomic,copy)NSString   *fileName;
@property(nonatomic,retain)NSImage  *image;
@property(nonatomic,assign)BOOL     container;
@property(nonatomic,copy)NSString   *key;
@property(nonatomic,copy)NSString   *domain;
@property(nonatomic,copy)NSString   *path;
@property(nonatomic,retain)NSMutableArray *childrenArray;
@property(nonatomic,copy)NSString *udid;
@property(nonatomic,copy)NSString *backupDate;
@property(nonatomic,copy)NSString *deviceName;
@property(nonatomic,copy)NSString *backupPath;
@property(nonatomic,copy)NSString *productVersion;
@property(nonatomic,copy)NSString *uniqueID;
@property(nonatomic,assign)DevieType productType;;
@property(nonatomic,assign)BOOL isDeviceNode;
@property(nonatomic,assign)BOOL isBackupNode;
@property(nonatomic,assign)int  snapshotID;
@property(nonatomic, assign) BOOL isEncrypt;
@property(nonatomic, readwrite, copy) NSString *decryptKey;
@property(nonatomic,copy)NSString *parentPath;
@property(nonatomic,retain)IMBBackupDecrypt *backupDecrypt;
@property(nonatomic,copy)NSString   *type;
@property(nonatomic, assign)CheckStateEnum checkState;
@property (nonatomic, retain)NSString *creatDate;//创建时间
- (id)initWithName:(NSString *)name;
+ (SimpleNode *)nodeDataWithName:(NSString *)name;
- (void)createProgressBar;
@end
