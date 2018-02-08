//
//  MBKSyncClient.m
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import "MBKSyncClient.h"
#import "PZFactory.h"

@implementation MBKSyncClient

+ (ProtectionZone *)mbksync:(CloudKitty *)kitty keys:(NSMutableArray *)keys {
    ProtectionZone *zone = nil;
    @autoreleasepool {
        NSMutableArray *responses = [kitty zoneRetrieveRequest:@"_defaultZone", @"mbksync", nil];
        if ([responses count] !=2 ) {
            return nil;
        }
        zone = [[PZFactory instance] create:keys];
        NSMutableArray *protectionInfoList = [self zone:responses withZone:zone];
        for (ProtectionInfo *protectionInfo in protectionInfoList) {
            ProtectionZone *retzone = [[PZFactory instance] createWithBase:zone withProtectionInfo:protectionInfo];
            if (retzone) {
                zone = retzone;
            }
        }
        [zone retain];
    }
    return [zone autorelease];
}

+ (NSMutableArray*)zone:(NSMutableArray*)response withZone:(ProtectionZone*)zone {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (ZoneRetrieveResponse *zoneResponse in response) {
        NSArray *tmpAry = [zoneResponse zoneSummarysList];
        for (ZoneRetrieveResponseZoneSummary *zoneSummary in tmpAry) {
            if ([zoneSummary hasTargetZone]) {
                ZoneEx *ckzone = [zoneSummary targetZone];
                if ([ckzone hasProtectionInfo]) {
                    [returnAry addObject:[ckzone protectionInfo]];
                }
            }
        }
    }
    return returnAry;
}

@end
