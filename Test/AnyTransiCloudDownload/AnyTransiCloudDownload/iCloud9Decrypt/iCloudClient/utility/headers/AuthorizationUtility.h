//
//  AuthorizationUtility.h
//  CleanMac-OC
//
//  Created by iMobie on 12/12/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AUTH_WORD @"We Need Permission To Make Changes"

@interface AuthorizationUtility : NSObject
{
    AuthorizationRef _authorizationRef;
    OSStatus _status;
    BOOL _needAuthorize;

}

@property (nonatomic,assign) AuthorizationRef authorizationRef;
@property (nonatomic,assign) OSStatus status;
@property (nonatomic,assign) BOOL needAuthorize;

+ (AuthorizationUtility *)singleton;
- (void)clearAuthorizeInfo;

@end
