//
//  Authenticator.m
//  
//
//  Created by Pallas on 1/8/16.
//
//  Complete

#import "Authenticator.h"
#import "AuthenticationRequest.h"
#import "HttpClient.h"
#import "Auth.h"
#import "CategoryExtend.h"
#import "CommonDefine.h"

@interface Authenticator ()

@property (nonatomic, readwrite, retain) AuthenticationRequest *request;

@end

@implementation Authenticator
@synthesize request = _request;

- (id)init:(Headers*)headers {
    if (self = [super init]) {
        AuthenticationRequest *tempRequest = [[AuthenticationRequest alloc] init:headers];
        [self setRequest:tempRequest];
#if !__has_feature(objc_arc)
        if (tempRequest) [tempRequest release]; tempRequest = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_request != nil) [_request release]; _request = nil;
    [super dealloc];
#endif
}

- (Auth*)authenticate:(NSString*)appleId withPassword:(NSString*)password {
    NSData *responsedData = [HttpClient execute:[self.request apply:appleId withPassword:password]];
    NSDictionary *authentication = [responsedData dataToDictionary];
    if (!authentication) {
        return nil;
    }
    NSArray *allKey = authentication.allKeys;
    NSString *dsPrsID = nil;
    NSString *mmeAuthToken = nil;
    if ([allKey containsObject:@"appleAccountInfo"]) {
        NSDictionary *appleAccountInfo = [authentication objectForKey:@"appleAccountInfo"];
        if ([appleAccountInfo.allKeys containsObject:@"dsPrsID"]) {
            dsPrsID = (NSString*)[appleAccountInfo objectForKey:@"dsPrsID"];
        }
    }
    if ([allKey containsObject:@"tokens"]) {
        NSDictionary *tokens = [authentication objectForKey:@"tokens"];
        if ([tokens.allKeys containsObject:@"mmeAuthToken"]) {
            mmeAuthToken = (NSString*)[tokens objectForKey:@"mmeAuthToken"];
        }
    }
    if ([allKey containsObject:@"localizedError"]) {
        NSString *localizedErrorStr = (NSString*)[authentication objectForKey:@"localizedError"];
        if ([localizedErrorStr isEqualToString:@"ACCOUNT_INVALID_HSA_TOKEN"]) {
            NSString *two_step = (NSString*)[authentication objectForKey:@"message"];
            NSDictionary *dic = @{@"Two_Step" : two_step};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_APPLE_ID_PROTECTED_TWO_STEP_AUTHENTICATION_FAILURE object:nil userInfo:dic];
            return nil;
        }
    }
    if (dsPrsID == nil || mmeAuthToken == nil) {
        return nil;
    }
    return [[[Auth alloc] init:dsPrsID withMmeAuthToken:mmeAuthToken] autorelease];
}

@end
