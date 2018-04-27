//
//  IMBBookToDevice.m
//  iMobieTrans
//
//  Created by iMobie on 8/14/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBookToDevice.h"
#import "IMBBookEntity.h"
#import "IMBSession.h"
#import "IMBAirSyncImportBetweenDeviceTransfer.h"

#define BOOKPATH @"/Books/"
#define BOOKPLIST @"/Books/Books.plist"

@implementation IMBBookToDevice
@synthesize currentItem = _currentItem;

- (id)initWithSrcIpod:(IMBiPod *)srcIpod desIpod:(IMBiPod *)desIpod bookList:(NSArray *)bookList Delegate:(id)delegate {
    if (self = [super initWithIPodkey:desIpod.uniqueKey withDelegate:delegate]) {
        _srcIpod = [srcIpod retain];
        bookEntityList = [bookList mutableCopy];
        plistModelList = [[NSMutableArray alloc] init];
        _currentItem = 0;
        slocalPath = @"";
    }
    return self;
}

- (BOOL)prepareData{
    if (_srcIpod == nil) {
        return false;
    }
    if (_ipod == nil) {
        return false;
    }
    if (bookEntityList.count == 0) {
        return false;
    }
    if (![_srcIpod.fileSystem fileExistsAtPath:BOOKPATH]) {
        return false;
    }
    if (![_ipod.fileSystem fileExistsAtPath:BOOKPATH]) {
        [_ipod.fileSystem mkDir:BOOKPATH];
    }
    return true;
}

- (void)startTransfer {
    [self copyBookPlistToTmep:YES];
    [self readBookPlist];
    [self copyBookPlistToTmep:FALSE];
    id plistObject = nil;
    NSMutableArray *bookDatas = nil;
    
    if ([_fileManager fileExistsAtPath:tlocalPath]) {
        @try {
            plistObject = [[[NSDictionary alloc] initWithContentsOfFile:tlocalPath] autorelease];
        }
        @catch (NSException *exception) {
            plistObject = nil;
        }
    }
    
    if (plistObject != nil){
        NSDictionary *dictObject = plistObject;
        if ([dictObject.allKeys containsObject:@"Books"]) {
            bookDatas = [[dictObject objectForKey:@"Books"] mutableCopy];
        }
    }
    else{
        bookDatas = [[NSMutableArray alloc] init];
    }

    for (IMBBookEntity *item in bookEntityList) {
//        if (_limitation.remainderCount == 0) {
//            break;
//        }
        if ([_transferDelegate respondsToSelector:@selector(copyWordProgress:)]) {
            [(IMBAirSyncImportBetweenDeviceTransfer *)_transferDelegate copyWordProgress:item.bookName];
        }
        if ([_transferDelegate respondsToSelector:@selector(sendCopyProgress:)]) {
            [(IMBAirSyncImportBetweenDeviceTransfer *)_transferDelegate sendCopyProgress:0];
        }

        if (_isStop) {
            break;
        }
        NSString *bookPath = [BOOKPATH stringByAppendingPathComponent:item.path.lastPathComponent];
        if ([_ipod.fileSystem fileExistsAtPath:bookPath]) {
            continue;
        }
        NSString *srcBookPath = [BOOKPATH stringByAppendingPathComponent:[[item path] lastPathComponent]];
        BOOL result = [_ipod.fileSystem recursiveCopyFileBetweenDevice:[_srcIpod.fileSystem.driveLetter stringByAppendingPathComponent:srcBookPath] tarPath:[_ipod.fileSystem.driveLetter stringByAppendingPathComponent:srcBookPath] sourDevice:_srcIpod];
        if (result) {
            NSDictionary *dicItem = [self createBookDic:item];
            if (dicItem != nil && dicItem.count > 0) {
                [bookDatas addObject:dicItem];
            }
            if ([_transferDelegate respondsToSelector:@selector(setSuccessCount)]) {
                [(IMBAirSyncImportBetweenDeviceTransfer *)_transferDelegate setSuccessCount];
            }
//            [_limitation reduceRedmainderCount];
        }
    }
    NSMutableDictionary *bookContent = [[NSMutableDictionary alloc] init];
    [bookContent setObject:bookDatas forKey:@"Books"];
    NSError *error = nil;
    if ([_fileManager fileExistsAtPath:tlocalPath]) {
        [_fileManager removeItemAtPath:tlocalPath error:&error];
    }
    if (error != nil) {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] initWithDateFormat:@"yyyyMMDDHHMMss" allowNaturalLanguage:NO];
        tlocalPath = [tlocalPath stringByAppendingString:[NSString stringWithFormat:@".%@",[dateFormater stringFromDate:[NSDate date]]]];
    }
    
    NSString *nErr = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:bookContent format:NSPropertyListBinaryFormat_v1_0 errorDescription:&nErr];
    [plistData writeToFile:tlocalPath atomically:YES];
    
    if (nErr.length > 0) {
        [_loghandle writeErrorLog:[NSString stringWithFormat:@"write book data to plist error:%@",nErr]];
    }
    
    if([_fileManager fileExistsAtPath:tlocalPath]){
        [_ipod.fileSystem unlink:BOOKPLIST];
        [_ipod.fileSystem copyLocalFile:tlocalPath toRemoteFile:BOOKPLIST];
    }
    
    if (bookDatas != nil) {
        [bookDatas release];
        bookDatas = nil;
    }
    if (bookContent != nil) {
        [bookContent release];
        bookContent = nil;
    }
}

- (void)copyBookPlistToTmep:(BOOL)isSourcePlist{
    NSString *tempPath = [_srcIpod.session.sessionFolderPath stringByAppendingPathComponent:@"Book"];
    if (![_fileManager fileExistsAtPath:tempPath]){
        [_fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = @"";
    if (isSourcePlist) {
        filePath = [tempPath stringByAppendingPathComponent:@"Source_Book.plist"];
    }
    else{
        filePath= [tempPath stringByAppendingPathComponent:@"Target_Book.plist"];
    }
    @try {
        if ([_fileManager fileExistsAtPath:filePath]) {
            [_fileManager removeItemAtPath:filePath error:nil];
        }
        if (isSourcePlist) {
            if ([_srcIpod.fileSystem fileExistsAtPath:BOOKPLIST]) {
                [_srcIpod.fileSystem copyRemoteFile:BOOKPLIST toLocalFile:filePath];
            }
        }
        else{
            if ([_ipod.fileSystem fileExistsAtPath:BOOKPLIST]) {
                [_ipod.fileSystem copyRemoteFile:BOOKPLIST toLocalFile:filePath];
            }
        }
    }
    @catch (NSException *exception) {
        filePath = @"";
    }
    @finally {
        if (isSourcePlist) {
            slocalPath = [filePath retain];
        }
        else{
            tlocalPath = [filePath retain];
        }
    }
}

- (void)readBookPlist{
    if (![TempHelper stringIsNilOrEmpty:slocalPath] && [_fileManager fileExistsAtPath:slocalPath]) {
        id bookObject = [NSDictionary dictionaryWithContentsOfFile:slocalPath];
        if (bookObject != nil) {
            NSDictionary *bookDic = bookObject;
            if ([bookDic.allKeys containsObject:@"Books"]) {
                NSArray *books = [bookDic objectForKey:@"Books"];
                for (id item in books) {
                    BookPlistModel *plistModel = [[BookPlistModel alloc] init];
                    NSDictionary *dictionary = item;
                    if ([dictionary.allKeys containsObject:@"Album"]) {
                        plistModel.album = [dictionary objectForKey:@"Album"] != nil ? [dictionary objectForKey:@"Album"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Artist"]) {
                        plistModel.artist = [dictionary objectForKey:@"Artist"] != nil ? [dictionary objectForKey:@"Artist"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Extension"]) {
                        plistModel.extension = [dictionary objectForKey:@"Extension"] != nil ? [dictionary objectForKey:@"Extension"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Genre"]) {
                        plistModel.genre = [dictionary objectForKey:@"Genre"] != nil ? [dictionary objectForKey:@"Genre"]:@"";
                    }

                    if ([dictionary.allKeys containsObject:@"Has Artwork"]) {
                        plistModel.hasArtwork = [dictionary objectForKey:@"Has Artwork"] != nil ? [[dictionary objectForKey:@"Has Artwork"] boolValue]:NO;
                    }
                    if ([dictionary.allKeys containsObject:@"Is Protected"]) {
                        plistModel.isProtected = [dictionary objectForKey:@"Is Protected"] != nil ? [[dictionary objectForKey:@"Is Protected"] boolValue]:NO;
                    }
                    if ([dictionary.allKeys containsObject:@"Kind"]) {
                        plistModel.kind = [dictionary objectForKey:@"Kind"] != nil ? [dictionary objectForKey:@"Kind"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"MIME Type"]) {
                        plistModel.MIMEType = [dictionary objectForKey:@"MIME Type"] != nil ? [dictionary objectForKey:@"MIME Type"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Name"]) {
                        plistModel.name = [dictionary objectForKey:@"Name"] != nil ? [dictionary objectForKey:@"Name"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Package Hash"]) {
                        plistModel.packageHash = [dictionary objectForKey:@"Package Hash"] != nil ? [dictionary objectForKey:@"Package Hash"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Path"]) {
                        plistModel.path = [dictionary objectForKey:@"Path"] != nil ? [dictionary objectForKey:@"Path"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Persistent ID"]) {
                        plistModel.persistentID = [dictionary objectForKey:@"Persistent ID"] != nil ? [dictionary objectForKey:@"Persistent ID"]:@"";
                    }
                    if ([dictionary.allKeys containsObject:@"Publisher Unique ID"]) {
                        plistModel.publisherUniqueID = [dictionary objectForKey:@"Publisher Unique ID"] != nil ? [dictionary objectForKey:@"Publisher Unique ID"]:@"";
                    }
                    [plistModelList addObject:plistModel];
                }
            }
        }
    }
}

- (NSDictionary *)createBookDic:(IMBBookEntity *)bookEntity{
    NSMutableDictionary *bookDic = [[[NSMutableDictionary alloc] init] autorelease];
    BookPlistModel *plistItem = nil;
    if (plistModelList != nil && plistModelList.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"persistentID == %@",bookEntity.bookID];
        NSArray *resultArr = [plistModelList filteredArrayUsingPredicate:predicate];
        if (resultArr.count > 0) {
            plistItem = [resultArr objectAtIndex:0];
            [bookDic setObject:plistItem.album forKey:@"Album"];
            [bookDic setObject:plistItem.artist forKey:@"Artist"];
            [bookDic setObject:@"epub" forKey:@"Extension"];
            [bookDic setObject:plistItem.genre?:@"" forKey:@"Genre"];
            [bookDic setObject:[NSNumber numberWithBool:NO] forKey:@"Has Artwork"];
            [bookDic setObject:[NSNumber numberWithBool:NO] forKey:@"Is Protected"];
            [bookDic setObject:@"ebook" forKey:@"Kind"];
            [bookDic setObject:@"application/epub+zip" forKey:@"MIME Type"];
            [bookDic setObject:plistItem.name forKey:@"Name"];
            [bookDic setObject:plistItem.packageHash forKey:@"Package Hash"];
            [bookDic setObject:plistItem.path forKey:@"Path"];
            [bookDic setObject:plistItem.persistentID forKey:@"Persistent ID"];
            [bookDic setObject:plistItem.publisherUniqueID forKey:@"Publisher Unique ID"];
        }
        else{
            NSString *fileName = [bookEntity.path lastPathComponent];
            
            [bookDic setObject:bookEntity.album forKey:@"Album"];
            [bookDic setObject:bookEntity.author forKey:@"Artist"];
            [bookDic setObject:@"epub" forKey:@"Extension"];
            [bookDic setObject:bookEntity.genre?:@"" forKey:@"Genre"];
            [bookDic setObject:[NSNumber numberWithBool:NO] forKey:@"Has Artwork"];
            [bookDic setObject:[NSNumber numberWithBool:NO] forKey:@"Is Protected"];
            [bookDic setObject:@"ebook" forKey:@"Kind"];
            [bookDic setObject:@"application/epub+zip" forKey:@"MIME Type"];
            [bookDic setObject:fileName forKey:@"Name"];
            [bookDic setObject:bookEntity.path forKey:@"Path"];
            [bookDic setObject:bookEntity.bookID forKey:@"Persistent ID"];
        }
    }
    return bookDic;
}

- (void)dealloc{
    if (_srcIpod != nil) {
        [_srcIpod release];
        _srcIpod = nil;
    }
    if (bookEntityList != nil) {
        [bookEntityList release];
        bookEntityList = nil;
    }
    if (plistModelList != nil) {
        [plistModelList release];
        plistModelList = nil;
    }
    if (slocalPath != nil) {
        [slocalPath release];
        slocalPath = nil;
    }
    if (tlocalPath != nil) {
        [tlocalPath release];
        tlocalPath = nil;
    }
    [super dealloc];
}

@end

@implementation BookPlistModel
@synthesize album = _album;
@synthesize artist = _artist;
@synthesize extension = _extension;
@synthesize genre = _genre;
@synthesize hasArtwork = _hasArtwork;
@synthesize isProtected = _isProtected;
@synthesize kind = _kind;
@synthesize MIMEType = _MIMEType;
@synthesize name = _name;
@synthesize packageHash = _packageHash;
@synthesize path = _path;
@synthesize persistentID = _persistentID;
@synthesize publisherUniqueID = _publisherUniqueID;

- (void)dealloc{
    if (_album != nil) {
        [_album release];
        _album = nil;
    }
    if (_artist != nil) {
        [_artist release];
        _artist = nil;
    }
    if (_extension != nil) {
        [_extension release];
        _extension = nil;
    }
    if (_genre != nil){
        [_genre release];
        _genre = nil;
    }
    if (_kind != nil) {
        [_kind release];
        _kind = nil;
    }
    if (_MIMEType != nil) {
        [_MIMEType release];
        _MIMEType = nil;
    }
    if (_name != nil){
        [_name release];
        _name = nil;
    }
    if (_packageHash != nil) {
        [_packageHash release];
        _packageHash = nil;
    }
    if (_path != nil) {
        [_path release];
        _path = nil;
    }
    if (_persistentID != nil) {
        [_persistentID release];
        _persistentID = nil;
    }
    if (_publisherUniqueID != nil) {
        [_publisherUniqueID release];
        _publisherUniqueID = nil;
    }
    [super dealloc];
}

@end
