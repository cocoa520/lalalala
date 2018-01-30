//
//  IMBBooksPlist.m
//  iMobieTrans
//
//  Created by Pallas on 1/24/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBooksPlist.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "StringHelper.h"
@implementation IMBBooksPlist
@synthesize remotingFilePath = _remotingFilePath;
@synthesize localFilePath = _localFilePath;

- (id)init {
    self = [super init];
    if (self) {
        fm = [NSFileManager defaultManager];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (NSMutableDictionary*)parsePlist:(IMBiPod*)ipod isSync:(BOOL)isSync{
    NSMutableDictionary *plistDic = nil;
    _remotingFilePath = [[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books/Books.plist"];
    if (![[ipod fileSystem] fileExistsAtPath:_remotingFilePath]) {
        _remotingFilePath = [[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books/Sync/Books.plist"];
    }
    if (!isSync) {
        _localFilePath = [[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"syncIb.plist"];
    }
    else{
        _localFilePath = [[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"syncIb.plist"];
    }
    if ([fm fileExistsAtPath:_localFilePath]) {
        [fm removeItemAtPath:_localFilePath error:nil];
    }
    if ([[ipod fileSystem] fileExistsAtPath:_remotingFilePath] &&
        [[ipod fileSystem] getFileLength:_remotingFilePath] > 0) {
        [[ipod fileSystem] copyRemoteFile:_remotingFilePath toLocalFile:_localFilePath];
        if ([fm fileExistsAtPath:_localFilePath]) {
            plistDic = [NSMutableDictionary dictionaryWithContentsOfFile:_localFilePath];
        }
    }
    return plistDic;
}

- (BOOL)saveiBookPlist:(IMBiPod*)ipod contentDic:(NSMutableDictionary*)contentDic {
    BOOL ret = NO;
    if ([StringHelper stringIsNilOrEmpty:_localFilePath] == YES) {
        _localFilePath = [[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"syncIb.plist"];
    }
    if ([StringHelper stringIsNilOrEmpty:_remotingFilePath] == YES) {
        _remotingFilePath = [[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books/Books.plist"];
    }
    if ([fm fileExistsAtPath:_localFilePath]) {
        [fm removeItemAtPath:_localFilePath error:nil];
    }

    if ([contentDic writeToFile:_localFilePath atomically:YES]) {
        if ([fm fileExistsAtPath:_localFilePath] &&
            [[fm attributesOfItemAtPath:_localFilePath error:nil] fileSize] > 0) {
            if ([[ipod fileSystem] fileExistsAtPath:_remotingFilePath]) {
                [[ipod fileSystem] rename:_remotingFilePath newPath:[_remotingFilePath stringByAppendingString:@"_Backup"]];
            }
            @try {
                if ([[ipod fileSystem] copyLocalFile:_localFilePath toRemoteFile:_remotingFilePath]) {
                    if ([[ipod fileSystem] fileExistsAtPath:[_remotingFilePath stringByAppendingString:@"_Backup"]]) {
                        [[ipod fileSystem] unlink:[_remotingFilePath stringByAppendingString:@"_Backup"]];
                    }
                    ret = YES;
                } else {
                    if ([[ipod fileSystem] fileExistsAtPath:[_remotingFilePath stringByAppendingString:@"_Backup"]]) {
                        [[ipod fileSystem] unlink:_remotingFilePath];
                        [[ipod fileSystem] rename:[_remotingFilePath stringByAppendingString:@"_Backup"] newPath:_remotingFilePath];
                    }
                }
            }
            @catch (NSException *exception) {
                if ([[ipod fileSystem] fileExistsAtPath:[_remotingFilePath stringByAppendingString:@"_Backup"]]) {
                    [[ipod fileSystem] unlink:_remotingFilePath];
                    [[ipod fileSystem] rename:[_remotingFilePath stringByAppendingString:@"_Backup"] newPath:_remotingFilePath];
                }
            }
            @finally {
                [fm removeItemAtPath:_localFilePath error:nil];
            }
        } else {
            if ([fm fileExistsAtPath:_localFilePath]) {
                [fm removeItemAtPath:_localFilePath error:nil];
            }
        }
    } else {
        ret = NO;
    }
    return ret;
}

- (BOOL)synciBookPlist:(IMBiPod*)ipod contentDic:(NSMutableDictionary*)contentDic {
    BOOL ret = NO;
    if ([StringHelper stringIsNilOrEmpty:_localFilePath] == YES) {
        _localFilePath = [[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"syncIb.plist"];
    }
    if ([StringHelper stringIsNilOrEmpty:_remotingFilePath] == YES) {
        _remotingFilePath = [[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books/Books.plist"];
    }
    if ([fm fileExistsAtPath:_localFilePath]) {
        [fm removeItemAtPath:_localFilePath error:nil];
    }
    if ([contentDic writeToFile:_localFilePath atomically:YES]) {
        if ([fm fileExistsAtPath:_localFilePath] &&
            [[fm attributesOfItemAtPath:_localFilePath error:nil] fileSize] > 0) {
            NSLog(@"success");
            ret = YES;
        } else {
            if ([fm fileExistsAtPath:_localFilePath]) {
                [fm removeItemAtPath:_localFilePath error:nil];
            }
        }
    } else {
        ret = NO;
    }
    return ret;
}

- (BOOL)synciBookPlistAfterDelete:(IMBiPod *)ipod contentDic:(NSMutableDictionary *)contentDic
{
    BOOL ret = NO;
    if ([StringHelper stringIsNilOrEmpty:_localFilePath] == YES) {
        _localFilePath = [[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"syncIb.plist"];
    }
    NSString *airSyncRemoteFilePath = nil;
    airSyncRemoteFilePath = [[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Airlock/Book"];
    NSString *plistName = @"Books.plist";
    if (![[ipod fileSystem] fileExistsAtPath:airSyncRemoteFilePath]) {
        [[ipod fileSystem] mkDir:airSyncRemoteFilePath];
    }
    
    if ([fm fileExistsAtPath:_localFilePath]) {
        [fm removeItemAtPath:_localFilePath error:nil];
    }
    
    if ([contentDic writeToFile:_localFilePath atomically:YES]) {
        if ([fm fileExistsAtPath:_localFilePath] &&
            [[fm attributesOfItemAtPath:_localFilePath error:nil] fileSize] > 0) {
            if ([[ipod fileSystem] fileExistsAtPath:airSyncRemoteFilePath]) {
                
                airSyncRemoteFilePath = [airSyncRemoteFilePath stringByAppendingPathComponent:plistName];
                
                [[ipod fileSystem] copyLocalFile:_localFilePath toRemoteFile:airSyncRemoteFilePath];
            }
        } else {
            if ([fm fileExistsAtPath:_localFilePath]) {
                [fm removeItemAtPath:_localFilePath error:nil];
            }
        }
    } else {
        ret = NO;
    }
    return ret;
}

- (void)deletePlistItem:(NSArray*)dbIDArray ipod:(IMBiPod*)ipod isSync:(BOOL)isSync{
    NSMutableDictionary *plistDic = [[self parsePlist:ipod isSync:isSync] retain];
    if (plistDic != nil && [plistDic count] > 0) {
        NSMutableArray *booksArray = [plistDic objectForKey:@"Books"];
        if (booksArray != nil && [booksArray count] > 0) {
            [self searchBook:booksArray dbIDArray:dbIDArray];
        }
//        if (isSync) {
        [self synciBookPlistAfterDelete:ipod contentDic:plistDic];
//        }
//        [self saveiBookPlist:ipod contentDic:plistDic];
    }
    [plistDic release];
    plistDic = nil;
}

- (void)searchBook:(NSMutableArray*)booksArray dbIDArray:(NSArray*)dbIDArray {
    if (booksArray != nil && [booksArray count] > 0) {
        NSMutableArray *removeArray = [[NSMutableArray alloc] init];
        for (id item in booksArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                NSDictionary *bookInfoDic = (NSDictionary*)item;
                NSString *perID = nil;
                if (bookInfoDic != nil && [bookInfoDic count] > 0) {
                    if ([[bookInfoDic allKeys] containsObject:@"Persistent ID"]) {
                        perID = [bookInfoDic valueForKey:@"Persistent ID"];
                    } else {
                        perID = @"";
                    }
                    NSString *searchDBID = nil;
                    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                        return [(NSString*)evaluatedObject isEqualToString:perID];
                    }];
                    NSArray *perArray = [dbIDArray filteredArrayUsingPredicate:pre];
                    if (perArray != nil && [perArray count] > 0) {
                        searchDBID = [perArray objectAtIndex:0];
                    }
                    if (![StringHelper stringIsNilOrEmpty:searchDBID]) {
                        [removeArray addObject:item];
                    }
                }
            }
        }
        if (removeArray != nil && [removeArray count] > 0) {
            for (id item in removeArray) {
                [booksArray removeObject:item];
            }
        }
        [removeArray release];
        removeArray = nil;
    }
}
@end
