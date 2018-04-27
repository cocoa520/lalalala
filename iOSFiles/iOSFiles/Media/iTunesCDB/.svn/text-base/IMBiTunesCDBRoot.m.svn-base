//
//  IMBiTunesCDBRoot.m
//  MediaTrans
//
//  Created by Pallas on 12/10/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBiTunesCDBRoot.h"
#import "IMBSqliteTables.h"
#import "IMBSqliteTables_31.h"
#import "IMBSqliteTables_4.h"
#import "NSData+Category.h"
#import "IMBDeviceInfo.h"
#import "IMBSqliteTables_Nano5G.h"
#import "IMBSqliteTables_Nano6G.h"

@implementation IMBiTunesCDBRoot

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if(self){
        dirtyTracksArray = [[NSMutableArray alloc] init];
        dirtyPlaylistArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    if (decompressionData != nil) {
        [decompressionData release];
        decompressionData = nil;
    }
    if (dirtyTracksArray != nil) {
        [dirtyTracksArray release];
        dirtyTracksArray = nil;
    }
    if (dirtyPlaylistArray != nil) {
        [dirtyPlaylistArray release];
        dirtyPlaylistArray = nil;
    }
    [super dealloc];
}

#pragma mark - 重写方法
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    
    int readLength = 0;
    readLength = 4;
    identifierLength = readLength;
    _identifier = (char*)malloc(readLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    [reader getBytes:_identifier range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_headerSize);
    [reader getBytes:&_headerSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    [self validateHeader:@"mhbd"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_versionNumber);
    [reader getBytes:&_versionNumber range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_listContainerCount);
    [reader getBytes:&_listContainerCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_iD);
    [reader getBytes:&_iD range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = 16;
    unk2Length = readLength;
    _unk2 = (Byte*)malloc(readLength + 1);
    memset(_unk2, 0, malloc_size(_unk2));
    [reader getBytes:_unk2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_hashingScheme);
    [reader getBytes:&_hashingScheme range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
     
    readLength = _sectionSize - _headerSize;
    Byte *dataByte = (Byte*)malloc(_sectionSize - _headerSize + 1);
    memset(dataByte, 0, malloc_size(_identifier));
    [reader getBytes:dataByte range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    //解压内存流
    CompressionData = [NSData dataWithBytes:dataByte length:(_sectionSize - _headerSize)];
    decompressionData = [[CompressionData zlibInflate] retain];
    free(dataByte);
    
    //解析CDB的实际内容
    long decCurrPostion = 0;
    while (decCurrPostion != [decompressionData length]) {
        IMBListContainerHeader *containerHeader = [[IMBListContainerHeader alloc] init];
        decCurrPostion = [containerHeader read:iPod reader:decompressionData currPosition:decCurrPostion];
        [_childSections addObject:containerHeader];
        [containerHeader release];
    }
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    if ([iPod tracks] != nil) {
        for (IMBTrack *track in [[iPod tracks] trackArray]) {
            if ([track isDirty] == TRUE) {
                [dirtyTracksArray addObject:track];
            }
        }
        
        for (IMBPlaylist *playlist in [[iPod playlists] playlistArray]) {
            if ([playlist isDirty] == TRUE) {
                [dirtyPlaylistArray addObject:playlist];
            }
        }
    }
    
    NSMutableData *contentsWriter = [[NSMutableData alloc] init];    
    IMBListContainerHeader *containerHeader = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        containerHeader = [_childSections objectAtIndex:i];
        [containerHeader write:contentsWriter];
    }
    NSData *data = [[contentsWriter zlibDeflate] retain];
    [contentsWriter release];
    contentsWriter = nil;
    _sectionSize = [self getSectionSize] + (int)[data length];
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    [writer appendBytes:&_versionNumber length:sizeof(_versionNumber)];
    [writer appendBytes:&_listContainerCount length:sizeof(_listContainerCount)];
    [writer appendBytes:&_iD length:sizeof(_iD)];
    [writer appendBytes:_unk2 length:unk2Length];
    [writer appendBytes:&_hashingScheme length:sizeof(_hashingScheme)];
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    [writer appendData:data];
    [data release];
    data = nil;
}

- (void)iTunesDB_DatabaseWritten:(IMBBaseDatabase*)sender parms:(NSMutableDictionary*)parms {
    Boolean ISIOS5Sync = false;
    IMBSqliteTables *sqlTables = nil;
    switch (iPod.deviceInfo.family)
    {
        case iPod_Nano_Gen5:
            sqlTables = [[IMBSqliteTables_Nano5G alloc] initWithIPod:iPod];
            break;
        case iPod_Nano_Gen6:
        case iPod_Nano_Gen7:
            sqlTables = [[IMBSqliteTables_Nano6G alloc] initWithIPod:iPod];
            break;
        default:
            break;
    }
    
    if (iPod.deviceInfo.isIOSDevice) {
        ISIOS5Sync = [[iPod deviceInfo] airSync];
        NSString *deviceVersion = [[iPod deviceInfo] productVersion];
        if ([deviceVersion hasPrefix:@"4"] == YES) {
            sqlTables = [[IMBSqliteTables_4 alloc] initWithIPod:iPod];
        } else if ([deviceVersion hasPrefix:@"3.1"] == YES) {
            sqlTables = [[IMBSqliteTables_31 alloc] initWithIPod:iPod];
        } else if ([deviceVersion hasPrefix:@"3"] == YES) {
            sqlTables = [[IMBSqliteTables alloc] initWithIPod:iPod];
        } 
    }
    if (ISIOS5Sync == NO) {
        [sqlTables updateTracks:dirtyTracksArray];
        [sqlTables updatePlaylists:dirtyPlaylistArray];
        [sqlTables save];
        [sqlTables updateLocationsCBK];
    }
    
    if (sqlTables != nil) {
        [sqlTables release];
        sqlTables = nil;
    }
}

- (int)getSectionSize{
    return _headerSize;
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
