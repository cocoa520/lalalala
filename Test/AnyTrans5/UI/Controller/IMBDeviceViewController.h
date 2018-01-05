//
//  IMBDeviceViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBDeviceConnection.h"
#import "IMBDeviceInfo.h"

@interface IMBDeviceViewController : IMBBaseViewController
{
    IMBDeviceConnection *_deviceConnection;
    IMBLogManager *_logHandle;
    id device;
    NSView *_contentView;
    IBOutlet NSView *_hiddenView;
    IBOutlet NSBox *_deviceContentBox;
    NSMutableDictionary *_deviceMainPageDic;
    int trustViewCount;
    
    BOOL _isRestoreDisconnect;
}
- (void)ShowWindowControllerCategory;
//切换视图
- (void)changeViewController:(NSString *)type withIsDevice:(BOOL)isDevice withIsConnected:(BOOL) isConnected;
-(void)trustBtnOperation:(id)sender;
- (void)goToiCloudView;
@end
