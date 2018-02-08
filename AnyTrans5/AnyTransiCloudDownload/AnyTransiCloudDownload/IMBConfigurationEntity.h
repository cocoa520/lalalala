//
//  IMBConfigurationEntity.h
//  AnyTransiCloudDownload
//
//  Created by long on 16-10-10.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCloudClient.h"

@interface IMBConfigurationEntity : NSObject
{
    int _connectfd;
    iCloudClient *_icloudClient;
    NSArray *_snapshotAry;
    NSMutableDictionary *_dataDic;
    NSMutableDictionary *_deviceSnapshotDict;
    BOOL _isStop;
    __block BOOL cancel;
    BOOL _isTwoStepAuth;
}
@property (nonatomic, assign) BOOL isStop;
@property (nonatomic,retain) NSArray *snapshotAry;
@property (nonatomic,retain) iCloudClient *icloudClient;
+ (IMBConfigurationEntity *)singleton;
- (void)loginIcloud:(NSDictionary *)dic withConnectInt:(int)connectfd;
- (void)loadingData;
-(void)downIcloudData:(NSDictionary*)dic;
- (void)stopDownIcloud;
@end
