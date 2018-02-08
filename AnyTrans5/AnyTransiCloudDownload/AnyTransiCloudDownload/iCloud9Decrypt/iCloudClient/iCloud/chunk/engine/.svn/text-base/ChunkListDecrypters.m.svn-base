//
//  ChunkListDecrypters.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkListDecrypters.h"
#import "AuthorizedAssets.h"
#import "CategoryExtend.h"
#import "ChunkBuilder.h"
#import "ChunkChecksums.h"
#import "ChunkDecrypters.h"
#import "ChunkEncryptionKeys.h"
#import "ChunkReferences.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "ChunkStore.h"
#import "Voodoo.h"

@implementation ChunkListDecrypters

+ (NSMutableDictionary*)decrypt:(int)container withChunkInfoList:(NSArray*)chunkInfoList withChunkStore:(ChunkStore*)chunkStore withData:(NSMutableData*)data withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withAssets:(AuthorizedAssets*)assets withVoodoo:(Voodoo*)voodoo withCancel:(BOOL*)cancel {
    NSMutableDictionary *chunks = [[[NSMutableDictionary alloc] init] autorelease];
    
    for (int i = 0; i < chunkInfoList.count; i++) {
        if (*cancel) {
            break;
        }
        ChunkReference *chunkReference = [ChunkReferences chunkReference:container withChunkIndex:i];
        ChunkInfo *chunkInfo = [chunkInfoList objectAtIndex:i];
        
        typedef NSMutableData* (*MethodName)(id, SEL, ChunkReference*, Voodoo*, AuthorizedAssets*, BOOL*);
        MethodName methodName = (MethodName)imp;
        NSMutableData *keyEncryptionKey = methodName(target, selector, chunkReference, voodoo, assets, cancel);
        if (*cancel) {
            break;
        }
        Chunk *chunk = [self decrypt:chunkInfo withChunkStore:chunkStore withData:data withKek:keyEncryptionKey];
        
        if (chunk != nil) {
            [chunks setObject:chunk forKey:chunkReference];
        }
    }
    return chunks;
}

+ (Chunk*)decrypt:(ChunkInfo*)chunkInfo withChunkStore:(ChunkStore*)chunkStore withData:(NSMutableData*)data withKek:(NSMutableData*)kek {
    NSMutableData *tmpData = [[chunkInfo chunkEncryptionKey] mutableCopy];
    NSMutableData *key = [ChunkEncryptionKeys unwrapKey:kek withKeyData:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    if (key != nil) {
        return [self decrypt:chunkInfo withChunkStore:chunkStore withData:data withKey:key];
    } else {
        return nil;
    }
}

+ (Chunk*)decrypt:(ChunkInfo*)chunkInfo withChunkStore:(ChunkStore*)chunkStore withData:(NSMutableData*)data withKey:(NSMutableData *)key {
    int offset = [chunkInfo chunkOffset];
    int length = [chunkInfo chunkLength];
    
    if (offset + length > data.length) {
        NSLog(@"-- decrypt() - input data too short");
    }
    
    if (offset < 0 || length <= 0) {
        NSLog(@"-- decrypt() - cannot decrypt offset: 0x%@ length: 0x%@", [NSString intToHex:offset], [NSString intToHex:length]);
    }
    
    NSMutableData *chunkData = [ChunkDecrypters decrypt:key withData:data withOffset:offset withLength:length];
    if (chunkData == nil) {
        NSLog(@"-- decrypt() - decrypt failed");
        return nil;
    }
    NSMutableData *checksum = [self validate:chunkInfo withData:chunkData];
    if (checksum != nil) {
        return [self chunk:chunkStore withChecksum:checksum withData:chunkData];
    } else {
        return nil;
    }
}

+ (Chunk*)chunk:(ChunkStore*)chunkStore withChecksum:(NSMutableData*)checksum withData:(NSMutableData*)data {
    @try {
        // TODO rework with ChunkDecrypters for direct decryption to Chunk OutputStream.
        Chunk *chunk = [[chunkStore chunkBuilder:checksum] build:data];
        return chunk;
    }
    @catch (NSException *exception) {
        NSLog(@"-- chunk() - Exception: %@", [exception reason]);
        return nil;
    }
}

+ (NSMutableData*)validate:(ChunkInfo*)chunkInfo withData:(NSMutableData*)data {
    if (![chunkInfo hasChunkChecksum]) {
        NSLog(@"-- validate() - no checksum data for chunk");
        // Shouldn't happen, but we'll assume the data is valid and create a type 1 checksum for it.
        return [ChunkChecksums checksum:1 withData:data];
    }
    
    NSMutableData *checksum = [[[chunkInfo chunkChecksum] mutableCopy] autorelease];
    
    // If the checksum type is unknown/ match couldn't be made we'll assume the data checksums correctly.
    NSNumber *checked = [ChunkChecksums matchToData:checksum withData:data];
    if (checked == nil || [checked boolValue]) {
        return checksum;
    }
    return nil;
}

@end
