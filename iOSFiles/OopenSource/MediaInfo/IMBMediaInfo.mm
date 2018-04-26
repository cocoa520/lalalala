//
//  IMBMediaInfo.m
//  iMobieTrans
//
//  Created by iMobie on 5/4/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBMediaInfo.h"
#import "TempHelper.h"
#include <string>
#include <iostream>
#include "ZenLib/Ztring.h" //Note : I need it for universal atoi, but you have not to use it for be able to use MediaInfoLib
#include "MediaInfo/MediaInfo.h"
#define LENGTH_MAX 20

using namespace MediaInfoLib;
using namespace ZenLib;

#define LENGTH_MAX 20


#ifdef __MINGW32__
#ifdef _UNICODE
#define _itot _itow
#else //_UNICODE
#define _itot itoa
#endif //_UNICODE
#endif //__MINGW32

@implementation IMBMediaInfo
@synthesize path = _path;
@synthesize validTags = _validTags;
@synthesize validAudioProperties = _validAudioProperties;
@synthesize title = _title;
@synthesize artist = _artist;
@synthesize album = _album;
@synthesize comment = _comment;
@synthesize genre = _genre;
@synthesize track = _track;
@synthesize year = _year;
@synthesize artworkPath = _artworkPath;
@synthesize composer = _composer;
@synthesize isGotMetaData = _isGotMetaData;
@synthesize fileSize = _fileSize;
@synthesize AppleStoreAccount;
@synthesize AppleStoreCatalogID;
@synthesize albumArtist = _albumArtist;
@synthesize length = _length, sampleRate = _sampleRate, bitRate = _bitRate, channels = _channels;
@synthesize artworkData = _artworkData;
@synthesize videoheight = _videoheight;
@synthesize videowidth = _videowidth;
@synthesize isVideo = _isVideo;
- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}


+ (IMBMediaInfo *)singleton{
    static IMBMediaInfo *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBMediaInfo alloc] init];
		}
	}
	return _singleton;
}

- (void)openWithFilePath:(NSString *)filePath{
    @autoreleasepool {
        [self initDefaultValue];
        MediaInfo MI;
        Char *newpath = [self getWCharFromString:filePath];
        size_t retValue = MI.Open(newpath);
        MI.Option(__T("Complete"), __T("1"));
        MI.Inform();
        if(retValue == 1){
            self.isGotMetaData = true;
            self.title = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("FileName"), Info_Text, Info_Name).c_str()];
            self.artist = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("Performer"), Info_Text, Info_Name).c_str()];
            self.albumArtist = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("Album/Performer"), Info_Text, Info_Name).c_str()];
            self.album = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("Album"), Info_Text, Info_Name).c_str()];
            self.comment = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("Comment"), Info_Text, Info_Name).c_str()];
            self.genre = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("Genre"), Info_Text, Info_Name).c_str()];
            self.AppleStoreAccount = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("AppleStoreAccount"), Info_Text, Info_Name).c_str()];
            self.AppleStoreCatalogID = [self convertWCharToNSString:MI.Get(Stream_General, 0, __T("AppleStoreCatalogID"), Info_Text, Info_Name).c_str()];
            self.track = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_General, 0, __T("Track/Position"), Info_Text, Info_Name).c_str()]intValue]];
            self.year = [NSNumber numberWithUnsignedInt:[[[self convertWCharToNSString:MI.Get(Stream_General, 0, __T("Released_Date"), Info_Text, Info_Name).c_str()] lastPathComponent] intValue]];
            self.length = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_Audio, 0, __T("Duration"), Info_Text, Info_Name).c_str()]intValue]];
            self.fileSize = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_General, 0, __T("FileSize"), Info_Text, Info_Name).c_str()]intValue]];
            self.sampleRate = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_Audio, 0, __T("SamplingRate"), Info_Text, Info_Name).c_str()]intValue]];
            self.bitRate = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_General, 0, __T("BitRate"), Info_Text, Info_Name).c_str()]intValue]/1000];
            self.channels = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_Audio, 0, __T("Channel(s)"), Info_Text, Info_Name).c_str()]intValue]];
            if (_isVideo) {
                self.videoheight = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_Video, 0, __T("Height"), Info_Text, Info_Name).c_str()] intValue]];
                self.videowidth = [NSNumber numberWithUnsignedInt:[[self convertWCharToNSString:MI.Get(Stream_Video, 0, __T("Width"), Info_Text, Info_Name).c_str()]intValue]];
            }
            //获取mediaInfo 的artwork
            NSString *artworkPath = nil;
            NSString *alias = [[TempHelper getAppTempPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [self getRandomFileName:8]]];
            NSString *afilePath= [self getFilePathAlias:alias];
            artworkPath = afilePath;
            @try {
                const wchar_t *string = MI.Get(Stream_General, 0, __T("Cover_Data"), Info_Text, Info_Name).c_str(); // returns Blank
                const wchar_t *cmpstr = __T("unable to read data");
                
                if(string==NULL || wcscmp(string, cmpstr) == 0){
                    MI.Close();
                    return;
                }
                
                long strLength = wcslen(string) * sizeof(char*);
                if (strLength <= 0) {
                    MI.Close();
                    return;
                }
                
//            #if __x86_64__
//                return;
//            #else
                NSString *str = [self convertWCharToNSString:string];//[[[NSString alloc] initWithBytes:string length:strLength encoding:NSUTF32LittleEndianStringEncoding] autorelease];
                NSData *data = [NSData dataFromBase64String:str];
//                self.artworkData = data;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:artworkPath]) {
                    [fileManager removeItemAtPath:artworkPath error:NULL];
                }
                [data writeToFile:artworkPath atomically:YES];
//            #endif
            }
            @catch (NSException *exception) {
                NSLog(@"exception:%@",exception.reason);
            }
            @finally {
            }
            self.artworkPath = artworkPath;
            
        }
        else{
            self.isGotMetaData = false;
        }
        MI.Close();
    }
}

- (void)initDefaultValue{
    self.title = @"";
    self.artist = @"";
    self.album = @"";
    self.comment = @"";
    self.genre = @"";
    self.track = 0;
    self.year = 0;
    self.length = 0;
    self.fileSize = 0;
    self.sampleRate = 0;
    self.bitRate = 0;
    self.channels = 0;
    self.artworkPath = @"";
    self.artworkData = nil;
}


- (wchar_t *) getWCharFromString:(NSString *)string
{
    const char  *cString;
    cString = [string cStringUsingEncoding:NSUTF8StringEncoding];
    setlocale(LC_CTYPE, "UTF-8");
    size_t iLength = mbstowcs(NULL, cString, 0);
    size_t bufferSize = (iLength+1)*sizeof(wchar_t);
    wchar_t *stTmp = (wchar_t*)malloc(bufferSize);
    memset(stTmp, 0, bufferSize);
    mbstowcs(stTmp, cString, iLength);
    stTmp[iLength] = 0;
    printf("begin %ls",stTmp);
    return stTmp;
}


- (NSString *)convertWCharToNSString:(const wchar_t *)wchar{
    
//    size_t iLength = wcslen(wchar);
    char * dBuf=NULL;
    int maxSizeLength=wcstombs(dBuf, wchar, 0)+1;
    char *dest = (char *)malloc(maxSizeLength);
    wcstombs(dest,wchar,maxSizeLength);
    NSString *string = [[[NSString alloc] initWithCString:dest encoding:NSUTF8StringEncoding] autorelease];
    free(dest);
    return string;
}

- (void)dealloc{
    if (_path != nil) {
        [_path release];
        _path = nil;
    }
    [_albumArtist release],_albumArtist = nil;
    if (_artworkPath != nil) {
        [_artworkPath release];
        _artworkPath = nil;
    }
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    if (_artist != nil) {
        [_artist release];
        _artist = nil;
    }
    if (_album != nil) {
        [_album release];
        _album = nil;
    }
    if (_comment != nil) {
        [_comment release];
        _comment = nil;
    }
    if (_genre != nil) {
        [_genre release];
        _genre = nil;
    }
    if (_composer != nil) {
        [_composer release];
        _composer = nil;
    }
    if (_track != nil) {
        [_track release];
        _track = nil;
    }
    if (_year != nil) {
        [_year release];
        _year = nil;
    }
    if (_length != nil) {
        [_length release];
        _length = nil;
    }
    if (_sampleRate != nil) {
        [_sampleRate release];
        _sampleRate = nil;
    }
    if (_bitRate != nil) {
        [_bitRate release];
        _bitRate = nil;
    }
    if (_channels != nil) {
        [_channels release];
        _channels = nil;
    }
    if (_fileSize != nil) {
        [_fileSize release];
        _fileSize = nil;
    }
    
    [super dealloc];
}



- (NSString *)getArtwork:(NSString *)filePath mediaInfo:(MediaInfo)MI{
    NSString *artworkPath = nil;
    
    NSString *alias = [[TempHelper getAppTempPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [self getRandomFileName:8]]];
    NSString *afilePath= [self getFilePathAlias:alias];
    
    artworkPath = afilePath;
    const wchar_t *string = MI.Get(Stream_General, 0, __T("Cover_Data"), Info_Text, Info_Name).c_str(); // returns Blank
    long strLength = wcslen(string) * 4;
    if (strLength <= 0) {
        MI.Close();
        return nil;
    }
    @try {
        const wchar_t *cmpstr = __T("unable to read data");
        if(string==NULL || wcscmp(string, cmpstr) == 0){
            return nil;
        }
        NSString *str = [[[NSString alloc] initWithBytes:string length:strLength encoding:NSUTF32LittleEndianStringEncoding] autorelease];
        NSData *data = [NSData dataFromBase64String:str];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:artworkPath]) {
            [fileManager removeItemAtPath:artworkPath error:NULL];
        }
        [data writeToFile:artworkPath atomically:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception.reason);
    }
    @finally {
    }
    return artworkPath;
}

- (NSString*)getRandomFileName:(int)length {
    char charArr[length + 1];
    srandom((unsigned int)time((time_t *)NULL));
    for (int i = 0; i < length; i++) {
        long num = random();
        charArr[i] = (int)num % 52;
        if (charArr[i] < 26) {
            charArr[i] += (91 - 26);
        } else {
            charArr[i] += (123 - 52);
        }
    }
    charArr[length] ='\0';
    return [NSString stringWithCString:charArr encoding:NSUTF8StringEncoding];
}

-(NSString*)getFilePathAlias:(NSString*)filePath {
    NSString *newPath = filePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    int i = 1;
    NSString *filePathWithOutExt = [filePath stringByDeletingPathExtension];
    NSString *fileExtension = [filePath pathExtension];
    while ([fm fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@(%d).%@",filePathWithOutExt,i++,fileExtension];
    }
    return newPath;
}

@end
