//
//  ChunkChecksums.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkChecksums.h"
#import "Arrays.h"
#import "CategoryExtend.h"
#import "Digest.h"
#import "Sha256Digest.h"

@implementation ChunkChecksums

- (id)init {
#if !__has_feature(objc_arc)
    [self release];
#endif
    return nil;
}

+ (NSMutableData*)checksum:(int)type withData:(NSMutableData*)data {
    if (type != 1) {
        NSLog(@"-- checksum() - checksum type not supported: %d", type);
        return nil;
    }
    
    NSMutableData *hashType1 = [ChunkChecksums hashType1:data];
    
    NSMutableData *one = [[NSMutableData alloc] initWithSize:1];
    ((Byte*)(one.bytes))[0] = (Byte)0x01;
    NSMutableData *checksum = [[[NSMutableData alloc] initWithSize:((int)(one.length) + (int)(hashType1.length))] autorelease];
    [checksum copyFromIndex:0 withSource:one withSourceIndex:0 withLength:(int)(one.length)];
    [checksum copyFromIndex:(int)(one.length) withSource:hashType1 withSourceIndex:0 withLength:(int)(hashType1.length)];
#if !__has_feature(objc_arc)
    if (one) [one release]; one = nil;
#endif
    return checksum;
}

+ (NSNumber*)matchToData:(NSMutableData*)checksum withData:(NSMutableData*)data {
    NSNumber *type = [ChunkChecksums checksumType:checksum];
    if (type != nil) {
        NSMutableData *checkData = [ChunkChecksums checksum:[type intValue] withData:data];
        return @([ChunkChecksums match:checkData withTwo:checksum]);
    }
    return nil;
}

+ (BOOL)match:(NSMutableData*)one withTwo:(NSMutableData*)two {
    if ([ChunkChecksums checksumType:one] != [ChunkChecksums checksumType:two]) {
        return NO;
    }
    
    NSData *hashOne = [ChunkChecksums checksumHash:one];
    if (hashOne == nil) {
        return NO;
    }
    
    NSData *hashTwo = [ChunkChecksums checksumHash:two];
    if (hashTwo == nil) {
        return NO;
    }
    
    BOOL matches = [Arrays areEqualWithByteArray:hashOne withB:hashTwo];
    return matches;
}

+ (NSNumber*)checksumType:(NSMutableData*)checksum {
    if (checksum.length == 0) {
        return nil;
    }
    
    int type = ((Byte*)(checksum.bytes))[0] & 0x7F;
    return @(type);
}

+ (NSData*)checksumHash:(NSMutableData*)checksum {
    if (!checksum || checksum.length == 0) {
        return nil;
    }
    NSMutableData *hash = nil;
    if (checksum) {
        hash = [Arrays copyOfRangeWithByteArray:checksum withFrom:1 withTo:(int)(checksum.length)];
    }
    return (hash ? [hash autorelease] : nil);
}

+ (NSMutableData*)hashType1:(NSMutableData*)data {
    Digest *digest = [[Sha256Digest alloc] init];
    NSMutableData *hash = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
    
    [digest reset];
    [digest blockUpdate:data withInOff:0 withLength:(int)(data.length)];
    [digest doFinal:hash withOutOff:0];
    [digest blockUpdate:hash withInOff:0 withLength:(int)(hash.length)];
    [digest doFinal:hash withOutOff:0];
    
    NSMutableData *checksum = nil;
    if (hash) {
        checksum = [Arrays copyOfWithData:hash withNewLength:20];
    }
#if !__has_feature(objc_arc)
    if (digest != nil) [digest release]; digest = nil;
    if (hash != nil) [hash release]; hash = nil;
#endif
    return (checksum ? [checksum autorelease] : nil);
}

@end
