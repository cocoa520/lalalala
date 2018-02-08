//
//  DiskChunkStore.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "DiskChunkStore.h"
#import "CategoryExtend.h"
#import "DiskChunk.h"
#import "DiskChunkFiles.h"

@interface DiskChunkStore ()

@property (nonatomic, readwrite, retain) NSString *chunkFolder;

@end

@implementation DiskChunkStore
@synthesize chunkFolder = _chunkFolder;

- (id)initWithChunkFolder:(NSString*)chunkFolder {
    if (self = [super init]) {
        if (chunkFolder == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"chunkFolder" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setChunkFolder:chunkFolder];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_chunkFolder != nil) [_chunkFolder release]; _chunkFolder = nil;
    [super dealloc];
#endif
}

- (NSString*)file:(NSData*)checksum {
    NSString *filename = [DiskChunkFiles filename:checksum];
    return [[self chunkFolder] stringByAppendingPathComponent:filename];
}

- (Chunk*)chunk:(NSMutableData*)checksum {
    NSString *file = [self file:checksum];
    
    // DiskChunk instances are lightweight, not cached.
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:file] ? [[[DiskChunk alloc] initWithChecksum:checksum withFile:file] autorelease] : nil;
}

- (ChunkBuilder*)chunkBuilder:(NSMutableData*)checksum {
    NSString *file = [self file:checksum];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
//        NSLog(@"chunk overwritten: %@", [NSString dataToHex:checksum]);
    }
    
    return [[[Builder alloc] initWithChecksum:checksum withFile:file] autorelease];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DiskChunkStore{ chunkFolder = %@ }", [self chunkFolder]];
}

@end
