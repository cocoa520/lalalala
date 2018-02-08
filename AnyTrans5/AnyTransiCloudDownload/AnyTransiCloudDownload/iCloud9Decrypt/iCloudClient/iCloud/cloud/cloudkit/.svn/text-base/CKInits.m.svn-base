//
//  CKInits.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "CKInits.h"
#import "CKInit.h"
#import "Account.h"
#import "AccountInfo.h"
#import "Tokens.h"
#import "CkAppInitBackupRequest.h"
#import "HttpClient.h"
#import "CategoryExtend.h"
#import "CommonDefine.h"

@implementation CKInits

+ (CKInit*)ckInitBackupd:(Account*)account {
    return [self ckInit:account withBundle:@"com.apple.backupd" withContainer:@"com.apple.backup.ios"];
}

+ (CKInit*)ckInit:(Account*)account withBundle:(NSString*)bundle withContainer:(NSString*)container {
    NSString *dsPrsID = [[account accountInfo] dsPrsID];
    NSString *mmeAuthToken = [[account tokens] get:MMEAUTHTOKEN];
    NSString *cloudKitToken = [[account tokens] get:CLOUDKITTOKEN];
    
    NSMutableURLRequest *ckAppInitRequest = [[CkAppInitBackupRequest singleton] newRequest:dsPrsID withMmeAuthToken:mmeAuthToken withCloudKitAuthToken:cloudKitToken withBundle:bundle withContainer:container];
    NSData *responsedData = [HttpClient execute:ckAppInitRequest];
    NSDictionary *jsonDict = nil;
    if (responsedData) {
        id obj = [responsedData jsonDataToArrayOrNSDictionary];
        if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
            jsonDict = (NSDictionary*)obj;
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
        return nil;
    }
    if (jsonDict == nil || jsonDict.allKeys.count == 0) {
        return nil;
    }
    NSString *cloudKitDatabaseUrl = nil;
    NSString *cloudKitDeviceUrl = nil;
    NSString *cloudKitShareUrl = nil;
    NSString *cloudKitUserId = nil;
    NSArray *valuesArray = nil;
    
    NSArray *allKeys = jsonDict.allKeys;
    if ([allKeys containsObject:@"cloudKitDatabaseUrl"]) {
        cloudKitDatabaseUrl = (NSString*)[jsonDict objectForKey:@"cloudKitDatabaseUrl"];
    }
    if ([allKeys containsObject:@"cloudKitDeviceUrl"]) {
        cloudKitDeviceUrl = (NSString*)[jsonDict objectForKey:@"cloudKitDeviceUrl"];
    }
    if ([allKeys containsObject:@"cloudKitShareUrl"]) {
        cloudKitShareUrl = (NSString*)[jsonDict objectForKey:@"cloudKitShareUrl"];
    }
    if ([allKeys containsObject:@"cloudKitUserId"]) {
        cloudKitUserId = (NSString*)[jsonDict objectForKey:@"cloudKitUserId"];
    }
    if ([allKeys containsObject:@"values"]) {
        valuesArray = (NSArray*)[jsonDict objectForKey:@"values"];
    }
    CKInit *ckInit = [[[CKInit alloc] init:cloudKitDeviceUrl withCloudKitDatabaseUrl:cloudKitDatabaseUrl withContainers:valuesArray withCloudKitShareUrl:cloudKitShareUrl withCloudKitUserId:cloudKitUserId] autorelease];
    return ckInit;
}

@end
