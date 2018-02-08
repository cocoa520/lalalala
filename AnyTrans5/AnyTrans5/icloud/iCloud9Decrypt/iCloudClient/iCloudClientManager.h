//
//  iCloudClientManager.h
//  
//
//  Created by JGehry on 7/3/17.
//
//

#import <Foundation/Foundation.h>
#import "iCloudClient.h"

@interface iCloudClientManager : NSObject {
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
@property (nonatomic, readwrite, retain) NSMutableDictionary *dataDic;
@property (nonatomic, readwrite, retain) NSMutableDictionary *deviceSnapshotDict;
@property (nonatomic,retain) iCloudClient *icloudClient;
+ (iCloudClientManager *)singleton;
- (BOOL)loginAuth:(NSString*)appleID withPassword:(NSString*)password;
- (void)loadingData;
-(void)downIcloudData:(NSDictionary*)dic;
- (void)stopDownIcloud;

@end
