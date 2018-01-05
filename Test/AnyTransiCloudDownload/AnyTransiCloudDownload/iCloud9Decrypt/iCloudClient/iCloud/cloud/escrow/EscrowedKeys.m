//
//  EscrowedKeys.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "EscrowedKeys.h"
#import "Account.h"
#import "AccountInfo.h"
#import "Tokens.h"
#import "MobileMe.h"
#import "EscrowProxyRequest.h"
#import "HttpClient.h"
#import "CategoryExtend.h"
#import "EscrowOperationsRecover.h"
#import "DERUtils.h"
#import "KeySet.h"
#import "ServiceKeySet.h"
#import "ServiceKeySetBuilder.h"
#import "ProtectedRecord.h"
#import <objc/runtime.h>

@implementation EscrowedKeys

static int REMAINING_ATTEMPTS_THRESHOLD = 3;

+ (EscrowProxyRequest*)requestFactory:(Account*)account {
    return [[[EscrowProxyRequest alloc] initWithDsPrsID:[[account accountInfo] dsPrsID] withMmeAuthToken:[[account tokens] get:MMEAUTHTOKEN] withEscrowProxyUrl:[[account mobileMe] get:@"com.apple.Dataclass.KeychainSync" withKey:@"escrowProxyUrl"]] autorelease];
}

+ (ServiceKeySet*)keysWithAccount:(Account*)account {
    ServiceKeySet *sksVal = nil;
    @autoreleasepool {
        EscrowProxyRequest *escrowProxyRequest = [[EscrowProxyRequest alloc] initWithDsPrsID:[[account accountInfo] dsPrsID] withMmeAuthToken:[[account tokens] get:MMEAUTHTOKEN] withEscrowProxyUrl:[[account mobileMe] get:@"com.apple.Dataclass.KeychainSync" withKey:@"escrowProxyUrl"]];
        sksVal = [[self keysWithRequests:escrowProxyRequest] retain];
#if !__has_feature(objc_arc)
        if (escrowProxyRequest != nil) [escrowProxyRequest release]; escrowProxyRequest = nil;
#endif
    }
    return [sksVal autorelease];
}

+ (ServiceKeySet*)keysWithRequests:(EscrowProxyRequest*)requests {
    return [self keysWithRequests:requests withRemainingAttemptsThreshold:REMAINING_ATTEMPTS_THRESHOLD];
}

+ (ServiceKeySet*)keysWithRequests:(EscrowProxyRequest *)requests withRemainingAttemptsThreshold:(int)remainingAttemptsThreshold {
    NSMutableURLRequest *urlRequest = [requests getRecords];
    NSData *responsedData = [HttpClient execute:urlRequest];
    if (!responsedData) {
        return nil;
    }
    NSDictionary *records = [responsedData dataToDictionary];
    if (!records) {
        return nil;
    }
    NSDictionary *record = [self pcsRecord:records];
    
    [self validateRemainingAttempts:record withThreshold:remainingAttemptsThreshold];
    
    NSDictionary *escrowedData = [EscrowOperationsRecover recover:requests];
    
    ServiceKeySet *backupBagPassword = [EscrowedKeys backupBagPassword:escrowedData];
    
    return [EscrowedKeys escrowedKeys:record withBackupBagPassword:backupBagPassword];
}


+ (void)validateRemainingAttempts:(NSDictionary*)record withThreshold:(int)threshold {
    int remainingAttempts = [self remainingAttempts:record];
    
    if (remainingAttempts < threshold) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:[NSString stringWithFormat:@"srp minimum remaining attempts threshold exceeded: %d", threshold] userInfo:nil];
    }
}


+ (int)remainingAttempts:(NSDictionary*)record {
    if (record != nil && [record.allKeys containsObject:@"remainingAttempts"]) {
        id obj = [record objectForKey:@"remainingAttempts"];
        if (obj != nil && [obj isKindOfClass:[NSString class]]) {
            NSString *remainingAttempts = (NSString*)obj;
            return [remainingAttempts intValue];
        }
    }
    return 0;
}

+ (NSDictionary*)pcsRecord:(NSDictionary*)records {
    if (records != nil && [records.allKeys containsObject:@"metadataList"]) {
        id obj = [records objectForKey:@"metadataList"];
        if (obj != nil && [obj isKindOfClass:[NSArray class]]) {
            NSArray *metadataList = (NSArray*)obj;
            for (id item in metadataList) {
                if ([EscrowedKeys isPCSRecord:item]) {
                    return (NSDictionary*)item;
                }
            }
        }
    }
    @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"no escrow PCS record found" userInfo:nil];
}

+ (BOOL)isPCSRecord:(id)metadata {
    if (metadata != nil && [metadata isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*)metadata;
        if ([dict.allKeys containsObject:@"label"]) {
            NSString *labelStr = (NSString*)[dict objectForKey:@"label"];
            if ([labelStr isEqualToString:@"com.apple.protectedcloudstorage.record"]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (ServiceKeySet*)backupBagPassword:(NSDictionary*)escrowedData {
    NSMutableData *backupBagPassword = nil;
    if (escrowedData != nil && [escrowedData.allKeys containsObject:@"BackupBagPassword"]) {
        id obj = [escrowedData objectForKey:@"BackupBagPassword"];
        if (obj != nil && [obj isKindOfClass:[NSData class]]) {
            backupBagPassword= [(NSData*)obj mutableCopy];
        }
    }
    if (backupBagPassword != nil) {
        SEL selector = @selector(initWithASN1Primitive:);
        Class classType = [KeySet class];
        IMP imp = class_getMethodImplementation(classType, selector);
        id obj = [DERUtils parseWithData:backupBagPassword withClassType:classType withSel:selector withFunction:imp];
#if !__has_feature(objc_arc)
        if (backupBagPassword) [backupBagPassword release]; backupBagPassword = nil;
#endif
        if (obj != nil && [obj isKindOfClass:classType]) {
            return [ServiceKeySetBuilder buildWithKeySet:(KeySet*)obj];
        }else {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"failed to create backup bag key set" userInfo:nil];
        }
    }
    return 0;
}

+ (ServiceKeySet*)escrowedKeys:(NSDictionary*)record withBackupBagPassword:(ServiceKeySet*)backupBagPassword {
    NSString *metadataBase64 = nil;
    if (record != nil && [record.allKeys containsObject:@"metadata"]) {
        id obj = [record objectForKey:@"metadata"];
        if (obj != nil && [obj isKindOfClass:[NSString class]]) {
            metadataBase64 = (NSString*)obj;
        }
    }
    NSData *metadata = nil;
    if (![NSString isNilOrEmpty:metadataBase64]) {
        metadata = [Base64Codec dataFromBase64String:metadataBase64];
    }
    NSMutableData *data = nil;
    if (metadata != nil) {
        SEL selector = @selector(keyWithKeyID:);
        IMP imp = class_getMethodImplementation([backupBagPassword class], selector);
        data = [ProtectedRecord unlockData:metadata withTarget:backupBagPassword withSel:selector withFunction:imp];
    }
    SEL selector = @selector(initWithASN1Primitive:);
    Class classType = [KeySet class];
    IMP imp = class_getMethodImplementation(classType, selector);
    id obj = [DERUtils parseWithData:data withClassType:classType withSel:selector withFunction:imp];
    if (obj != nil && [obj isKindOfClass:classType]) {
        return [ServiceKeySetBuilder buildWithKeySet:(KeySet*)obj];
    }else {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"failed to create backup bag key set" userInfo:nil];
    }
}

@end
