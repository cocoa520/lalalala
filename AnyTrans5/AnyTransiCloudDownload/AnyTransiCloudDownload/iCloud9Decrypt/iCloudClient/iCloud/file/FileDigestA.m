//
//  FileDigestA.m
//  
//
//  Created by Pallas on 8/29/16.
//
//  Complete

#import "FileDigestA.h"
#import "Hex.h"
#import "Sha1Digest.h"

@interface FileDigestA ()

@property (nonatomic, readwrite, retain) Digest *digest;

@end

@implementation FileDigestA
@synthesize digest = _digest;

+ (NSMutableData*)SALT {
    static NSMutableData *_SALT = nil;
    @synchronized(self) {
        if (!_SALT) {
            _SALT = [[Hex decodeWithString:@"636F6D2E6170706C652E58617474724F626A65637453616C7400636F6D2E6170706C652E446174614F626A65637453616C7400"] retain];
        }
    }
    return _SALT;
}

- (id)init {
    if (self = [super init]) {
        Sha1Digest *sha1 = [[Sha1Digest alloc] init];
        [self setDigest:sha1];
#if !__has_feature(objc_arc)
        if (sha1) [sha1 release]; sha1 = nil;
#endif
        [[self digest] blockUpdate:[FileDigestA SALT] withInOff:0 withLength:(int)([FileDigestA SALT].length)];
        return self;
    } else {
        return nil;
    }
}

- (NSString*)algorithmName {
    return @"FileDigestA";
}

- (int)getDigestSize {
    return [[self digest] getDigestSize] + 1;
}

- (void)update:(Byte)input {
    [[self digest] update:input];
}

- (void)blockUpdate:(NSMutableData*)input withInOff:(int)inOff withLength:(int)length {
    [[self digest] blockUpdate:input withInOff:inOff withLength:length];
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    ((Byte*)(output.bytes))[outOff] = 0x01;
    [[self digest] doFinal:output withOutOff:(outOff + 1)];
    [self reset];
    return [self getDigestSize];
}

- (void)reset {
    [[self digest] reset];
    [[self digest] blockUpdate:[FileDigestA SALT] withInOff:0 withLength:(int)([FileDigestA SALT].length)];
}

@end
