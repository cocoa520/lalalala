//
//  IMBArtworkDB.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBArtworkDB.h"
#import "IMBArtworkDBRoot.h"
#import "IMBIPodImage.h"
#import "IMBImageList.h"
#import "IMBIThmbFileList.h"
#import "IMBSession.h"
#import "IMBArtworkListContainerHeader.h"
#import "IMBImageListContainer.h"
#import "IMBIThmbFileListContainer.h"
#import "IMBTracklist.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "IMBMediaLibraryDBHelper.h"
#import "IMBArtworkHelper.h"
#import "NSString+Compare.h"
@implementation IMBArtworkDB
@synthesize artworkList = _artworkList;

- (id)init {
    self = [super init];
    if (self) {
        fm = [[NSFileManager defaultManager] retain];
    }
    return self;
}

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [self init];
    if (self) {
        iPod = ipod;
        databaseFilePath = [[[iPod fileSystem] artworkDBPath] copy];
        fm = [[NSFileManager defaultManager] retain];
    }
    return self;
}

- (void)dealloc {
    if (_databaseRoot != nil) {
        [_databaseRoot release];
        _databaseRoot = nil;
    }
    if (databaseFilePath != nil) {
        [databaseFilePath release];
    }
    if (fm != nil) {
        [fm release];
        fm = nil;
    }
    [super dealloc];
}

- (void)parse {
    if([self checkIsReadArtworkDirectory]){
        [self readDeviceArtWorkDirectory];
    }
    else{
        [self readArtworkDatabase];
    }
}

- (BOOL) checkIsReadArtworkDirectory{
    if (iPod.deviceInfo.isIOSDevice) {
        NSString *version = iPod.deviceInfo.productVersion;
        NSComparisonResult result = [MediaHelper compareVersion:@"5.0.0" newVersion:version];
        if (result == NSOrderedAscending || result == NSOrderedSame) {
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return false;
    }
}

- (void)readArtworkDatabase{
    if ([[iPod fileSystem] fileExistsAtPath:databaseFilePath] == NO) {
        if ([[[iPod deviceInfo] supportedArtworkFormats] count] > 0) {
            [[iPod fileSystem] mkDir:[[iPod fileSystem] artworkFolderPath]];
            [[iPod fileSystem] copyLocalFile:[[NSBundle mainBundle] pathForResource:@"ArtworkDB_empty" ofType:nil] toRemoteFile:databaseFilePath];
        } else {
            return;
        }
    }
    
    if ([MediaHelper stringIsNilOrEmpty:[[iPod deviceInfo] productVersion]] == FALSE) {
        _databaseRoot = [[IMBArtworkDBRoot alloc] init];
        [self readDatabase:_databaseRoot];
        
        _artworkList = [(IMBImageListContainer*)[[_databaseRoot getChildSection:ArtworkImages] getListContainer] imageList];
        _ithmbFileList = [(IMBIThmbFileListContainer*)[[_databaseRoot getChildSection:ArtworkFiles] getListContainer] fileList];
        
        if (_artworkList == nil) {
            return;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaType != %d && mediaType != %d && mediaType != %d && mediaType != %d && mediaType != %d",VoiceMemo,Books,PDFBooks,Ringtone];
        NSArray *mediaTracks = [iPod.tracks.trackArray filteredArrayUsingPredicate:predicate];
        if (mediaTracks == nil) {
            return;
        }
        
        for (IMBTrack *track in mediaTracks) {
            IMBIPodImage *artwork = [_artworkList getArtworkByTrackID:track.dbID];
            if (artwork != nil && artwork.formatsCount > 0) {
                for (IMBIPodImageFormat *format in [artwork getFormats]) {
                    [track setArtworkVesion:4];
                    //TODO:加artwork
                    IMBArtworkEntity *artworkEntity = [[IMBArtworkEntity alloc] init];
                    [self readIpodImage:format ToArtworkEntity:artworkEntity];
                    [track.artwork addObject:artworkEntity];
                    [artworkEntity release];
                }
            }
        }
    }
    //
}

- (BOOL)readDeviceArtWorkDirectory{
    NSString *_basePath = @"/iTunes_Control/iTunes/Artwork";
    NSString *version = iPod.deviceInfo.productVersion;
    NSComparisonResult result = [MediaHelper compareVersion:@"8.0" newVersion:version];
    if (result == NSOrderedSame || result == NSOrderedAscending) {
        _basePath = @"/iTunes_Control/iTunes/Artwork/Originals";
    }
    if ([iPod.fileSystem fileExistsAtPath:_basePath]) {
        NSArray *mediaTracks = [iPod.trackArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType != %d && mediaType != %d && mediaType != %d && mediaType != %d",VoiceMemo,Books,PDFBooks,Ringtone]];
        
        if (mediaTracks == nil){
            NSLog(@"Media Track List Is Null");
            return false;
        }
        IMBMediaLibraryDBHelper *dbHelper = [[IMBMediaLibraryDBHelper alloc] initWithIpod:iPod];
        if ([dbHelper openDatabase]) {
            if ([iPod.deviceInfo.productVersion isVersionMajorEqual:@"8.0"]) {
                if ([iPod.deviceInfo.productVersion isVersionMajorEqual:@"8.0"]) {
                    if ([iPod.deviceInfo.productVersion hasPrefix:@"8."]&&![iPod.deviceInfo.productVersion hasPrefix:@"8.4"]) {
                        [dbHelper getArtWorkPathiOS8Point3:mediaTracks];
                    }else if ([iPod.deviceInfo.productVersion isVersionMajorEqual:@"8.4"])
                    {
                        [dbHelper getArtWorkPathiOS9:mediaTracks];
                    }
                }else
                {
                    [dbHelper readNewIosArtworkItems:mediaTracks];

                }
            }
            else{
                NSArray *formIDs = [dbHelper readArtworkFromatsIDs];
                if (formIDs == nil || formIDs.count == 0) {
                    return false;
                }
                for (IMBTrack *track in mediaTracks) {
                    NSString *fileName = [dbHelper readTrackArtworkFileName:track.dbID];
                    if(IsStringNilOrEmpty(fileName)){
                        continue;
                    }
                    for (NSString *string in formIDs) {
                        IMBArtworkEntity *artworkItem = [[IMBArtworkEntity alloc] init];
                        artworkItem.formatType = string;
                        artworkItem.filePath = [NSString stringWithFormat:@"%@/%@_%@.jpg",_basePath,fileName,string];

                        [track.artwork addObject:artworkItem];
                        [artworkItem release];
                        long long filesize = 0;
                        NSMutableArray *newArray = [track.artwork copy];
                        for (IMBArtworkEntity *entity in newArray) {
                            long long curFileSize = [iPod.fileSystem getFileLength:entity.filePath];
                            if (curFileSize > filesize) {
                                [track.artwork replaceObjectAtIndex:0 withObject:entity];
                                filesize = curFileSize;
                            }
                        }
                        [newArray release];
                    }
                }
            }
            [dbHelper closeDB];
            [dbHelper release];
            return true;
        }
        else{
            [dbHelper release];
            return false;
        }
    }
    else{
        return false;
    }
}


- (void)readIpodImage:(IMBIPodImageFormat *)ipodimageFormat ToArtworkEntity:(IMBArtworkEntity *)artworkEntity{
    @autoreleasepool {
        IMBIPodImageFormat *entity = ipodimageFormat;
        NSImage *artImg = nil;
        @try {
            artImg = [entity loadFromFile];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
        }
        if (artImg != nil) {
            NSData *imageData = nil;
           
            //imageData = [artImg TIFFRepresentation];
            //imageData = [IMBArtworkHelper convertToArtworkData:art Format:Format16bppRgb555];
            NSString *alias = [[TempHelper getAppTempPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [TempHelper getRandomFileName:8]]];
            NSString *afilePath= [TempHelper getFilePathAlias:alias];
            //        NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:afilePath]) {
                [fm removeItemAtPath:afilePath error:nil];
            }
            [imageData writeToFile:afilePath atomically:YES];
            if ([fm fileExistsAtPath:afilePath]) {
                [artworkEntity setLocalFilepath:afilePath];
            }
        }
    }
}

- (void)save {
    
    if (_databaseRoot == nil) {
        return;
    }
    [self writeDatabase:_databaseRoot];
    _isDirty = FALSE;
}

- (BOOL)isDirty {
    return _isDirty;
}

- (int)version {
    return 0;
}

- (NSString *)description {

return [NSString stringWithFormat:@"<IMBArtworkDB _isDirty=%d,\n nextImageId=%d,\n _artworkList=%@ ,\n _ithmbFileList=%@ >"
                ,_isDirty,[self nextImageID], _artworkList,_ithmbFileList];
}

- (void)setNextImageID:(uint)nextImageID {
    [_databaseRoot setNextImageId:nextImageID];
}

- (uint)nextImageID {
    return [_databaseRoot nextImageId];
}

- (void)setArtwork:(IMBTrack*)track image:(NSImage*)image {
    if ([[[iPod deviceInfo] supportedArtworkFormats] count] == 0) {
        return;
    }
    
    IMBIPodImage *exsitingArtwork = [self getTrackArtForTrack:track];
    if (exsitingArtwork == nil) {
        if ([[iPod tracks] freespace] <= 0) {
            @throw [NSException exceptionWithName:@"EX_OutOfDiskSpace" reason:@"Insufficient disk space!" userInfo:nil];
        }
        [_artworkList addNewArtwork:track image:image];
    } else {
        [exsitingArtwork update:image];
        [[track artwork] removeAllObjects];
        [[track artwork] addObjectsFromArray:[exsitingArtwork getFormats]];
        [track setArtworkIdLink:[exsitingArtwork iD]];
    }
    _isDirty = true;
}

- (void)removeArtwork:(IMBTrack*)track {
    if ([[[iPod deviceInfo] supportedArtworkFormats] count] == 0) {
        return;
    }
    
    if (_databaseRoot == nil) {
        return;
    }
    
    BOOL shouldRemove = TRUE;
    if ([track artworkIdLink] != 0) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ([(IMBTrack*)evaluatedObject artworkIdLink] == [track artworkIdLink]);
        }];
        NSArray *tracksUsingArtwork = [[[iPod tracks] trackArray] filteredArrayUsingPredicate:pre];
        if (tracksUsingArtwork != nil && [tracksUsingArtwork count] <= 1) {
            shouldRemove = TRUE;
        } else {
            shouldRemove = FALSE;
        }
    }
    
    IMBIPodImage *exsitingArtwork = [self getTrackArtForTrack:track];
    if (exsitingArtwork != nil) {
        if (shouldRemove == TRUE) {
            [_artworkList removeArtwork:exsitingArtwork];
        }
        [[track artwork] removeAllObjects];
        _isDirty = TRUE;
    }
}

- (void)getIThmbRepository:(IMBIPodImageFormat*)format fileName:(NSString**)fileName fileOffset:(uint*)fileOffset {
    *fileName = @"";
    BOOL foundFile = FALSE;
    for (IMBIThmbFile *file in [_ithmbFileList files]) {
        if ([file formatID] == [format formatID]) {
            foundFile = TRUE;
            break;
        }
    }
    
    if (foundFile == FALSE) {
        [_ithmbFileList addIThmbFile:format];
    }
    *fileOffset = 0;
    for (IMBIThmbFile *file in [_ithmbFileList files]) {
        if ([file formatID] == [format formatID]) {
            for (int i = 1; ; i++) {
                *fileName = [NSString stringWithFormat:@"F%u_%d.ithmb", [file formatID], i];
                NSString *ithmbPath = [[[iPod fileSystem] artworkFolderPath] stringByAppendingPathComponent:*fileName];
                
                if ([[iPod fileSystem] fileExistsAtPath:ithmbPath] == NO) {
                    *fileOffset = 0;
                    break;
                }
                *fileOffset = [self getNextFreeBlockInIThmb:*fileName ithmbBlockSize:[format imageBlockSize]];
                if (*fileOffset < 209715200) {
                    return;
                }
            }
        }
    }
}

- (uint)getNextFreeBlockInIThmb:(NSString*)fileName ithmbBlockSize:(uint)ithmbBlockSize {
    uint result = 0;
    NSMutableArray *offsets = [[NSMutableArray alloc] init];

    for (IMBIPodImage *artwork in [_artworkList getImages]) {
        for (IMBIPodImageFormat *fmt in [artwork getFormats])
        {
            if ([[fmt getFileName] isEqualToString:fileName] == TRUE) {
                [offsets addObject:[NSNumber numberWithUnsignedInt:[fmt fileOffset]]];
            }
        }
    }
    NSArray* sortedArray = [offsets sortedArrayUsingSelector:@selector(compare:)];
    long lastOffset = ithmbBlockSize * -1;
    for (NSNumber *offset in sortedArray) {
        if ((long)(lastOffset + ithmbBlockSize) < [offset longValue]) {
            break;
        }
        lastOffset = [offset longValue];
    }
    result = (uint)(lastOffset + (long)ithmbBlockSize);
    [offsets release];
    offsets = nil;
    return result;
}

- (IMBIPodImage*)getTrackArtForTrack:(IMBTrack*)track{
    IMBIPodImage *artwork = nil;
    
    if ([track artworkIdLink] != 0) {
        if (_artworkList != nil) {
            artwork = [_artworkList getArtworkByID:[track artworkIdLink]];
        }
        if (artwork != nil) {
            return artwork;
        }
    }
    
    if (_artworkList != nil) {
        artwork = [_artworkList getArtworkByTrackID:[track dbID]];
        if (artwork != nil) {
            return artwork;
        }
    }
    return nil;
}

@end
