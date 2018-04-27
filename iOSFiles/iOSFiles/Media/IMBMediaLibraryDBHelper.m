//
//  IMBMediaLibraryDBHelper.m
//  iMobieTrans
//
//  Created by iMobie on 5/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBMediaLibraryDBHelper.h"
#import "IMBSqliteTables_5.h"
#import "IMBDeviceInfo.h"
#import "NSString+Category.h"
#import "IMBFileSystem.h"
#import "IMBTrack.h"
#import "NSData+Category.h" 
//#import "IMBCategoryExtend.h"
@implementation IMBMediaLibraryDBHelper

- (id)initWithIpod:(IMBiPod *)ipod{
    if (self = [super init]) {
        _ipod = [ipod retain];
    }
    return self;
}

- (void)dealloc{
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    
    if(_libraryConnection != nil){
        [_libraryConnection release];
        _libraryConnection = nil;
    }
    [super dealloc];
}

- (BOOL)openDatabase{
    BOOL result = true;
    @try {
        if (_ipod == nil) {
            return false;
        }
//        if (IsStringNilOrEmpty(_ipod.mediaDBPath)) {
            IMBSqliteTables_5 *sqliteTables_5 = [[IMBSqliteTables_5 alloc] initWithIPod:_ipod];
            [sqliteTables_5 exactDeviceDBFiles];
            [sqliteTables_5 autorelease];
            if (IsStringNilOrEmpty(_ipod.mediaDBPath)) {
                return false;
            }
//        }
        _libraryConnection = [[FMDatabase databaseWithPath:_ipod.mediaDBPath] retain];
        if ([_libraryConnection open]) {
            [_libraryConnection setShouldCacheStatements:NO];
            [_libraryConnection setTraceExecution:NO];
        }
        else{
            _ipod.mediaDamage = YES;
        }
        result = true;
    }
    @catch (NSException *exception) {
        result = false;
    }
    @finally {
        return result;
    }
}

- (void)closeDB{
    if(_libraryConnection != nil){
        [_libraryConnection close];
        [_libraryConnection release];
        _libraryConnection = nil;
    }
}

//- (void)readNewIosArtworkItems:(NSArray *)mediaTracks{
//    NSString *querySql = @"";
//    FMResultSet *rs = nil;
//    NSArray *resultTrack = [mediaTracks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType != %d && mediaType != %d && mediaType != %d && mediaType != %d",VoiceMemo,Books,PDFBooks,Ringtone]];
//    for (IMBTrack *item in resultTrack) {
//        NSLog(@"%@",[IMBHelper getMediaType:item.mediaType]);
//        querySql = [NSString stringWithFormat:@"select item_pid,relative_path from item_artwork,artwork where item_artwork.sync_artwork_token=artwork.artwork_token and item_artwork.item_pid =(select item_pid from item_store where sync_id = %lld)",[item dbID]];
//        rs = [_libraryConnection executeQuery:querySql];
//        while (rs.next) {
//            IMBArtworkEntity *artworkItem = [[IMBArtworkEntity alloc] init];
//            NSString *filePath = [rs stringForColumn:@"relative_path"] != nil ? [rs stringForColumn:@"relative_path"] : @"";
//            if ([IMBHelper stringIsNilOrEmpty:filePath]) {
//                continue;
//            }
//            artworkItem.filePath = [NSString stringWithFormat:@"/iTunes_Control/iTunes/Artwork/%@",filePath];
//            if (![_ipod.fileSystem fileExistsAtPath:artworkItem.filePath]) {
//                artworkItem.filePath = [NSString stringWithFormat:@"/iTunes_Control/iTunes/Artwork/Originals/%@",filePath];
//            }
//            [item.artwork addObject:artworkItem];
//        }
//    }
//}

- (void)readNewIosArtworkItems:(NSArray *)mediaTracks{
    NSString *querySql = @"";
    FMResultSet *rs = nil;
    for (IMBTrack *track in mediaTracks) {
        querySql = [NSString stringWithFormat:@"select sync_artwork_token from item_artwork where item_artwork.item_pid=(select item_pid from item_store where sync_id = %lld)",[track dbID]];
        rs = [_libraryConnection executeQuery:querySql];
        while (rs.next) {
            IMBArtworkEntity *artworkItem = [[IMBArtworkEntity alloc] init];
            long long synctoken = [rs longLongIntForColumn:@"sync_artwork_token"];
            NSString *hash = [self convertArtworkCacheID:synctoken];
            NSString *filepath = [self GetIos8ArtworkFileName:hash];
            artworkItem.filePath = filepath;
            [track.artwork addObject:artworkItem];
            [artworkItem release];
        }
        
    }
}

- (void)getArtWorkPathiOS9:(NSArray *)mediaTracks
{
    NSString *folderPath = @"/iTunes_Control/iTunes/Artwork/Originals";
    NSString *querySql = @"";
    FMResultSet *rs = nil;
    for (IMBTrack *track in mediaTracks) {
      querySql = @"select relative_path from artwork where artwork.artwork_token = (select artwork_token from artwork_token where entity_pid = (select item_pid from item_store where sync_id =:sycID))";
        NSDictionary *params = [NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:[track dbID]] forKey:@"sycID"];
        rs = [_libraryConnection executeQuery:querySql withParameterDictionary:params];
        while ([rs next]) {
             NSString *relativePath = [rs stringForColumn:@"relative_path"];
            IMBArtworkEntity *artworkItem = [[IMBArtworkEntity alloc] init];
            artworkItem.filePath = [NSString stringWithFormat:@"%@/%@",folderPath,relativePath];
            [track.artwork addObject:artworkItem];
            [artworkItem release];
           
        }
        [rs close];

    }
    [_libraryConnection close];
}

- (void)getArtWorkPathiOS8Point3:(NSArray *)mediaTracks
{
    
    NSString *folderPath = @"/iTunes_Control/iTunes/Artwork/Originals";
    NSString *querySql = @"";
    FMResultSet *rs = nil;
    for (IMBTrack *track in mediaTracks) {
        querySql = @"select relative_path from artwork where artwork.artwork_token =(select sync_artwork_token from item_artwork where item_pid = (select item_pid from item_store where sync_id =:sycID))";
        NSDictionary *params = [NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:[track dbID]] forKey:@"sycID"];
        rs = [_libraryConnection executeQuery:querySql withParameterDictionary:params];
        while ([rs next]) {
            NSString *relativePath = [rs stringForColumn:@"relative_path"];
            IMBArtworkEntity *artworkItem = [[IMBArtworkEntity alloc] init];
            artworkItem.filePath = [NSString stringWithFormat:@"%@/%@",folderPath,relativePath];
            [track.artwork addObject:artworkItem];
            [artworkItem release];
        }
        [rs close];
        
    }
    [_libraryConnection close];
}

- (NSArray *)readArtworkFromatsIDs{
    long formatID = 0;
    NSMutableArray *formatIDs = [[NSMutableArray alloc] init];
    FMResultSet *rs = nil;
    NSString *querySql = @"SELECT format_id FROM artwork_info group by format_id";
    rs = [_libraryConnection executeQuery:querySql];
    while (rs.next) {
        formatID = [rs longForColumn:@"format_id"];
        [formatIDs addObject:[NSString stringWithFormat:@"%ld",formatID]];
    }
    [formatIDs autorelease];
    return formatIDs;
}

- (NSString *)readTrackArtworkFileName:(long long)DBId{
    NSString *fileName = @"";
    NSString *querySql = @"";
    FMResultSet *rs = nil;
    //    [@"4.0" isVersionAscending:]
    if ([_ipod.deviceInfo.productVersion hasPrefix:@"7."]) {
        querySql = [NSString stringWithFormat:@"SELECT artwork_cache_id FROM item_store,item_extra WHERE item_store.item_pid = item_extra.item_pid AND item_store.sync_id = %lld",DBId];
    }
    else{
        querySql =[NSString stringWithFormat:@"SELECT artwork_cache_id FROM item_extra WHERE item_pid = %lld",DBId];
    }
    rs = [_libraryConnection executeQuery:querySql];
    if(rs.next)
    {
        long long artowrk_cache_id = [rs longLongIntForColumn:@"artwork_cache_id"];
        NSString *hash = [self convertArtworkCacheID:artowrk_cache_id];
        fileName = [self getArtworkFileName:hash];
    }
    return fileName;
}

- (NSString *)getArtworkFileName:(NSString *)hash{
    if(IsStringNilOrEmpty(hash)){
        return nil;
    }
    NSMutableArray *nameList = [[NSMutableArray alloc] init];
    hash = hash.lowercaseString;
    NSString *fileName = @"";
    NSString *folderName = [self getArtworkFolderName:hash];
    if (!(IsStringNilOrEmpty(folderName))) {
        fileName = [hash substringWithRange:NSMakeRange(2, hash.length-24)];
        fileName = [self checkFileName:folderName fileName:fileName];
        fileName = [NSString stringWithFormat:@"%@/%@",folderName,fileName];
    }
    [nameList release];
    return fileName;
}

- (NSString *) GetIos8ArtworkFileName:(NSString *)hash
{
    if ([MediaHelper stringIsNilOrEmpty:hash])
    {
        return nil;
    }
    hash = hash.lowercaseString;
    NSString *filePath = @"";
    NSString *folderName = [self getArtworkFolderName:hash];
    if (![MediaHelper stringIsNilOrEmpty:folderName])
    {
        folderName = [NSString stringWithFormat:@"/iTunes_Control/iTunes/Artwork/Originals/%@", folderName];
        filePath = [[hash substringWithRange:NSMakeRange(2, hash.length - 2)] stringByAppendingString:@".jpeg"];
        filePath = [NSString stringWithFormat:@"%@/%@",folderName,filePath];
        if (![[_ipod fileSystem] fileExistsAtPath:filePath])
        {
            filePath = [[hash substringWithRange:NSMakeRange(2, hash.length - 2)] stringByAppendingString:@".jpg"];
            filePath = [NSString stringWithFormat:@"%@/%@",folderName,filePath];
        }
    }
    return filePath;
}


- (NSString *)checkFileName:(NSString *)folderName fileName:(NSString *)fileName{
    NSString *nameTxt = @"";
    NSString *bashPath = [NSString stringWithFormat:@"/iTunes_Control/iTunes/Artwork/%@",folderName];
    if ([_ipod.fileSystem fileExistsAtPath:bashPath]) {
        NSArray *fileList = [_ipod.fileSystem getItemInDirectory:bashPath];
        for (AMFileEntity *item in fileList) {
            NSString *lastComponent =  [item.FilePath lastPathComponent];
            NSArray *fileArr = nil;
            if ([lastComponent rangeOfString:@"_"].location != NSNotFound) {
                fileArr = [lastComponent componentsSeparatedByString:@"_"];
            }
            if (fileArr != nil) {
                NSString *hashName = [fileArr objectAtIndex:0];
                if ([hashName isEqualToString:fileName]) {
                    nameTxt = fileName;
                    break;
                }
                else{
                    NSString *hashRepName = [hashName stringByReplacingOccurrencesOfString:@"0" withString:@""];
                    NSString *fileRepName = [fileName stringByReplacingOccurrencesOfString:@"0" withString:@""];
                    if ([hashRepName isEqualToString:fileRepName]) {
                        nameTxt = hashName;
                        break;
                    }
                }
            }
        }
    }
    return nameTxt;
}

- (NSString *)getArtworkFolderName:(NSString *)hash{
    if(IsStringNilOrEmpty(hash)){
        return nil;
    }
    NSString *folderName = [hash substringWithRange:NSMakeRange(0, 2)];
    if ([folderName hasPrefix:@"0"]) {
        folderName = [folderName substringWithRange:NSMakeRange(1, folderName.length -1)];
    }
    return folderName;
}

- (NSString *)convertArtworkCacheID:(long long)cacheId{
    NSString *dataHash = @"";
    if (cacheId == 0) {
        return dataHash;
    }
    @try {
        NSString *str1 = [NSString stringWithFormat:@"%lld",cacheId];
        NSData *data = (NSData *)[str1 sha1];
        NSString *str2 = [data dataToHex];
        dataHash = [str2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        str1 = nil;
        
    }
    @catch (NSException *exception) {
        dataHash = @"";
    }
    @finally {
        return dataHash;
    }
}

- (void)disposable{
    if (_libraryConnection != nil) {
        [_libraryConnection close];
        [_libraryConnection release];
        _libraryConnection = nil;
    }
}
@end
