//
//  LoginAuthorizationDrive.m
//  DriveSync
//
//  Created by JGehry on 12/13/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "LoginAuthorizationDrive.h"
#import "RegisterAPI.h"
#import "LoginAPI.h"
#import "LoginCodeAPI.h"
#import "GetDriveIDAPI.h"
#import "GetDriveCategoryAPI.h"
#import "AdditionalDriveAPI.h"
#import "RemoveDriveAPI.h"
#import "RenameDriveAPI.h"
#import "TopIndexAPI.h"

#import "OneDrive.h"
#import "Dropbox.h"
#import "Box.h"
#import "GoogleDrive.h"
#import "pCloud.h"
#import "Facebook.h"
#import "Twitter.h"
#import "Instagram.h"

#include <stdio.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>

static void * KdriveToDriveProgressContext = &KdriveToDriveProgressContext;

@implementation LoginAuthorizationDrive
@synthesize collectionFavorite = _collectionFavorite;
@synthesize accessHistory = _accessHistory;
@synthesize share = _share;
@synthesize collectionShare = _collectionShare;
@synthesize offlineTask = _offlineTask;

- (void)dealloc {
    if (_loginEntity) {
        [_loginEntity release];
        _loginEntity = nil;
    }
    [super dealloc];
}

#pragma mark -- 用户注册、登录、退出、第三方授权登录
- (void)userRegisterWithEmail:(NSString *)email withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword {
    YTKRequest *requestAPI = [[RegisterAPI alloc] initWithEmail:email withPassword:password withConfirmPassword:confirmPassword];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            NSDictionary *resultDic = [[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL] retain];
            _userLoginToken = [[resultDic objectForKey:@"token"] retain];
            //获取已授权了的云服务
            if (_userLoginToken) {
                
                //初始化注册实体
                [self initLoginEntity:resultDic];
                
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                    [_delegate driveAPIRequest:self withSuccess:request.responseJSONObject withType:@"register"];
                }
            }else {
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                    [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"register"];
                }
            }
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"register"];
            }
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkResponseTypeWithFailed:request];
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"register"];
        }
        [weakRequestAPI release];
    }];
}

- (void)userLoginWithEmail:(NSString *)email withPassword:(NSString *)password withG2FCode:(NSString *)g2fcode withIsNeedCode:(BOOL)needCode {
    YTKRequest *requestAPI = nil;
    if (needCode) {
        requestAPI = [[LoginAPI alloc] initWithEmail:email withPassword:password withGoogle2FCode:g2fcode];
    }else {
        requestAPI = [[LoginAPI alloc] initWithEmail:email withPassword:password];
    }
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            if (!_userLoginToken) {
                NSDictionary *resultDic = [[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL] retain];
                _userLoginToken = [[resultDic objectForKey:@"token"] retain];
                //初始化登录实体
                [self initLoginEntity:resultDic];
            }
            if (_userLoginToken) {
                _collectionFavorite = [[CollectionFavorite alloc] init];
                _collectionFavorite.userLoginToken = _userLoginToken;
                _accessHistory = [[AccessHistory alloc] init];
                _accessHistory.userLoginToken = _userLoginToken;
                _share = [[Share alloc] init];
                _share.userLoginToken = _userLoginToken;
                _collectionShare = [[CollectionShare alloc] init];
                _collectionShare.userLoginToken = _userLoginToken;
                _offlineTask = [[OfflineTask alloc] init];
                _offlineTask.userLoginToken = _userLoginToken;
                [self getCurrentUserDrive];
            }else {
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                    [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"login"];
                }
            }
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"login"];
            }
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkResponseTypeWithFailed:request];
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"login"];
        }
        [weakRequestAPI release];
    }];
}

- (void)userLoginWithThird:(NSString *)loginThirdName {
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    BOOL res = [ws openURL:[NSURL URLWithString:[WebUserEndPointURL stringByAppendingPathComponent:loginThirdName]]];
    if (res) {
        [self waitBindingDrive];
    }
}

- (void)userLoginWithCode:(NSString *)loginCode {
    YTKRequest *requestAPI = [[LoginCodeAPI alloc] initWithUserLoginCode:loginCode];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            if (!_userLoginToken) {
                NSDictionary *resultDic = [[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL] retain];
                _userLoginToken = [[resultDic objectForKey:@"token"] retain];
                //初始化登录实体
                [self initLoginEntity:resultDic];
            }
            [self getCurrentUserDrive];
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"thirdLogin"];
            }
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkResponseTypeWithFailed:request];
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"thirdLogin"];
        }
        [weakRequestAPI release];
    }];
}

- (void)userLogout {
    for (BaseDrive *drive in [self driveArray]) {
        if (_delegate && [_delegate respondsToSelector:@selector(driveDidLogOut:)]) {
            [_delegate driveDidLogOut:drive];
        }
    }
    if (_loginEntity) {
        [_loginEntity release];
        _loginEntity = nil;
    }
    if (_collectionFavorite) {
        [_collectionFavorite release];
        _collectionFavorite = nil;
    }
    if (_accessHistory) {
        [_accessHistory release];
        _accessHistory = nil;
    }
    if (_share) {
        [_share release];
        _share = nil;
    }
    if (_collectionShare) {
        [_collectionShare release];
        _collectionShare = nil;
    }
    if (_offlineTask) {
        [_offlineTask release];
        _offlineTask = nil;
    }
    [[self driveArray] removeAllObjects];
    [self userDidLogout];
    if ([_delegate respondsToSelector:@selector(driveDidLogOut:)]) {
        [_delegate driveDidLogOut:self];
    }
}

- (void)initLoginEntity:(NSDictionary *)resultDic {
    _loginEntity = [[LoginAuthorizationDriveEntity alloc] init];
    _loginEntity.nickName = [resultDic objectForKey:@"nickname"];
    _loginEntity.firstName = [resultDic objectForKey:@"firstname"];
    _loginEntity.lastName = [resultDic objectForKey:@"lastname"];
    _loginEntity.language = [resultDic objectForKey:@"lang"];
    _loginEntity.avatar = [resultDic objectForKey:@"avatar"];
    _loginEntity.email = [resultDic objectForKey:@"email"];
    _loginEntity.phone = [resultDic objectForKey:@"phone"];
    _loginEntity.active = [[resultDic objectForKey:@"active"] intValue];
    _loginEntity.disable = [[resultDic objectForKey:@"disable"] intValue];
    _loginEntity.country = [resultDic objectForKey:@"country"];
    _loginEntity.region = [resultDic objectForKey:@"region"];
    _loginEntity.city = [resultDic objectForKey:@"city"];
}

#pragma mark -- 获取当前所有云盘列表、获取云盘分类
- (void)getCurrentUserDrive {
    [self getAssociatedDriveIDWithToken:[self userLoginToken] success:^(DriveAPIResponse *response) {
        if ([[response content] isKindOfClass:[NSArray class]] && [[response content] count] > 0) {
            NSDictionary *tmpDict = nil;
            for (id dict in [response content]) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    tmpDict = (NSDictionary *)dict;
                    
                    //创建云盘对象
                    [self createDrive:tmpDict];
                }
            }
        }
        //获取增加的云盘列表
        [self getDriveCategoryList];
        //分回调
        for (BaseDrive *baseDrive in self.driveArray) {
            [self initDriveStatus:baseDrive];
        }
    } fail:^(DriveAPIResponse *response) {
        NSLog(@"获取已授权的云服务失败");
        
        //获取绑定的云盘失败后，要要去获取增加的云盘列表
        [self getDriveCategoryList];
    }];
}

//登录成功后需要刷新绑定的云盘调用
- (void)refreshCurrentUserDrive {
    [self getAssociatedDriveIDWithToken:[self userLoginToken] success:^(DriveAPIResponse *response) {
        if ([[response content] isKindOfClass:[NSArray class]] && [[response content] count] > 0) {
            NSMutableArray *newAddCloudAry = [NSMutableArray array];
            NSDictionary *tmpDict = nil;
            for (id dict in [response content]) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    tmpDict = (NSDictionary *)dict;
                    //检查是否是新增加的云盘，是保存的数组中；
                    NSString *driveID = [tmpDict objectForKey:@"id"];
                    BOOL ret = [self checkIsConstainDrive:driveID];
                    if (!ret) {
                        [newAddCloudAry addObject:driveID];
                    }
                    //创建云盘对象
                    [self createDrive:tmpDict];
                }
            }
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                [_delegate driveAPIRequest:self withSuccess:[NSDictionary dictionaryWithObjectsAndKeys:newAddCloudAry, @"newAddCloudAry", nil] withType:@"refreshCloud"];
            }
        }
    } fail:^(DriveAPIResponse *response) {
        NSLog(@"获取已授权的云服务失败");
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:nil withType:@"refreshCloud"];
        }
    }];
}

- (void)getDriveCategoryList {
    YTKRequest *requestAPI = [[GetDriveCategoryAPI alloc] initWithUserLoginToken:_userLoginToken];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                [_delegate driveAPIRequest:self withSuccess:request.responseJSONObject withType:@"driveCategory"];
            }
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"driveCategory"];
            }
        }
        //登录成功回调(不管获取列表成功与否，都是登录成功的)
        if (_delegate && [_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
            [_delegate driveDidLogIn:self];
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkResponseTypeWithFailed:request];
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"driveCategory"];
        }
        //登录成功回调(不管获取列表成功与否，都是登录成功的)
        if (_delegate && [_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
            [_delegate driveDidLogIn:self];
        }
        [weakRequestAPI release];
    }];
}

- (BOOL)createDrive:(NSDictionary *)tmpDict {
    NSString *driveID = [tmpDict objectForKey:@"id"];
    NSString *serviceName = [tmpDict objectForKey:@"service"];
    BOOL ret = [self checkIsConstainDrive:driveID];
    if ([serviceName isEqualToString:OneDriveCSEndPointURL]) {
        if (!ret) {
            OneDrive *oneDrive = [[OneDrive alloc] init];
            oneDrive.userLoginToken = _userLoginToken;
            oneDrive.driveID = driveID;
            oneDrive.driveName = [tmpDict objectForKey:@"name"];
            oneDrive.driveEmail = [tmpDict objectForKey:@"email"];
            oneDrive.displayName = oneDrive.driveName;
            oneDrive.driveType = OneDriveCSEndPointURL;
            oneDrive.driveTotalCapacity = [tmpDict objectForKey:@"total"];
            oneDrive.driveUsedCapacity = [tmpDict objectForKey:@"used"];
            oneDrive.accessToken = [tmpDict objectForKey:@"token"];
            oneDrive.expirationDate = [self timestampToDate:tmpDict];
            [[self driveArray] addObject:oneDrive];
            [oneDrive release];
            oneDrive = nil;
        }
    }else if ([serviceName isEqualToString:DropboxCSEndPointURL]) {
        if (!ret) {
            Dropbox *dropbox = [[Dropbox alloc] init];
            dropbox.userLoginToken = _userLoginToken;
            dropbox.driveID = [tmpDict objectForKey:@"id"];
            dropbox.driveName = [tmpDict objectForKey:@"name"];
            dropbox.driveEmail = [tmpDict objectForKey:@"email"];
            dropbox.displayName = dropbox.driveName;
            dropbox.driveType = DropboxCSEndPointURL;
            dropbox.driveTotalCapacity = [tmpDict objectForKey:@"total"];
            dropbox.driveUsedCapacity = [tmpDict objectForKey:@"used"];
            dropbox.accessToken = [tmpDict objectForKey:@"token"];
            NSString *str = [tmpDict objectForKey:@"expires_timestamp"];
            if ([str isKindOfClass:[NSNull class]]) {
                dropbox.expirationDate = [NSDate dateWithTimeIntervalSinceNow:0];
            }
            [[self driveArray] addObject:dropbox];
            [dropbox release];
            dropbox = nil;
        }
    }else if ([serviceName isEqualToString:BoxCSEndPointURL]) {
        if (!ret) {
            Box *box = [[Box alloc] init];
            box.userLoginToken = _userLoginToken;
            box.driveID = [tmpDict objectForKey:@"id"];
            box.driveName = [tmpDict objectForKey:@"name"];
            box.driveEmail = [tmpDict objectForKey:@"email"];
            box.displayName = box.driveName;
            box.driveType = BoxCSEndPointURL;
            box.driveTotalCapacity = [tmpDict objectForKey:@"total"];
            box.driveUsedCapacity = [tmpDict objectForKey:@"used"];
            box.accessToken = [tmpDict objectForKey:@"token"];
            box.expirationDate = [self timestampToDate:tmpDict];
            [[self driveArray] addObject:box];
            [box release];
            box = nil;
        }
    }else if ([serviceName isEqualToString:GoogleDriveCSEndPointURL]) {
        if (!ret) {
            GoogleDrive *googleDrive = [[GoogleDrive alloc] init];
            googleDrive.userLoginToken = _userLoginToken;
            googleDrive.driveID = [tmpDict objectForKey:@"id"];
            googleDrive.driveName = [tmpDict objectForKey:@"name"];
            googleDrive.driveEmail = [tmpDict objectForKey:@"email"];
            googleDrive.displayName = googleDrive.driveName;
            googleDrive.driveType = GoogleDriveCSEndPointURL;
            googleDrive.driveTotalCapacity = [tmpDict objectForKey:@"total"];
            googleDrive.driveUsedCapacity = [tmpDict objectForKey:@"used"];
            googleDrive.accessToken = [tmpDict objectForKey:@"token"];
            googleDrive.expirationDate = [self timestampToDate:tmpDict];
            [[self driveArray] addObject:googleDrive];
            [googleDrive release];
            googleDrive = nil;
        }
    }else if ([serviceName isEqualToString:PCloudCSEndPointURL]) {
        if (!ret) {
            pCloud *pcloud = [[pCloud alloc] init];
            pcloud.userLoginToken = _userLoginToken;
            pcloud.driveID = [tmpDict objectForKey:@"id"];
            pcloud.driveName = [tmpDict objectForKey:@"name"];
            pcloud.driveEmail = [tmpDict objectForKey:@"email"];
            pcloud.displayName = pcloud.driveName;
            pcloud.driveType = PCloudCSEndPointURL;
            pcloud.driveTotalCapacity = [tmpDict objectForKey:@"total"];
            pcloud.driveUsedCapacity = [tmpDict objectForKey:@"used"];
            pcloud.accessToken = [tmpDict objectForKey:@"token"];
            pcloud.expirationDate = [self timestampToDate:tmpDict];
            [[self driveArray] addObject:pcloud];
            [pcloud release];
            pcloud = nil;
        }
    }
    return ret;
}

- (NSDate *)timestampToDate:(NSDictionary *)tmpDict {
    NSDate *date = nil;
    long long longDate = 0;
    id obj = [tmpDict objectForKey:@"expires_timestamp"];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        NSString *objStr = (NSString *)obj;
        longDate = [objStr longLongValue];
    }else {
        longDate = [obj longLongValue];
    }
    date = [[NSDate alloc] initWithTimeIntervalSince1970:longDate];
    return date;
}

- (void)getAssociatedDriveIDWithToken:(NSString *)token success:(Callback)success fail:(Callback)fail {
    YTKRequest *requestAPI = [[GetDriveIDAPI alloc] initWithUserLoginToken:token];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:[request responseJSONObject] options:NSJSONWritingPrettyPrinted error:nil];
            DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
            success?success(response):nil;
            [response release];
        }else {
            NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
            NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
            DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
            fail?fail(response):nil;
            [response release];
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithFailed:request];
        NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
        NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
        DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
        fail?fail(response):nil;
        [response release];
        [weakRequestAPI release];
    }];
}

#pragma mark -- 授权添加、取消、重命名、置顶指定云服务
- (void)driveAuthorizedWithName:(NSString *)driveName {
    if ([driveName isEqualToString:GoogleDriveCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)GoogleDriveCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                BOOL res = [ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
                if (res) {
                    
                    //等待添加云盘
                    [self waitBindingDrive];
                }
            }else {
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                    [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
                }
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self checkResponseTypeWithFailed:request];
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
            }
            [weakRequestAPI release];
        }];
    }else if ([driveName isEqualToString:OneDriveCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)OneDriveCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                BOOL res = [ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
                if (res) {
                    
                    //等待添加云盘
                    [self waitBindingDrive];
                }
            }else {
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                    [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
                }
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self checkResponseTypeWithFailed:request];
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
            }
            [weakRequestAPI release];
        }];
    }else if ([driveName isEqualToString:DropboxCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)DropboxCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                BOOL res = [ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
                if (res) {
                    
                    //等待添加云盘
                    [self waitBindingDrive];
                }
            }else {
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                    [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
                }
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self checkResponseTypeWithFailed:request];
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
            }
            [weakRequestAPI release];
        }];
    }else if ([driveName isEqualToString:BoxCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)BoxCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                BOOL res = [ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
                if (res) {
                    
                    //等待添加云盘
                    [self waitBindingDrive];
                }
            }else {
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                    [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
                }
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self checkResponseTypeWithFailed:request];
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
            }
            [weakRequestAPI release];
        }];
    }else if ([driveName isEqualToString:PCloudCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)PCloudCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                BOOL res =[ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
                if (res) {
                    
                    //等待添加云盘
                    [self waitBindingDrive];
                }
            }else {
                if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                    [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
                }
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self checkResponseTypeWithFailed:request];
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"bindDrive"];
            }
            [weakRequestAPI release];
        }];
    }else if ([driveName isEqualToString:FacebookCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)FacebookCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                [ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
            }else {
                
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakRequestAPI release];
        }];
    }else if ([driveName isEqualToString:TwitterCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)TwitterCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                [ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
            }else {
                
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakRequestAPI release];
        }];
    }else if ([driveName isEqualToString:InstagramCSEndPointURL]) {
        YTKRequest *requestAPI = [[AdditionalDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveName:(NSString *)InstagramCSEndPointURL];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                [ws openURL:[NSURL URLWithString:[[request userInfo] objectForKey:@"bindURL"]]];
            }else {
                
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [weakRequestAPI release];
        }];
    }
}

- (void)driveCancelAuthorizedWithName:(BaseDrive *)drive {
    YTKRequest *requestAPI = [[RemoveDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveID:drive.driveID];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                [_delegate driveAPIRequest:self withSuccess:request.responseJSONObject withType:@"cancelAuth"];
            }
            [self freeDrive:drive];
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"cancelAuth"];
            }
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkResponseTypeWithFailed:request];
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"cancelAuth"];
        }
        [weakRequestAPI release];
    }];
}

- (void)driveRenameAuthorizedWithName:(BaseDrive *)drive withNewName:(NSString *)newName {
    YTKRequest *requestAPI = [[RenameDriveAPI alloc] initWithUserLoginToken:_userLoginToken withDriveID:drive.driveID withDriveNewName:newName];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            if ([request responseData]) {
                if ([request responseJSONObject] && [[request responseJSONObject] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *tempDict = [request responseJSONObject];
                    drive.driveName = [tempDict objectForKey:@"name"];
                    if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                        [_delegate driveAPIRequest:self withSuccess:request.responseJSONObject withType:@"renameAuth"];
                    }
                }
            }
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"renameAuth"];
            }
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkResponseTypeWithFailed:request];
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"renameAuth"];
        }
        [weakRequestAPI release];
    }];
}

- (void)driveTopIndexWithDrive:(BaseDrive *)indexdrive {
    YTKRequest *requestAPI = [[TopIndexAPI alloc] initWithUserLoginToken:_userLoginToken withDriveID:indexdrive.driveID];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            //置顶方法
            [self getTopIndexWithDrive:indexdrive];
            if ([request responseData]) {
                if ([request responseJSONObject] && [[request responseJSONObject] isKindOfClass:[NSDictionary class]]) {
                    if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                        [_delegate driveAPIRequest:self withSuccess:request.responseJSONObject withType:@"setTopIndex"];
                    }
                }
            }
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"setTopIndex"];
            }
        }
        [weakRequestAPI release];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self checkResponseTypeWithFailed:request];
        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
            [_delegate driveAPIRequest:self withFailed:request.userInfo withType:@"setTopIndex"];
        }
        [weakRequestAPI release];
    }];
}

//获取保存的云盘
- (BaseDrive *)getSaveDrive:(NSString *)driveID {
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([driveID isEqualToString:[evaluatedObject driveID]]) {
            return YES;
        }else {
            return NO;
        }
    }];
    NSArray *returnAry = [[self driveArray] filteredArrayUsingPredicate:pre];
    if ([returnAry count] > 0) {
        return [returnAry firstObject];
    } else {
        return nil;
    }
}

#pragma mark -- 初始化、释放云服务状态
- (void)initDriveStatus:(BaseDrive *)drive {
    if (drive.isLoggedIn) {
        if (_delegate && [_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
            [_delegate driveDidLogIn:drive];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(driveDidLogOut:)]) {
            [_delegate driveDidLogOut:drive];
        }
    }
}

- (void)freeDrive:(BaseDrive *)drive {
    [self.driveArray removeObject:drive];
}

#pragma mark -- 等待接收添加的云盘
- (void)waitBindingDrive {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //创建socket
        int server_socket = 0;
        @try {
            struct sockaddr_in server_addr;
            server_addr.sin_len = sizeof(struct sockaddr_in);
            server_addr.sin_family = AF_INET;//Address families AF_INET互联网地址簇
            server_addr.sin_port = htons(58335);
            server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
            bzero(&(server_addr.sin_zero),8);
            
            server_socket = socket(AF_INET, SOCK_STREAM, 0);//SOCK_STREAM 有连接
            if (server_socket == -1) {
                perror("socket error");
            }
            
            //如果有占用端口的情况，先重置端口
            int yes = 1;
            if (setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, (const char *)&yes, sizeof(yes)) < 0) {
                perror("setsockopt error");
            }
            
            //绑定socket：将创建的socket绑定到本地的IP地址和端口，此socket是半相关的，只是负责侦听客户端的连接请求，并不能用于和客户端通信
            int bind_result = bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr));
            if (bind_result == -1) {
                bindInUsed++;
                perror("bind error");
            }
            
            //listen侦听 第一个参数是套接字，第二个参数为等待接受的连接的队列的大小，在connect请求过来的时候,完成三次握手后先将连接放到这个队列中，直到被accept处理。如果这个队列满了，且有新的连接的时候，对方可能会收到出错信息。
            if (listen(server_socket, 5) == -1) {
                perror("listen error");
            }
            
            struct sockaddr_in client_address;
            socklen_t address_len;
            int client_socket = accept(server_socket, (struct sockaddr *)&client_address, &address_len);
            //返回的client_socket为一个全相关的socket，其中包含client的地址和端口信息，通过client_socket可以和客户端进行通信。
            if (client_socket == -1) {
                perror("accept error");
            }
            
            char recv_msg[2048];
            char reply_msg[2048];
            
            while (1) {
                bzero(recv_msg, 2048);
                bzero(reply_msg, 2048);
                long byte_num = recv(client_socket,recv_msg,2048,0);
                recv_msg[byte_num] = '\0';
                NSString *msg = [[NSString alloc] initWithUTF8String:recv_msg];
                __block NSDictionary *returnDict = [[self parseStringToDictionary:msg] copy];
                [msg release];
                msg = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (returnDict && [[returnDict allKeys] count] > 0) {
                        if ([[returnDict objectForKey:@"action"] isEqualToString:@"drive"]) {
                            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                                [_delegate driveAPIRequest:self withSuccess:returnDict withType:@"bindDrive"];
                            }
                        }else if ([[returnDict objectForKey:@"action"] isEqualToString:@"user"]) {
                            if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withSuccess:withType:)]) {
                                NSString *code = [returnDict objectForKey:@"code"];
                                [self userLoginWithCode:code];
                            }
                        }
                    }else {
                        if (_delegate && [_delegate respondsToSelector:@selector(driveAPIRequest:withFailed:withType:)]) {
                            [_delegate driveAPIRequest:self withFailed:returnDict withType:@"bindDrive"];
                        }
                    }
                });
                if (returnDict && [[returnDict allKeys] count] > 0) {
                    break;
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"");
        } @finally {
            close(server_socket);
            if (bindInUsed > 0) {
                bindInUsed--;
                [self waitBindingDrive];
            }
        }
    });
}

- (NSMutableDictionary *)parseStringToDictionary:(NSString *)recvMsg {
    NSMutableDictionary *mutDict = nil;
    if ([recvMsg rangeOfString:@"action"].location != NSNotFound) {
        NSArray *msgAry = [recvMsg componentsSeparatedByString:@"{"];
        NSString *msgStr = [msgAry lastObject];
        NSString *replaceStr = [msgStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSArray *replaceAry = [replaceStr componentsSeparatedByString:@","];
        mutDict = [[NSMutableDictionary alloc] init];
        NSUInteger count = [replaceAry count];
        for (int i = 0; i < count; i++) {
            NSString *tmpStr = [replaceAry objectAtIndex:i];
            NSArray *tmpAry = [tmpStr componentsSeparatedByString:@":"];
            NSString *key = [[tmpAry objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *value = [[tmpAry objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [mutDict setObject:value forKey:key];
        }
    }
    return mutDict;
}

#pragma mark -- 检查请求响应的数据类型
- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest * _Nonnull)response {
    if ([response responseData]) {
        if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSDictionary class]]) {
            if ([[[response responseJSONObject] allKeys] containsObject:@"url"]) {
                NSString *url = nil;
                url = [[response responseJSONObject] objectForKey:@"url"];
                if (url) {
                    [response setUserInfo:@{@"bindURL": url}];
                }
                return ResponseSuccess;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"error"]) {
                NSDictionary *errorDict = [[response responseJSONObject] objectForKey:@"error"];
                NSString *errorStr = [errorDict objectForKey:@"code"];
                NSString *errorMessage = nil;
                if (errorStr) {
                    errorMessage = [errorDict objectForKey:@"message"];
                }else {
                    if ([[errorDict allKeys] containsObject:@"path"]) {
                        NSDictionary *dict = [errorDict objectForKey:@"path"];
                        if ([[dict allKeys] containsObject:@".tag"]) {
                            errorMessage = [dict objectForKey:@".tag"];
                        }
                    }
                }
                if ([errorStr isEqualToString:@"InvalidAuthenticationToken"]) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseTokenInvalid;
                }else if ([errorStr isEqualToString:@"The request timed out."]) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseTimeOut;
                }else if ([errorStr isEqualToString:@"invalidRequest"]) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseInvalid;
                }else {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseUnknown;
                }
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"errors"]) {
                NSDictionary *errorsDict = [[response responseJSONObject] objectForKey:@"errors"];
                NSArray *errorAry = [errorsDict allKeys];
                if ([errorAry count] > 0) {
                    id obj = [errorAry lastObject];
                    if (obj && [obj isKindOfClass:[NSString class]]) {
                        NSString *str = (NSString *)obj;
                        id errorMessage = nil;
                        if ([[errorsDict allKeys] containsObject:str]) {
                            errorMessage = [errorsDict objectForKey:str];
                            if ([errorMessage isKindOfClass:[NSArray class]]) {
                                NSArray *errorAry = (NSArray *)errorMessage;
                                [response setUserInfo:@{str: [errorAry lastObject]}];
                            }
                        }
                    }
                }
                return ResponseInvalid;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"context_info"]) {
                if ([[[response responseJSONObject] allKeys] containsObject:@"message"]) {
                    NSString *errorMessage = [[response responseJSONObject] objectForKey:@"message"];
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                }
                return ResponseInvalid;
            }else {
                return ResponseSuccess;
            }
        }else if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSArray class]]) {
            return ResponseSuccess;
        }else if ([response responseString] && [[response responseString] isKindOfClass:[NSString class]]) {
            NSString *errorStr = [response responseString];
            if ([errorStr rangeOfString:@"access token"].location != NSNotFound) {
                [response setUserInfo:@{@"errorMessage": @"The given OAuth 2 access token is malformed"}];
                return ResponseTokenInvalid;
            }else if ([errorStr isEqualToString:@""]) {
                return ResponseSuccess;
            }else {
                if (errorStr) {
                    [response setUserInfo:@{@"errorMessage": errorStr}];
                }
                return ResponseUnknown;
            }
        }else {
            [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
            return ResponseNotConnectedToInternet;
        }
    }else if ([[response error] localizedDescription]) {
        NSString *errorDescription = [[response error] localizedDescription];
        if ([errorDescription isEqualToString:@"InvalidAuthenticationToken"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTokenInvalid;
        }else if ([errorDescription isEqualToString:@"The request timed out."]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTimeOut;
        }else if ([errorDescription isEqualToString:@"invalidRequest"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseInvalid;
        }else {
            [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
            return ResponseNotConnectedToInternet;
        }
    }else {
        [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
        return ResponseNotConnectedToInternet;
    }
}

- (ResponseCode)checkResponseTypeWithFailed:(YTKBaseRequest * _Nonnull)response {
    if ([response responseData]) {
        if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSDictionary class]]) {
            if ([[[response responseJSONObject] allKeys] containsObject:@"error"]) {
                NSDictionary *errorDict = [[response responseJSONObject] objectForKey:@"error"];
                NSString *errorStr = [errorDict objectForKey:@"code"];
                NSString *errorMessage = [errorDict objectForKey:@"message"];
                if ([errorStr isEqualToString:@"InvalidAuthenticationToken"]) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseTokenInvalid;
                }else if ([errorStr isEqualToString:@"The request timed out."]) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseTimeOut;
                }else if ([errorStr isEqualToString:@"invalidRequest"]) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseInvalid;
                }else {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseUnknown;
                }
            }else {
                [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
                return ResponseNotConnectedToInternet;
            }
        }else if ([[[response responseJSONObject] allKeys] containsObject:@"errors"]) {
            NSDictionary *errorsDict = [[response responseJSONObject] objectForKey:@"errors"];
            NSArray *errorAry = [errorsDict allKeys];
            if ([errorAry count] > 0) {
                id obj = [errorAry lastObject];
                if (obj && [obj isKindOfClass:[NSString class]]) {
                    NSString *str = (NSString *)obj;
                    id errorMessage = nil;
                    if ([[errorsDict allKeys] containsObject:str]) {
                        errorMessage = [errorsDict objectForKey:str];
                        if ([errorMessage isKindOfClass:[NSArray class]]) {
                            NSArray *errorAry = (NSArray *)errorMessage;
                            [response setUserInfo:@{str: [errorAry lastObject]}];
                        }
                    }
                }
            }
            return ResponseInvalid;
        }else if ([response responseString] && [[response responseString] isKindOfClass:[NSString class]]) {
            NSString *errorStr = [response responseString];
            if ([errorStr rangeOfString:@"access token"].location != NSNotFound) {
                [response setUserInfo:@{@"errorMessage": @"The given OAuth 2 access token is malformed"}];
                return ResponseTokenInvalid;
            }else {
                if (errorStr) {
                    [response setUserInfo:@{@"errorMessage": errorStr}];
                }
                return ResponseUnknown;
            }
        }else {
            [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
            return ResponseNotConnectedToInternet;
        }
    }else if ([[response error] localizedDescription]) {
        NSError *error = [response error];
        NSString *errorDescription = [error localizedDescription];
        if (error.code == NSURLErrorNotConnectedToInternet) {
            [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
            return ResponseNotConnectedToInternet;
        }else if (error.code == NSURLErrorNetworkConnectionLost){
            [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
            return ResponseNetworkConnectionLost;
        }else if (error.code == NSURLErrorTimedOut) {
            [response setUserInfo:@{@"errorMessage": @"The request timed out."}];
            return ResponseTimeOut;
        }else if ([errorDescription isEqualToString:@"InvalidAuthenticationToken"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTokenInvalid;
        }else if ([errorDescription isEqualToString:@"The request timed out."]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTimeOut;
        }else if ([errorDescription isEqualToString:@"invalidRequest"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseInvalid;
        }else {
            [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
            return ResponseNotConnectedToInternet;
        }
    }else {
        [response setUserInfo:@{@"errorMessage": @"The network connection was lost"}];
        return ResponseNotConnectedToInternet;
    }
}

#pragma mark -- WebSocket Delegate

@end

@implementation LoginAuthorizationDriveEntity
@synthesize nickName = _nickName;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize avatar = _avatar;
@synthesize language = _language;
@synthesize email = _email;
@synthesize phone = _phone;
@synthesize country = _country;
@synthesize region = _region;
@synthesize city = _city;

- (instancetype)init {
    if (self == [super init]) {
        _nickName = @"";
        _firstName = @"";
        _lastName = @"";
        _avatar = @"";
        _language = @"";
        _email = @"";
        _phone = @"";
        _country = @"";
        _region = @"";
        _city = @"";
        _active = 0;
        _disable = 0;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc
{
    self.nickName = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.avatar = nil;
    self.language = nil;
    self.email = nil;
    self.phone = nil;
    self.country = nil;
    self.region = nil;
    self.city = nil;
    [super dealloc];
}

@end
