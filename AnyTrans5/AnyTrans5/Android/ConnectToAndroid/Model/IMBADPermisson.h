//
//  IMBADPermisson.h
//  PhoneRescue_Android
//
//  Created by iMobie on 4/17/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseCommunicate.h"

@interface IMBADPermisson : IMBBaseCommunicate {
    BOOL _isGranted;
    BOOL _isSetSMSApp;
}

- (BOOL)checkDevicePermisson;
- (BOOL)checkIsSetSMSImport;
//检查设备是否root
- (BOOL)checkDeviceIsRoot;
- (void)promptToDeviceSetPermisson;

- (void)sendAction:(NSString *)switchView ResultText:(int)resultCount TargetWord:(NSString *)target;

//与服务器握手
- (BOOL)shakehandApk;

@end
