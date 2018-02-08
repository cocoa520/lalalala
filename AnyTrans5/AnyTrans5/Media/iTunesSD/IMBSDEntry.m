//
//  IMBSDEntry.m
//  iMobieTrans
//
//  Created by Pallas on 1/23/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBSDEntry.h"
#import "IMBTrack.h"

@implementation IMBSDEntry

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithTrack:(IMBTrack *)track {
    self = [self init];
    if (self) {
        _entrySize = 558;
        _unk1 = 0x5aa501;
        _unk2 = malloc(19);
        memset(_unk2, 0, malloc_size(_unk2));
        unk2Length = 18;
        _unk3 = 0x200;
        _volume = 0x64;
        _fileName = [NSString stringWithFormat:@"/%@", [track filePath]];
        _shuffleFlag = YES;
        _bookmarkFlag = NO;
    }
    return self;
}

- (void)dealloc {
    free(_unk2);
    [super dealloc];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    [writer appendData:[MediaHelper intToITunesSDFormat:_entrySize]];
    [writer appendData:[MediaHelper intToITunesSDFormat:_unk1]];
    [writer appendBytes:_unk2 length:unk2Length];
    [writer appendData:[MediaHelper intToITunesSDFormat:_volume]];
    [writer appendData:[MediaHelper intToITunesSDFormat:[self getFileType]]];
    [writer appendData:[MediaHelper intToITunesSDFormat:_unk3]];
    [writer appendData:[self getSDFormatFileName]];
    [writer appendBytes:&_shuffleFlag length:sizeof(_shuffleFlag)];
    [writer appendBytes:&_bookmarkFlag length:sizeof(_bookmarkFlag)];
    [writer appendBytes:&_unk4 length:sizeof(_unk4)];
}

- (int)getSectionSize {
    return 0;
}

- (NSData*)getSDFormatFileName {
    _fileName = [_fileName stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSData *fileNameData = [_fileName dataUsingEncoding:NSUnicodeStringEncoding];
    return fileNameData;
}

- (int)getFileType {
    NSString *extension = nil;
    if ([_fileName length] > 3) {
        extension = [_fileName pathExtension];
    }
    
    if ([extension isEqualToString:@"mp3"]) {
        return 1;
    } else if ([extension isEqualToString:@"aac"] ||
               [extension isEqualToString:@"m4a"]) {
        return 2;
    } else if ([extension isEqualToString:@"wav"]) {
        return 3;
    } else {
        return 0;
    }
}

@end
