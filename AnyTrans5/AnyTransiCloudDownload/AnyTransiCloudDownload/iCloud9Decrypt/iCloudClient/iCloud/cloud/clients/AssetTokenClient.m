//
//  AssetTokenClient.m
//  
//
//  Created by iMobie on 7/25/16.
//
//  Complete

#import "AssetTokenClient.h"
#import "PZFactory.h"
#import "AssetExFactory.h"

@implementation AssetTokenClient

+ (NSMutableArray *)assetsFromAssetsList:(CloudKitty *)kitty zone:(ProtectionZone *)zone assetsList:(NSMutableArray *)assetsList {
    NSMutableArray *returnAry = nil;
    @autoreleasepool {
        NSMutableArray *fileList = [[NSMutableArray alloc] init];
        for (AssetExs *assetExs in assetsList) {
            NSMutableArray *tmpArray = [assetExs nonEmptyFiles];
            if (tmpArray != nil && tmpArray.count >0) {
                [fileList addObjectsFromArray:tmpArray];
            }
        }
        returnAry = [self assets:kitty zone:zone fileList:fileList];
#if !__has_feature(objc_arc)
        if (fileList) [fileList release]; fileList = nil;
#endif
        [returnAry retain];
    }
    return (returnAry ? [returnAry autorelease] : nil);
}

+ (NSMutableArray *)assets:(CloudKitty *)kitty zone:(ProtectionZone *)zone fileList:(NSArray *)fileList {
    NSMutableArray *nonEmptyFileList = [[NSMutableArray alloc] init];
    for (NSString *str in fileList) {
        if ([AssetExs isNonEmpty:str]) {
            [nonEmptyFileList addObject:str];
        }
    }
    
    NSMutableArray *returnAry = nil;
    if ([nonEmptyFileList count] == 0) {
#if !__has_feature(objc_arc)
        if (nonEmptyFileList) [nonEmptyFileList release]; nonEmptyFileList = nil;
#endif
        returnAry = [[NSMutableArray alloc] init];
    } else {
        NSMutableArray *responses = [kitty recordRetrieveRequest:@"_defaultZone" withRecordNames:nonEmptyFileList];
        returnAry = [[NSMutableArray alloc] init];
        AssetEx *assetEx = nil;
        for (RecordRetrieveResponse *recordResponse in responses) {
            if ([recordResponse hasRecord]) {
                Record *tmpRecord = [recordResponse record];
                @autoreleasepool {
                    assetEx = [self asset:tmpRecord zone:zone];
                    if (assetEx) {
                        [returnAry addObject:assetEx];
                    }
                }
            }
        }
#if !__has_feature(objc_arc)
        if (nonEmptyFileList) [nonEmptyFileList release]; nonEmptyFileList = nil;
#endif
    }
    
    return (returnAry ? [returnAry autorelease] : nil);
}

+ (AssetEx *)asset:(Record *)record zone:(ProtectionZone *)zone {
    ProtectionZone *pZone = [[PZFactory instance] createWithBase:zone withProtectionInfo:[record protectionInfo]];
    if (pZone != nil) {
        return [AssetExFactory from:record withProtectionZone:pZone];
    } else {
        return nil;
    }
}

@end
