//
//  SimpleNode.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-3.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "SimpleNode.h"
#import "IMBAnimateProgressBar.h"
#import "HoverButton.h"
#import "StringHelper.h"
@implementation SimpleNode

@synthesize fileName   = _fileName;
@synthesize image      = _image;
@synthesize container  = _container;
@synthesize key        = _key;
@synthesize path       = _path;
@synthesize childrenArray = _childrenArray;
@synthesize domain = _domain;
@synthesize udid = _udid;
@synthesize backupDate = _backupDate;
@synthesize deviceName = _deviceName;
@synthesize backupPath = _backupPath;
@synthesize productType = _productType;
@synthesize productVersion = _productVersion;
@synthesize isBackupNode = _isBackupNode;
@synthesize isDeviceNode = _isDeviceNode;
@synthesize uniqueID = _uniqueID;
@synthesize snapshotID = _snapshotID;
@synthesize isEncrypt = _isEncrypt;
@synthesize decryptKey = _decryptKey;
@synthesize parentPath = _parentPath;
@synthesize isLoading = _isLoading;
//@synthesize backupDecrypt = _backupDecrypt;
@synthesize type = _type;

@synthesize itemSize = _itemSize;
@synthesize serialNumber = _serialNumber;
@synthesize deleteBtn = _deleteBtn;
@synthesize decryptPath = _decryptPath;

@synthesize checkState = _checkState;
@synthesize iosProductTye = _iosProductTye;
@synthesize listprogressBar = _listprogressBar;
@synthesize coprogressBar = _coprogressBar;
@synthesize listCloseButton = _listCloseButton;
@synthesize coCloseButton = _coCloseButton;
@synthesize isCoping = _isCoping;
@synthesize creatDate = _creatDate;
@synthesize controller = _controller;
@synthesize isStop = _isStop;
//@synthesize transfer = _transfer;
@synthesize sourcePath = _sourcePath;
- (id)init {
    self = [super init];
    if (self) {
        self.fileName = @"node";
        self.container = YES;
        _isDeviceNode = NO;
        _isBackupNode = NO;
        _snapshotID = 0;
        _isEncrypt = NO;
        _decryptKey = nil;
        _isLoading = NO;
        _type = @"";
        _itemSize= 0;
        _creatDate = @"";
        [self setCheckState:UnChecked];
        _checkState = NSOffState;
    }
    return self;
}

- (void)setCheckState:(CheckStateEnum)checkState
{
    _checkState = checkState;
}

- (NSMutableArray *)childrenArray {
    if (_childrenArray == nil) {
        self.childrenArray = [NSMutableArray array];
        return self.childrenArray;
    } else {
        return _childrenArray;
    }
}

- (id)initWithName:(NSString *)aName {
    self = [self init];
    if (self) {
        self.fileName = aName;
    }
    return self;
}

+ (SimpleNode *)nodeDataWithName:(NSString *)name {
    return [[[SimpleNode alloc] initWithName:name] autorelease];
}

- (void)createProgressBar
{
    _isCoping = YES;
    _coprogressBar = [[IMBAnimateProgressBar alloc] initWithFrame:NSMakeRect(20, 45, 55, 6)];
    [_coprogressBar setProgress:0.0];
    _listprogressBar = [[IMBAnimateProgressBar alloc] initWithFrame:NSMakeRect(20, 45, 55, 6)];
    [_listprogressBar setProgress:0.0];
    _listCloseButton = [[HoverButton alloc] initWithFrame:NSMakeRect(0, 0, 14, 14)];
    _coCloseButton = [[HoverButton alloc] initWithFrame:NSMakeRect(10, 80, 14, 14)];
    [_listCloseButton setMouseEnteredImage:[StringHelper imageNamed:@"fastdriver_close2"] mouseExitImage:[StringHelper imageNamed:@"fastdriver_close1"] mouseDownImage:[StringHelper imageNamed:@"fastdriver_close3"]];
    [_coCloseButton setMouseEnteredImage:[StringHelper imageNamed:@"fastdriver_close2"] mouseExitImage:[StringHelper imageNamed:@"fastdriver_close1"] mouseDownImage:[StringHelper imageNamed:@"fastdriver_close3"]];
    [_listCloseButton setTarget:self];
    [_listCloseButton setAction:@selector(closeCopy:)];
    [_coCloseButton setTarget:self];
    [_coCloseButton setAction:@selector(closeCopy:)];
    
}

-(void)closeCopy:(id)sender{
    _isStop = YES;
//    _transfer.isStop = YES;
    if ([_controller respondsToSelector:@selector(closeCopy:)]) {
        [_controller closeCopy:self];
    }
}


- (void)setIsCoping:(BOOL)isCoping
{
    _isCoping = isCoping;
}

- (void)transferProgress:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_coprogressBar setProgressWithOutAnimation:progress];
        [_listprogressBar setProgressWithOutAnimation:progress];
    });
}

- (void)transferCurrentSize:(long long)currenSize
{
    _itemSize = currenSize;
    if ([_controller respondsToSelector:@selector(reloadSize)]) {
        [_controller reloadSize];
    }
}
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _isCoping = NO;
        [_listprogressBar removeFromSuperview];
        [_coprogressBar removeFromSuperview];
        [_listCloseButton removeFromSuperview];
        [_coCloseButton removeFromSuperview];
    });
}

- (void)dealloc
{
    [_coprogressBar release],_coprogressBar = nil;
    [_listprogressBar release],_listprogressBar = nil;
    [_listCloseButton release],_listCloseButton = nil;
    [_coCloseButton release],_coCloseButton = nil;
    [_fileName release];
    [_image release];
    [_key release];
    [_path release];
    [_childrenArray release];
    [_domain release];
    [_deviceName release];
    [_backupDate release];
    [_udid release];
    [_backupPath release];
    [_productVersion release];
    [_uniqueID release];
    [_parentPath release];
    [_decryptKey release];
//    [_backupDecrypt release];
    [_deleteBtn release];
    [_sourcePath release];
    [super dealloc];
}
@end
