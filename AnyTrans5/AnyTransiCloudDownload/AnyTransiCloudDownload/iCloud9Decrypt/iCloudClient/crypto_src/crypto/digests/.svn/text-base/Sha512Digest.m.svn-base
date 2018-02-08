//
//  Sha512Digest.m
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "Sha512Digest.h"
#import "Pack.h"

@implementation Sha512Digest

static const int DigestLength = 64;

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * Copy constructor.  This will copy the state of the provided
 * message digest.
 */
- (id)initWithSha512Digest:(Sha512Digest*)t {
    if (self = [super initWithLongDigest:t]) {
        return self;
    } else {
        return nil;
    }
}

- (NSString*)algorithmName {
    return @"SHA-512";
}

- (int)getDigestSize {
    return DigestLength;
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    [self finish];
    
    [Pack UInt64_To_BE:self.h1 withBs:output withOff:outOff];
    [Pack UInt64_To_BE:self.h2 withBs:output withOff:(outOff + 8)];
    [Pack UInt64_To_BE:self.h3 withBs:output withOff:(outOff + 16)];
    [Pack UInt64_To_BE:self.h4 withBs:output withOff:(outOff + 24)];
    [Pack UInt64_To_BE:self.h5 withBs:output withOff:(outOff + 32)];
    [Pack UInt64_To_BE:self.h6 withBs:output withOff:(outOff + 40)];
    [Pack UInt64_To_BE:self.h7 withBs:output withOff:(outOff + 48)];
    [Pack UInt64_To_BE:self.h8 withBs:output withOff:(outOff + 56)];
    
    [self reset];
    
    return DigestLength;
    
}

/**
 * reset the chaining variables
 */
- (void)reset {
    [super reset];
    
    /* SHA-512 initial hash value
     * The first 64 bits of the fractional parts of the square roots
     * of the first eight prime numbers
     */
    [self setH1:0x6a09e667f3bcc908];
    [self setH2:0xbb67ae8584caa73b];
    [self setH3:0x3c6ef372fe94f82b];
    [self setH4:0xa54ff53a5f1d36f1];
    [self setH5:0x510e527fade682d1];
    [self setH6:0x9b05688c2b3e6c1f];
    [self setH7:0x1f83d9abfb41bd6b];
    [self setH8:0x5be0cd19137e2179];
}

- (Memoable*)copy {
    return [[[Sha512Digest alloc] initWithSha512Digest:self] autorelease];
}

- (void)reset:(Memoable*)other {
    Sha512Digest *d = (Sha512Digest*)other;
    [self copyIn:d];
}

@end
