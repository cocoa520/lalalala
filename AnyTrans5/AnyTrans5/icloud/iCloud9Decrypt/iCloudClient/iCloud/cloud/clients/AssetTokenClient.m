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

static AssetTokenClient *_singleton = nil;

@implementation AssetTokenClient

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setICloudClientDelegate:nil];
    [self setDownloadAssistantDelegate:nil];
    [super dealloc];
#endif
}

+ (AssetTokenClient *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[AssetTokenClient alloc] init];
    });
    return _singleton;
}

/**
 *  Patched in iOS 11 Support
 *
 *  @param fileList 类型改为NSMutableDictionary
 */
+ (NSMutableArray *)assets:(CloudKitty *)kitty zone:(ProtectionZone *)zone fileList:(NSMutableDictionary *)fileList withCancel:(BOOL *)cancel {
    if (*cancel) {
        return nil;
    }
    NSMutableArray *nonEmptyFileList = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [fileList keyEnumerator];
    NSString *key = nil;
    while ((key = [enumerator nextObject])) {
        if (*cancel) {
            return nil;
        }
        if ([AssetExs isNonEmpty:key]) {
            [nonEmptyFileList addObject:key];
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
            if (*cancel) {
                return nil;
            }
            if ([recordResponse hasRecord]) {
                Record *tmpRecord = [recordResponse record];
                @autoreleasepool {
                    assetEx = [self asset:tmpRecord withAssetIDDomains:fileList zone:zone];
                    if (assetEx) {
                        BOOL isHasFile = NO;
                        if ([[assetEx domain] isEqualToString:@"HomeDomain"]) {
                            if (([[assetEx relativePath] rangeOfString:@"Library/CallHistoryDB/CallHistory.storedata"].location != NSNotFound) ||
                                ([[assetEx relativePath] rangeOfString:@"Library/AddressBook"].location != NSNotFound) ||
                                ([[assetEx relativePath] rangeOfString:@"Library/SMS/sms.db"].location != NSNotFound) ||
                                ([[assetEx relativePath] rangeOfString:@"Library/Voicemail"].location != NSNotFound) ||
                                ([[assetEx relativePath] rangeOfString:@"Library/Notes"].location != NSNotFound) ||
                                ([[assetEx relativePath] rangeOfString:@"Library/Calendar/Calendar.sqlitedb"].location != NSNotFound) ||
                                ([[assetEx relativePath] rangeOfString:@"Library/Safari"].location != NSNotFound)) {
                                isHasFile = YES;
                            }
                        }
                        if ([[assetEx domain] isEqualToString:@"AppDomain-com.apple.mobilesafari"]) {
                            if ([[assetEx relativePath] rangeOfString:@"Library/Safari/History.db"].location != NSNotFound) {
                                isHasFile = YES;
                            }
                        }
                        if ([[assetEx domain] isEqualToString:@"MediaDomain"] || [[assetEx domain] isEqualToString:@"CameraRollDomain"] || [[assetEx domain] isEqualToString:@"AppDomainGroup-group.com.apple.notes"]) {
                            isHasFile = YES;
                        }
                        if (isHasFile) {
                            [returnAry addObject:assetEx];
                        }else {
                            [[[AssetTokenClient singleton] iCloudClientDelegate] outputProgress:[[[AssetTokenClient singleton] downloadAssistantDelegate] getTotalSize] withCompleteSize:[assetEx size]];
                        }
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

/**
 *  Patched in iOS 11 Support
 *
 *  @param assetIDDomains 增加一个NSMutableDictionary类型参数
 *
 */
+ (AssetEx *)asset:(Record *)record withAssetIDDomains:(NSMutableDictionary *)assetIDDomains zone:(ProtectionZone *)zone {
    ProtectionZone *pZone = [[PZFactory instance] createWithBase:zone withProtectionInfo:[record protectionInfo]];
    if (!pZone) {
        pZone = zone;
    }
    NSString *recordId = [[[record recordIdentifier] value] name];
    NSString *domain = [assetIDDomains objectForKey:recordId];
    return [AssetExFactory from:record withDomain:domain withProtectionZone:pZone];
}

@end
