//
//  IMBIPodImage.m
//  iMobieTrans
//
//  Created by Pallas on 1/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBIPodImage.h"
#import "IMBUnknownMHOD.h"
#import "IMBMHODType2.h"
#import "IMBIDGenerator.h"
#import "IMBArtworkHelper.h"
#import "IMBDeviceInfo.h"

@implementation IMBIPodImage
@synthesize iD = _iD;
@synthesize trackDBID = _trackDBID;
@synthesize usedCount = _usedCount;
@synthesize originalImageSize = _originalImageSize;

- (id)init {
    self = [super init];
    if (self) {
        _requiredHeaderSize = 64;
        _formatElements = [[NSMutableArray alloc] init];
        _allElements = [[NSMutableArray alloc] init];
        _formatsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_formatElements != nil) {
        [_formatElements release];
        _formatElements = nil;
    }
    if (_allElements != nil) {
        [_allElements release];
        _allElements = nil;
    }
    if (_formatsArray != nil) {
        [_formatsArray release];
        _formatsArray = nil;
    }
    [super dealloc];
}

- (int)formatsCount{
    if (_formatElements != nil) {
        return (int)_formatElements.count;
    }
    return 0;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<IMBIPodImage _iD=%d, \n trackDBID=%lld, \n usedCount=%d, \n _originalImageSize=%d, \n _formatsArray=%@ >"
            ,_iD,_trackDBID,_usedCount,_originalImageSize,_formatElements];
}

- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    currPosition = [super read:ipod reader:reader currPosition:currPosition];
    
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
    [self validateHeader:@"mhii"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    int childCount = 0;
    readLength = sizeof(childCount);
    [reader getBytes:&childCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_iD);
    [reader getBytes:&_iD range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_trackDBID);
    [reader getBytes:&_trackDBID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk1);
    [reader getBytes:&_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk2);
    [reader getBytes:&_unk2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk3);
    [reader getBytes:&_unk3 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk4);
    [reader getBytes:&_unk4 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk5);
    [reader getBytes:&_unk5 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_originalImageSize);
    [reader getBytes:&_originalImageSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk6);
    [reader getBytes:&_unk6 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_usedCount);
    [reader getBytes:&_usedCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    readLength = sizeof(_unk7);
    [reader getBytes:&_unk7 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    currPosition = [super readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < childCount; i++) {
        IMBBaseMHODElement *mhodHeader = [[IMBBaseMHODElement alloc] init];
        currPosition = [mhodHeader read:ipod reader:reader currPosition:currPosition];
        
        IMBBaseMHODElement *mhod = nil;
        if ([mhodHeader type] < 6) {
            mhod = [[IMBMHODType2 alloc] init];
            [_formatElements addObject:mhod];
        } else {
            mhod = [[IMBUnknownMHOD alloc] init];
        }
        [mhod setHeader:mhodHeader];
        currPosition = [mhod read:ipod reader:reader currPosition:currPosition];
        [_allElements addObject:mhod];
        [mhodHeader release];
        mhodHeader = nil;
        [mhod release];
        mhod = nil;
    }
    return currPosition;
}

- (void)write:(NSMutableData *)writer {
    _sectionSize = [self getSectionSize];
    NSLog(@"IMBIPodImage sectionSize is %i", _sectionSize);
    [writer appendBytes:_identifier length:identifierLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    int allEleCount = (int)[_allElements count];
    [writer appendBytes:&allEleCount length:sizeof(allEleCount)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_iD length:sizeof(_iD)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_trackDBID length:sizeof(_trackDBID)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk1 length:sizeof(_unk1)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk2 length:sizeof(_unk2)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk3 length:sizeof(_unk3)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk4 length:sizeof(_unk4)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk5 length:sizeof(_unk5)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_originalImageSize length:sizeof(_originalImageSize)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk6 length:sizeof(_unk6)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_usedCount length:sizeof(_usedCount)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:&_unk7 length:sizeof(_unk7)];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    NSLog(@"length is %lu", (unsigned long)[writer length]);
    
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_allElements count]; i++) {
        mhod = [_allElements objectAtIndex:i];
        [mhod write:writer];
    }
}

- (int)getSectionSize {
    int size = _headerSize;
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_allElements count]; i++) {
        mhod = [_allElements objectAtIndex:i];
        size += [mhod getSectionSize];
    }
    return size;
}

- (NSMutableArray*)getFormats {
    if (_formatsArray != nil && [_formatsArray count] > 0) {
        [_formatsArray removeAllObjects];
    }
    for (IMBMHODType2 *mhod in _formatElements) {
        if ([mhod getArtworkFormat] != nil && [[mhod getArtworkFormat] width] > 0) {
            [_formatsArray addObject:[mhod getArtworkFormat]];
        }
    }
    return _formatsArray;
}

- (void)setIsPhotoFormat:(BOOL)isPhotoFormat {
    for (IMBMHODType2 *mhod in _formatElements) {
        [[mhod getArtworkFormat] setIsPhoto:isPhotoFormat];
    }
}

- (IMBIPodImageFormat*)getSmallestFormat {
    IMBIPodImageFormat *format = [[_formatElements objectAtIndex:0] getArtworkFormat];
    NSMutableArray *supportedFormats = nil;
    if ([format isPhoto] == TRUE) {
        supportedFormats = [[iPod deviceInfo] supportedPhoteFormats];
    } else {
        supportedFormats = [[iPod deviceInfo] supportedArtworkFormats];
    }
    
    for (IMBMHODType2 *mhod in _formatElements) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ([(IMBIPodImageFormat*)evaluatedObject formatID] == [[mhod getArtworkFormat] formatID] || [[mhod getArtworkFormat] formatID] == 1);
        }];
        
        NSArray *searchResult = [supportedFormats filteredArrayUsingPredicate:pre];
        if ([mhod getArtworkFormat] != nil && [[mhod getArtworkFormat] imageSize] < [format imageSize] &&
            (searchResult != nil && [searchResult count] > 0)) {
            format = [mhod getArtworkFormat];
        }
    }
    return format;
}

- (IMBIPodImageFormat*)getLargestFormat {
    if ([_formatElements count] == 0) {
        return nil;
    }
    IMBIPodImageFormat *format =[self getSmallestFormat];
    
    NSMutableArray *supportedFormats = nil;
    if ([format isPhoto] == TRUE) {
        supportedFormats = [[iPod deviceInfo] supportedPhoteFormats];
    } else {
        supportedFormats = [[iPod deviceInfo] supportedArtworkFormats];
    }
    
    for (IMBMHODType2 *mhod in _formatElements) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ([(IMBIPodImageFormat*)evaluatedObject formatID] == [[mhod getArtworkFormat] formatID] || [[mhod getArtworkFormat] formatID] == 1);
        }];
        
        NSArray *searchResult = [supportedFormats filteredArrayUsingPredicate:pre];
        if ([mhod getArtworkFormat] != nil && [[mhod getArtworkFormat] imageSize] > [format imageSize] &&
            (searchResult != nil && [searchResult count] > 0)) {
            format = [mhod getArtworkFormat];
        }
    }
    return format;
}

- (void)create:(IMBiPod*)ipod track:(IMBTrack*)track image:(NSImage*)image {
    iPod = ipod;
    identifierLength = 4;
    _identifier = (char*)[@"mhii" UTF8String];
    _headerSize = 152;
    _iD = [[iPod idGenerator] getNewArtworkID];
    _trackDBID = [track dbID];
    unusedHeaderLength = _headerSize - _requiredHeaderSize;
    _unusedHeader = malloc(unusedHeaderLength + 1);
    memset(_unusedHeader, 0, malloc_size(_unusedHeader));
    
    _usedCount = 1;
    _unk7 = 1;
    
    for (IMBSupportedArtworkFormat *supportedFormat in [[iPod deviceInfo] supportedArtworkFormats]) {
        if ([track isVideo] == FALSE && [supportedFormat videoOnly]) {
            continue;
        }
        
        IMBMHODType2 *mhod = [[IMBMHODType2 alloc] init];
        //NSImage *resized = [IMBArtworkHelper generateResizedImage:image :supportedFormat];
        //NSData *data = [IMBArtworkHelper getByteData:resized];
        NSData *data = [IMBArtworkHelper generateResizedImageData:image SupportedFormat:supportedFormat];
        [mhod create:iPod format:supportedFormat imageData:data];
        
        [_formatElements addObject:mhod];
        [_allElements addObject:mhod];
        [mhod release];
        mhod = nil;
    }
}

- (void)update:(NSImage*)image {
    for (IMBMHODType2 *mhod in _formatElements) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [(IMBSupportedArtworkFormat*)evaluatedObject formatID] == [[mhod getArtworkFormat] formatID];
        }];
        NSArray *preArray = [[[iPod deviceInfo] supportedArtworkFormats] filteredArrayUsingPredicate:pre];
        IMBSupportedArtworkFormat *supportedFormat = nil;
        if (preArray != nil && [preArray count] > 0) {
            supportedFormat = [preArray objectAtIndex:0];
        }
        if (supportedFormat == nil) {
            continue;
        }
        
        if ([[mhod getArtworkFormat] isFullResolution] == TRUE) {
            continue;
        }
        
        //NSImage *resized = [IMBArtworkHelper generateResizedImage:image :supportedFormat];
        //NSData *data = [IMBArtworkHelper getByteData:resized];
        NSData *data = [IMBArtworkHelper generateResizedImageData:image SupportedFormat:supportedFormat];
        [[mhod getArtworkFormat] updateImageData:data];
    }
    
    for (IMBMHODType2 *mhod in _formatElements) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [(IMBSupportedArtworkFormat*)evaluatedObject formatID] == [[mhod getArtworkFormat] formatID];
        }];
        
        NSArray *preArray = [[[iPod deviceInfo] supportedArtworkFormats] filteredArrayUsingPredicate:pre];
        if (preArray == nil || [preArray count] == 0) {
            [_formatElements removeObject:mhod];
        }
    }
}

@end
