//
//  Accounts.m
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import "Accounts.h"
#import "Headers.h"
#import "Auth.h"
#import "Account.h"
#import "AccountInfo.h"
#import "MobileMe.h"
#import "Tokens.h"
#import "AccountSettingsRequest.h"
#import "HttpClient.h"
#import "CategoryExtend.h"
#import "CommonDefine.h"

@implementation Accounts

+ (Account*)accountWithAuth:(Auth*)auth {
    Account *retAccount = nil;
    AccountSettingsRequest *accountSettingsRequest = [[AccountSettingsRequest alloc] init:[Headers coreHeaders]];
    if (accountSettingsRequest != nil) {
        NSMutableURLRequest *request = [accountSettingsRequest apply:auth.dsPrsID withPassword:auth.mmeAuthToken];
        NSData *responsedData =[HttpClient execute:request];
#if !__has_feature(objc_arc)
        [accountSettingsRequest release]; accountSettingsRequest = nil;
#endif
        if (responsedData) {
            NSDictionary *accountSettingsDict = [responsedData dataToDictionary];
            retAccount = [self accountWithDictionary:accountSettingsDict];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
        }
    }
    return retAccount;
}

+ (Account*)accountWithDictionary:(NSDictionary*)settings {
    if (settings != nil) {
        Account *acunt = nil;
        NSDictionary *accountInfoDict = nil;
        NSDictionary *mobileMe = nil;
        NSDictionary *tokensDict = nil;
        if ([settings.allKeys containsObject:@"appleAccountInfo"]) {
            accountInfoDict = [settings objectForKey:@"appleAccountInfo"];
        }
        if ([settings.allKeys containsObject:@"tokens"]) {
            tokensDict = [settings objectForKey:@"tokens"];
        }
        if ([settings.allKeys containsObject:@"com.apple.mobileme"]) {
            mobileMe = [settings objectForKey:@"com.apple.mobileme"];
        }
        if (accountInfoDict && tokensDict) {
            AccountInfo *tmpAccountInfo = [[AccountInfo alloc] init:accountInfoDict];
            MobileMe *tmpMobileMe = [[MobileMe alloc] init:mobileMe];
            Tokens *tmpTokens = [[Tokens alloc] init:tokensDict];
            acunt = [[[Account alloc] init:tmpMobileMe withAccountInfo:tmpAccountInfo withTokens:tmpTokens] autorelease];
#if !__has_feature(objc_arc)
            if (tmpAccountInfo) [tmpAccountInfo release]; tmpAccountInfo = nil;
            if (tmpMobileMe) [tmpMobileMe release]; tmpMobileMe = nil;
            if (tmpTokens) [tmpTokens release]; tmpTokens = nil;
#endif
        }
        return acunt;
    } else {
        return nil;
    }
}

@end
