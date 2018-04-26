//
//  IMBSyncBookPlist.m
//  iMobieTrans
//
//  Created by iMobie on 5/8/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBSyncBookPlistBuilder.h"
#import "IMBIPod.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "IMBTracklist.h"
#import "IMBTrack.h"
#import "MobileDeviceAccess.h"
#import "IMBNewTrack.h"
#import "MediaHelper.h"
@implementation IMBSyncBookPlistBuilder

- (id)init{
    if (self = [super init]) {
        _delPidPlist = [[NSMutableArray alloc] init];
        logHandle = [IMBLogManager singleton];
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod{
    if (self = [self init]) {
        iPod = [ipod retain];
        _builderType = Add;
        [self initBuilder];
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod delPidList:(NSArray *)delPidList{
    if (self = [self init]) {
        iPod = [ipod retain];
        _builderType = Del;
        if (delPidList != nil && delPidList.count > 0) {
            for (NSString *item in delPidList) {
                [_delPidPlist addObject:item];
            }
        }
        [self initBuilder];
    }
    return self;
}

- (void)initBuilder{
    [self createLocalSaveTempPath];
}

+ (NSMutableDictionary*)parsePlist:(IMBiPod*)ipod{
    NSFileManager *fmg = [NSFileManager defaultManager];
    NSMutableDictionary *plistDic = nil;
    NSString *_remotingFilePath = nil;
    NSString *_localFilePath = nil;
    
    _remotingFilePath = [[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books/Books.plist"];
    if (![[ipod fileSystem] fileExistsAtPath:_remotingFilePath]) {
        _remotingFilePath = [[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books/Sync/Books.plist"];
    }
    
    NSString *_localFileFolder = [[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"Book"];
    if (![fmg fileExistsAtPath:_localFileFolder]) {
        [fmg createDirectoryAtPath:_localFileFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _localFilePath = [_localFileFolder stringByAppendingPathComponent:@"syncIb.plist"];
    if ([fmg fileExistsAtPath:_localFilePath]) {
        [fmg removeItemAtPath:_localFilePath error:nil];
    }
    if ([[ipod fileSystem] fileExistsAtPath:_remotingFilePath] &&
        [[ipod fileSystem] getFileLength:_remotingFilePath] > 0) {
        [[ipod fileSystem] copyRemoteFile:_remotingFilePath toLocalFile:_localFilePath];
        if ([fmg fileExistsAtPath:_localFilePath]) {
            plistDic = [NSMutableDictionary dictionaryWithContentsOfFile:_localFilePath];
        }
    }
    return plistDic;
}

+ (void)createTrack:(NSDictionary*)bookInfoDic witIpod:(IMBiPod *)ipod{
    IMBNewTrack *newTrack = [[[IMBNewTrack alloc] init] autorelease];
    
    int64_t dbid = [[bookInfoDic objectForKey:@"Persistent ID"] longLongValue];
    [newTrack setArtist:[bookInfoDic objectForKey:@"Artist"]];
    [newTrack setGenre:[bookInfoDic objectForKey:@"Genre"]];
    [newTrack setAlbumArtist:[bookInfoDic objectForKey:@"Album"]];
    //[newTrack setTitle:[self getDicValueByKey:bookInfoDic key:@"title"]];
    [newTrack setTitle:[bookInfoDic objectForKey:@"Name"]];
    [newTrack setFilePath:[[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",[bookInfoDic objectForKey:@"Path"]]]];
    [newTrack setIsVideo:NO];
    NSString *path = [bookInfoDic objectForKey:@"Path"];
    NSString *publisherUniqueID = [bookInfoDic objectForKey:@"Publisher Unique ID"];
    NSString *packageHash = [bookInfoDic objectForKey:@"Package Hash"];
    MediaTypeEnum type;
    if ([[path pathExtension] isEqualToString:@"epub"]) {
        type = Books;
        newTrack.fileSize= (uint)[[ipod fileSystem] getFolderSize:[[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",[bookInfoDic objectForKey:@"Path"]]]];
    }
    else{
        type = PDFBooks;
        newTrack.fileSize= (uint)[[ipod fileSystem] getFileLength:[[[ipod fileSystem] driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",[bookInfoDic objectForKey:@"Path"]]]];
    }
    [newTrack setDBMediaType:type];
    [newTrack setBookFileName:[bookInfoDic objectForKey:@"Name"]];
    //    NSMutableArray *existedFilePathArr = [[NSMutableArray alloc]init];
    IMBTrack *track = nil;
    if(![[ipod fileSystem] fileExistsAtPath:[newTrack filePath]])
    {
        return;
    }
    else{
        /*                            [info setObject:uuid forKey:@"uuid"];
         [info setObject:name forKey:@"name"];
         [info setObject:album forKey:@"album"];
         [info setObject:artist forKey:@"artist"];
         [info setObject:genre forKey:@"genre"];
*/
        if (packageHash == nil || packageHash.length == 0) {
            NSDictionary *dic = [self getRemoteEpubInfoDic:[NSString stringWithFormat:@"Books/%@",[bookInfoDic objectForKey:@"Path"]] withIpod:ipod];
            publisherUniqueID = [dic objectForKey:@"uuid"];
            [newTrack setArtist:[dic objectForKey:@"artist"]];
            [newTrack setTitle:[dic objectForKey:@"name"]];
            [newTrack setGenre:[dic objectForKey:@"genre"]];
            packageHash = [dic objectForKey:@"file-package-hash"];
        }
    }
    track = [[ipod tracks] addTrack:newTrack copyToDevice:NO calcuTotalSize:newTrack.fileSize WithSrciPod:ipod];
    track.dbID = dbid;
    track.uuid = publisherUniqueID;
    track.mediaType = type;
    track.packageHash = packageHash;
}

+ (NSDictionary *)getRemoteEpubInfoDic:(NSString *)remotePath withIpod:(IMBiPod *)ipod{
    NSFileManager *fmg = [NSFileManager defaultManager];
    NSArray *fileInfoArr = [[ipod fileSystem] recursiveDirectoryContentsDics:remotePath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FilePath ENDSWITH[cd] %@",@".opf"];
    NSArray *opfArr = [fileInfoArr filteredArrayUsingPredicate:predicate];
    
    AMFileEntity *entity = nil;
    if (opfArr.count > 0) {
       entity = [opfArr objectAtIndex:0];
    }
    else{
        return nil;
    }
    
    NSString *localFolderPath = [[[ipod session] sessionFolderPath] stringByAppendingPathComponent:@"Book"];
    if (![fmg fileExistsAtPath:localFolderPath]) {
        [fmg createDirectoryAtPath:localFolderPath withIntermediateDirectories:YES
                        attributes:nil error:nil];
    }
    
    
    NSString *localFolderFile = [localFolderPath stringByAppendingPathComponent:[[entity FilePath] lastPathComponent]];
    if ([fmg fileExistsAtPath:localFolderFile]) {
        [fmg removeItemAtPath:localFolderFile error:nil];
    }
    if ([[ipod fileSystem] fileExistsAtPath:entity.FilePath]) {
        [[ipod fileSystem] copyRemoteFile:entity.FilePath toLocalFile:localFolderFile];
    }
    
    NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] init] autorelease];
    [MediaHelper getEpubopfInfo:localFolderFile inDic:infoDic];
    
    return infoDic;
}


- (void)createLocalSaveTempPath{
    NSString *appDataPath = iPod.session.sessionFolderPath;
    _localTempFolder = [appDataPath stringByAppendingPathComponent:@"Book"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_localTempFolder]) {
        [fileManager createDirectoryAtPath:_localTempFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSMutableDictionary *)loadBookDataToDictionary{
    NSMutableDictionary *bookDic = nil;
    NSString *filePath = [_localTempFolder stringByAppendingPathComponent:@"Books.plist"];
    NSString *tempPath = @"";
    if ([self checkFileIsExist:filePath]) {
        tempPath = [self copyDeviceFileToTargetPath:_booksPlist targetPath:filePath];
        if (tempPath != nil && ![tempPath isEqualToString:@""]) {
            bookDic = [self readBookPlistFile:tempPath];
        }
    }
    
    if (bookDic == nil || bookDic.count == 0) {
        if ([self checkFileIsExist:_syncPlist]) {
            tempPath = [self copyDeviceFileToTargetPath:_syncPlist targetPath:filePath];
            if (tempPath != nil && ![tempPath isEqualToString:@""]) {
                bookDic = [self readBookPlistFile:tempPath];
            }
        }
    }
    
    if (bookDic == nil || bookDic.count == 0) {
        IMBTracklist *trackList = iPod.tracks;
        if (trackList == nil && [trackList getTrackCount] > 0) {
            NSPredicate *perdicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                IMBTrack *track = (IMBTrack *)evaluatedObject;
                BOOL result = false;
                result = (track.mediaType == Books || track.mediaType == PDFBooks) && !track.isDirty;
                return result;
            }];
            NSArray *bookList = [trackList.trackArray filteredArrayUsingPredicate:perdicate];
            if (bookList != nil && bookList.count > 0) {
                bookDic = [self createBooksTrackSyncPlist:bookList];
            }
            else{
                [logHandle writeInfoLog:@"2. Device TrackList Not Book Data"];
            }
        }
        else{
            [logHandle writeInfoLog:@"1.Device TrackList not Books Data"];
        }
    }
    if (bookDic == nil || bookDic.count == 0) {
        bookDic = [[[NSMutableDictionary alloc]init] autorelease];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [bookDic setObject:arr forKey:@"Books"];
        [arr release];
    }
    return bookDic;
}

- (NSMutableDictionary *)createBooksTrackSyncPlist:(NSArray *)array{
    NSMutableDictionary *bookDic = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    NSString *fileMD5 = @"";
    for (IMBTrack *track in array) {
        if (_builderType == Del) {
            
            NSString *pid = nil;
            if (track.isUnusual) {
                pid = track.hexPersistentID;
            }
            else{
                pid = [NSString stringWithFormat:@"%lld",track.dbID];
            }
            if(IsStringNilOrEmpty(pid)){
                continue;
            }
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NSString *string = (NSString *)evaluatedObject;
                if ([pid isEqualToString:string]) {
                    return true;
                }
                return false;
            }];
            NSArray *pidItems = [_delPidPlist filteredArrayUsingPredicate:predicate];
            if (pidItems != nil && pidItems.count != 0) {
                continue;
            }
        }
        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc] init];
        if (track.mediaType == PDFBooks) {
            if (![self checkFileIsExist:track.filePath]) {
                continue;
            }
            [dicItem setObject:@"pdf" forKey:@"Extension"];
            [dicItem setObject:@"unknown" forKey:@"Kind"];
            [dicItem setObject:@"application/pdf" forKey:@"MIME Type"];
            if (!(IsStringNilOrEmpty(track.packageHash))) {
                fileMD5 = track.packageHash;
            }
            else{
                NSString *pdfPath = [[iPod.fileSystem driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",track.filePath.lastPathComponent]];
                NSData *fileData = [self readFileData:pdfPath];
                if (fileData != nil && [fileData length] > 0) {
                    fileMD5 = [MediaHelper getFileDataMd5Hash:fileData];
                }
                else{
                    [logHandle writeInfoLog:[NSString stringWithFormat:@"Read + %@ + .pdf md5 is error.",track.title]];
                }
            }
        }
        else{
            if (![self checkFolderIsExist:track.filePath]) {
                continue;
            }
            [dicItem setObject:track.album forKey:@"Album"];
            [dicItem setObject:track.artist forKey:@"Artist"];
            [dicItem setObject:@"epub" forKey:@"Extension"];
            [dicItem setObject:track.genre?:@"" forKey:@"Genre"];
            [dicItem setObject:@"ebook" forKey:@"Kind"];
            [dicItem setObject:@"application/epub+zip" forKey:@"MIME Type"];
            if (!(IsStringNilOrEmpty(track.packageHash))) {
                fileMD5 = track.packageHash;
            }
            else{
                NSString *opfPath = [self getEpubopfPath:track.filePath];
                if (opfPath != nil && opfPath.length > 0) {
                    fileMD5 = [MediaHelper getFileDataMd5Hash:[self readFileData:opfPath]];
                }
                else{
                    fileMD5 = @"";
                    [logHandle writeInfoLog:[NSString stringWithFormat:@"Read %@ .epub md5 is error.",track.title]];
                }
                
            }
        }
        [dicItem setObject:[NSNumber numberWithBool:true] forKey:@"Has Artwork"];
        [dicItem setObject:[NSNumber numberWithBool:false] forKey:@"Is Protected"];
        [dicItem setObject:track.title == nil?@"":track.title forKey:@"Name"];
        [dicItem setObject:[NSString stringWithFormat:@"%lld",track.dbID] forKey:@"Persistent ID"];
        if (fileMD5 != nil && fileMD5.length > 0) {
            [dicItem setObject:fileMD5 forKey:@"Package Hash"];
        }
        else{
            [dicItem setObject:@"" forKey:@"Package Hash"];
        }
        [itemList addObject:dicItem];
        [dicItem release];
    }
    [bookDic setObject:itemList forKey:@"Books"];
    [itemList release];
    return bookDic;
}

- (NSMutableDictionary *)readBookPlistFile:(NSString *)plistPath{
    NSMutableDictionary *syncBookDic = nil;
    NSFileManager *fmg = [NSFileManager defaultManager];
    if (plistPath == nil || plistPath.length == 0) {
        return nil;
    }
    if (![fmg fileExistsAtPath:plistPath]) {
        return nil;
    }
    NSDictionary *bookdata = nil;
    @try {
        bookdata = [[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    }
    @catch (NSException *exception) {
        bookdata = nil;
    }
    @finally {
        if (bookdata != nil) {
            NSDictionary *bookDic = bookdata;
            if ([bookDic.allKeys containsObject:@"Books"]) {
                syncBookDic = [[[NSMutableDictionary alloc] init] autorelease];
                NSMutableArray *bookList = [[NSMutableArray alloc] init];
                @try {
                    NSArray *bookArray = [bookDic objectForKey:@"Books"];
                    for (NSDictionary *item in bookArray) {
                        NSDictionary *dicitem = item;
                        if (dicitem == nil) {
                            continue;
                        }
                        if (_builderType == Del) {
                            if ([dicitem.allKeys containsObject:@"Persistent ID"]) {
                                NSString *pid = [dicitem objectForKey:@"Persistent ID"];
                                if (pid == nil || pid.length == 0) {
                                    continue;
                                }
                                if ([_delPidPlist containsObject:pid]) {
                                    continue;
                                }
                            }
                        }
                        if ([dicitem.allKeys containsObject:@"Path"]) {
                            NSString *path = [dicitem objectForKey:@"Path"] == nil ? @"":[dicitem objectForKey:@"Path"];
                            
                            if (path == nil || path.length == 0 || [path rangeOfString:@"Purchases"].location != NSNotFound) {
                                [bookList addObject:dicitem];
                            }
                            else{
                                NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
                                for (NSString *key in dicitem.allKeys) {
                                    if (![key isEqualToString:@"Path"]) {
                                        [itemDic setObject:[dicitem objectForKey:key] forKey:key];
                                    }
                                }
                                [bookList addObject:itemDic];
                                [itemDic release];
                            }

                        }
                        else{
                            [bookList addObject:dicitem];
                        }
                    }
                    [syncBookDic setObject:bookList forKey:@"Books"];
                    [bookList release];
                }
                @catch (NSException *exception) {
                    syncBookDic = nil;
                    [logHandle writeInfoLog:[NSString stringWithFormat:@"Read Book Plist Data Is Error. Exception:%@",exception.description]];
                } 
            }
            else{
                syncBookDic = nil;
            }
        }
        else{
            syncBookDic = nil;
        }
        return syncBookDic;
    }
}

- (BOOL)checkFileIsExist:(NSString *)checkPath{
    BOOL result = false;
    NSString *filePath = [[iPod.fileSystem driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",checkPath.lastPathComponent]];
    if ([iPod.fileSystem fileExistsAtPath:filePath]) {
        result = true;
    }
    return result;
}

- (BOOL)checkFolderIsExist:(NSString *)checkPath{
    bool result = false;
    NSString *folderPath = [[iPod.fileSystem driveLetter] stringByAppendingPathComponent:[NSString stringWithFormat:@"Books/%@",checkPath.lastPathComponent]];

    if ([iPod.fileSystem fileExistsAtPath:folderPath]) {
        result = true;
    }
    return result;
}

- (NSString *)getEpubopfPath:(NSString *)bookPath{
    
    NSString *bookDirPath = [[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:bookPath];
    NSArray *fileInfoArr = [[iPod fileSystem] recursiveDirectoryContentsDics:bookDirPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FilePath ENDSWITH %@",@".opf"];
    NSArray *opfArr = [fileInfoArr filteredArrayUsingPredicate:predicate];
    if (opfArr == nil || opfArr.count == 0) {
        return nil;
    }
    AMFileEntity *entity = [opfArr objectAtIndex:0];
    return entity.FilePath;


}


- (NSData *)readFileData:(NSString *)filePath{
    if (![iPod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }
    else{
        long long fileLength = [iPod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [iPod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[NSMutableData alloc] init];
        while (1) {
            
            uint32_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
        }
        if (totalData.length == fileLength) {
//            NSLog(@"success readData");
        }
        return totalData;
    }
}

- (void)createLocalSaveTmepPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appDataPath = iPod.session.sessionFolderPath;
    _localTempFolder = [appDataPath stringByAppendingPathComponent:@"Book"];
    if (![fileManager fileExistsAtPath:_localTempFolder]) {
        [fileManager createDirectoryAtPath:_localTempFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)copyDeviceFileToTargetPath:(NSString *)sourcePath targetPath:(NSString *)targetPath{
    NSFileManager *fmg = [NSFileManager defaultManager];
    NSString *finalPath = @"";
    if (sourcePath == nil || sourcePath.length == 0) {
        return finalPath;
    }
    if (targetPath == nil || targetPath.length == 0) {
        return finalPath;
    }
    if ([iPod.fileSystem fileExistsAtPath:sourcePath]) {
        if ([fmg fileExistsAtPath:targetPath]) {
            @try {
                [fmg removeItemAtPath:targetPath error:nil];
                finalPath = targetPath;
            }
            @catch (NSException *exception) {
                finalPath = [self createNewFilePath:targetPath];
            }
        }
        else{
            finalPath = targetPath;
        }
        if (finalPath != nil || finalPath.length != 0) {
            [iPod.fileSystem copyRemoteFile:sourcePath toLocalFile:finalPath];
        }
        else{
            [logHandle writeErrorLog:@"Create Final File Path Is Failed"];
        }
    }
    else{
        finalPath = @"";
        [logHandle writeInfoLog:@"Device File NotExist"];
    }
    return finalPath;
}

- (NSString *)createNewFilePath:(NSString *)filePath{
    NSString *newFilePath = @"";
    @try {
        NSString *folderPath = [filePath stringByDeletingLastPathComponent];
        NSString *suffix = [filePath pathExtension];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyyMMddHHMMss"];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",[formatter stringFromDate:[NSDate date]],suffix];
        newFilePath = [folderPath stringByAppendingPathComponent:fileName];
//        NSString *fileName = [[NSDate date] ]
    }
    @catch (NSException *exception) {
        newFilePath = @"";
    }
    return newFilePath;
}

- (void)dealloc{
    if (iPod != nil) {
        [iPod release];
        iPod = nil;
    }
    if (_delPidPlist != nil) {
        [_delPidPlist release];
        _delPidPlist = nil;
    }
    
    [super dealloc];
}

@end
