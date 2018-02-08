//
//  AuthorizationUtility.m
//  CleanMac-OC
//
//  Created by iMobie on 12/12/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "AuthorizationUtility.h"

@implementation AuthorizationUtility

@synthesize authorizationRef = _authorizationRef;
@synthesize status = _status;
@synthesize needAuthorize = _needAuthorize;

- (id)init {
    if (self = [super init]) {
        _needAuthorize = YES;
    }
    return self;
}

+ (AuthorizationUtility *)singleton
{
    static AuthorizationUtility *token = nil;
    @synchronized(self)
    {
        if (token == nil) {
            token = [[AuthorizationUtility alloc] init];
            token.authorizationRef = NULL;
            token.status = NSURLHandleNotLoaded;
        }
    }
    return token;
}

- (void)clearAuthorizeInfo{
    self.authorizationRef = NULL;
    self.status = NSURLHandleNotLoaded;
}

@end
