//
//  FileChecksumChunkReferences.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "FileChecksumChunkReferencesEx.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "CategoryExtend.h"

@implementation FileChecksumChunkReferencesEx

+ (NSMutableDictionary*)fileSignatureToChunkReferenceList:(NSArray*)referencesList {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = [referencesList objectEnumerator];
    FileChecksumChunkReferences *references = nil;
    while (references = [iterator nextObject]) {
        [retDict setObject:[references chunkReferencesList] forKey:[NSString dataToHex:[references fileSignature]]];
    }
    return retDict;
}

@end
