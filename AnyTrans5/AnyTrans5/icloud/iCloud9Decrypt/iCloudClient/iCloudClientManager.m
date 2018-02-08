//
//  iCloudClientManager.m
//  
//
//  Created by JGehry on 7/3/17.
//
//

#import "iCloudClientManager.h"
#import "IMBLogManager.h"

@implementation iCloudClientManager
@synthesize dataDic = _dataDic;
@synthesize deviceSnapshotDict = _deviceSnapshotDict;

+ (iCloudClientManager *)singleton {
    static iCloudClientManager *_singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[iCloudClientManager alloc] init];
    });
    return _singleton;
}

- (instancetype)init
{
    if (self = [super init]) {
        _icloudClient = [[iCloudClient alloc] init];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (BOOL)loginAuth:(NSString*)appleID withPassword:(NSString*)password {
    [[IMBLogManager singleton] writeInfoLog:@"login Icloud start"];
    if (_dataDic != nil) {
        [_dataDic release];
        _dataDic = nil;
    }
    _isTwoStepAuth = NO;
    _dataDic = [[NSMutableDictionary alloc]init];
    BOOL isRet = NO;
    BOOL isnetworkfail = NO;
    [_icloudClient setDelegate:self];
    @try {
        [[IMBLogManager singleton] writeInfoLog:@"Verify account password"];
        isRet = [_icloudClient auth:appleID withPassword:password];
    }
    @catch (NSException *exception) {
        [[IMBLogManager singleton] writeInfoLog:@"loginEorro"];
        isnetworkfail = YES;
    }
    return isRet;
}

@end
