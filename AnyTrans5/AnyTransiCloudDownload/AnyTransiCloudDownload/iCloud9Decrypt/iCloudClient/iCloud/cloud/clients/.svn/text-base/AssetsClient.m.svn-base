//
//  AssetsClient.m
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import "AssetsClient.h"
#import "PZFactory.h"
#import "AssetExsFactory.h"
#import "CategoryExtend.h"

@interface AtomicRefrence : NSObject {
@private
    ProtectionZone *_previous;
}

@property (nonatomic, readwrite, retain) ProtectionZone *previous;

- (id)initWithZone:(ProtectionZone*)zone;

@end

@implementation AssetsClient

+ (NSMutableArray *)assets:(CloudKitty *)kitty zone:(ProtectionZone *)zone manifests:(NSArray *)manifests withCancel:(BOOL *)cancel {
    NSMutableArray *assetsAry = nil;
    @autoreleasepool {
        if ([manifests count] == 0) {
            assetsAry = [[NSMutableArray alloc] init];
        } else {
            NSMutableArray *manifestIDs = [[NSMutableArray alloc] init];
            for (Manifest *mani in manifests) {
                if (*cancel) {
                    return nil;
                }
                for (NSString *str in [self manifestIDs:mani]) {
                    if (*cancel) {
                        return nil;
                    }
                    [manifestIDs addObject:str];
                }
            }
            AtomicRefrence *previous = [[AtomicRefrence alloc] initWithZone:zone];
            NSMutableArray *responses = [kitty recordRetrieveRequest:@"_defaultZone" withRecordNames:manifestIDs];
#if !__has_feature(objc_arc)
            if (manifestIDs) [manifestIDs release]; manifestIDs = nil;
#endif
            assetsAry = [[NSMutableArray alloc] init];
            for (RecordRetrieveResponse *resp in responses) {
                if (*cancel) {
                    break;
                }
                if ([resp hasRecord]) {
                    AssetExs *asset = [self assets:[resp record] zone:zone previous:previous];
                    if (asset) {
                        [assetsAry addObject:asset];
                    }
                }
            }
#if !__has_feature(objc_arc)
            if (previous) [previous release]; previous = nil;
#endif
        }
    }
    return (assetsAry ? [assetsAry autorelease] : nil);
}

+ (NSMutableArray *)manifestIDs:(Manifest *)manifest {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < [manifest count]; i++) {
        [returnAry addObject:[NSString stringWithFormat:@"%@:%d", [manifest iD], i]];
    }
    return returnAry;
}

+ (AssetExs *)assets:(Record *)record zone:(ProtectionZone *)zone previous:(AtomicRefrence *)previous {
    ProtectionZone *proZone = [[PZFactory instance] createWithBase:zone withProtectionInfo:[record protectionInfo]];
    if (proZone) {
        [previous setPrevious:proZone];
        return [AssetExsFactory from:record withProtectionZone:proZone];
    }else {
        return [AssetExsFactory from:record withProtectionZone:[previous previous]];
    }
}

@end

@implementation AtomicRefrence
@synthesize previous = _previous;

- (id)initWithZone:(ProtectionZone *)zone {
    if (self = [super init]) {
        self.previous = zone;
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setPrevious:nil];
    [super dealloc];
#endif
}

@end

