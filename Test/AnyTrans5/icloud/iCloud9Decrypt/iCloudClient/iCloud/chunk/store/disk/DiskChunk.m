//
//  DiskChunk.m
//
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "DiskChunk.h"
#import "Arrays.h"
#import "CategoryExtend.h"

@interface DiskChunk ()

@property (nonatomic, readwrite, retain) NSMutableData *checksum;
@property (nonatomic, readwrite, retain) NSString *file;

@end

@implementation DiskChunk
@synthesize checksum = _checksum;
@synthesize file = _file;

- (id)initWithChecksum:(NSMutableData*)checksum withFile:(NSString*)file {
    if (self = [super init]) {
        if ([NSString isNilOrEmpty:file]) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"file" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setFile:file];
        NSMutableData *tmpData = [Arrays copyOfWithData:checksum withNewLength:(int)(checksum.length)];
        [self setChecksum:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_checksum != nil) [_checksum release]; _checksum = nil;
    if (_file != nil) [_file release]; _file = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)getChecksum {
    NSMutableData *retData = nil;
    if ([self checksum]) {
        retData = [Arrays copyOfWithData:[self checksum] withNewLength:(int)([self checksum].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSFileHandle*)inputStream {
    @try {
        return [NSFileHandle openPath:[self file] withAccess:OpenRead];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}

- (long)copyTo:(NSFileHandle*)output {
    @try {
        long bytes = 0;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self file]] && output != nil) {
            NSFileHandle *inputStream = [NSFileHandle openPath:[self file] withAccess:OpenRead];
            int maxLength = 124288;
            NSMutableData *readBuffer = [[NSMutableData alloc] initWithSize:maxLength];
            BOOL endOfStreamReached = NO;
            while (!endOfStreamReached) {
                int bytesRead = [inputStream read:readBuffer withOffset:0 withCount:maxLength];
                if (bytesRead == 0) {
                    endOfStreamReached = YES;
                } else if (bytesRead == -1) {
                    endOfStreamReached = YES;
                } else {
                    [output write:readBuffer withOffset:0 withCount:bytesRead];
                    bytes += bytesRead;
                }
            }
#if !__has_feature(objc_arc)
            if (inputStream != nil) [inputStream release]; inputStream = nil;
#endif
        }
        NSLog(@"-- copyTo() - written (bytes): %ld", bytes);
        return bytes;
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object == nil) {
        return NO;
    }
    if ([self class] != [object class]) {
        return NO;
    }
    DiskChunk *other = (DiskChunk*)object;
    if (![Arrays areEqualWithByteArray:[self checksum] withB:[other checksum]]) {
        return NO;
    }
    if ([[self file] isEqualToString:[other file]]) {
        return NO;
    }
    return YES;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DiskChunk{ file = %@ }", [self file]];
}

@end

@interface Builder ()

@property (nonatomic, readwrite, retain) NSMutableData *checksum;
@property (nonatomic, readwrite, retain) NSString *file;
@property (nonatomic, readwrite, retain) NSFileHandle *outputStream;

@end

@implementation Builder
@synthesize checksum = _checksum;
@synthesize file = _file;
@synthesize outputStream = _outputStream;

- (id)initWithChecksum:(NSMutableData*)checksum withFile:(NSString*)file {
    if (self = [super init]) {
        if ([NSString isNilOrEmpty:file]) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"file" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setFile:file];
        NSMutableData *tmpData = [Arrays copyOfWithData:checksum withNewLength:(int)(checksum.length)];
        [self setChecksum:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_checksum != nil) [_checksum release]; _checksum = nil;
    if (_file != nil) [_file release]; _file = nil;
    [super dealloc];
#endif
}

- (NSFileHandle*)getOutputStream {
    if ([self outputStream] != nil) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"output stream already open" userInfo:nil];
    }
    
    NSString *parentDir = [[self file] getParentDirectory];
    if (![NSString isNilOrEmpty:parentDir]) {
        // TODO more specific error for FileAlreadyExistsException in case of file blocking directory creation.
        // Eg. a file name '0' in the path will block a directory '0' being created.
        if (![[NSFileManager defaultManager] fileExistsAtPath:parentDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:parentDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self file]]) {
        [[NSFileManager defaultManager] createFileAtPath:[self file] contents:nil attributes:nil];
    }
    
    NSFileHandle *tmpHandle = [[NSFileHandle alloc] initWithPath:[self file] withAccess:OpenWrite];
    [self setOutputStream:tmpHandle];
#if !__has_feature(objc_arc)
    if (tmpHandle != nil) [tmpHandle release]; tmpHandle = nil;
#endif
    return [self outputStream];
}

- (Chunk*)build {
    if ([self outputStream] == nil) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"no output stream" userInfo:nil];
    }
    [[self outputStream] closeFile];
    return [[[DiskChunk alloc] initWithChecksum:[self checksum] withFile:[self file]] autorelease];
}

@end