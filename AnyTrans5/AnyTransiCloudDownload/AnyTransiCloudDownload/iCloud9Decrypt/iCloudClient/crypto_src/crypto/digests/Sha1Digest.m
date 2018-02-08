//
//  Sha1Digest.m
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "Sha1Digest.h"
#import "CategoryExtend.h"
#import "Pack.h"

@interface Sha1Digest ()

@property (nonatomic, readwrite, assign) uint h1;
@property (nonatomic, readwrite, assign) uint h2;
@property (nonatomic, readwrite, assign) uint h3;
@property (nonatomic, readwrite, assign) uint h4;
@property (nonatomic, readwrite, assign) uint h5;
@property (nonatomic, readwrite, retain) NSMutableArray *x;
@property (nonatomic, readwrite, assign) int xOff;

@end

@implementation Sha1Digest
@synthesize h1 = _h1;
@synthesize h2 = _h2;
@synthesize h3 = _h3;
@synthesize h4 = _h4;
@synthesize h5 = _h5;
@synthesize x = _x;
@synthesize xOff = _xOff;

static const int DigestLength = 20;

- (id)init {
    if (self = [super init]) {
        @autoreleasepool {
            NSMutableArray *tmpX = [[NSMutableArray alloc] initWithSize:80];
            [self setX:tmpX];
#if !__has_feature(objc_arc)
            if (tmpX != nil) [tmpX release]; tmpX = nil;
#endif
            [self reset];
        }
        return self;
    } else {
        return nil;
    }
}

/**
 * Copy constructor.  This will copy the state of the provided
 * message digest.
 */
- (id)initWithSha1Digest:(Sha1Digest*)t {
    if (self = [super initWithGeneralDigest:t]) {
        @autoreleasepool {
            NSMutableArray *tmpX = [[NSMutableArray alloc] initWithSize:80];
            [self setX:tmpX];
#if !__has_feature(objc_arc)
            if (tmpX != nil) [tmpX release]; tmpX = nil;
#endif
            [self copyIn:t];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setX:nil];
    [super dealloc];
#endif
}

- (void)copyIn:(Sha1Digest*)t {
    [super copyIn:t];
    
    [self setH1:t.h1];
    [self setH2:t.h2];
    [self setH3:t.h3];
    [self setH4:t.h4];
    [self setH5:t.h5];
    
    [[self x] copyFromIndex:0 withSource:[t x] withSourceIndex:0 withLength:(int)([t x].count)];
    [self setXOff:t.xOff];
}

- (NSString*)algorithmName {
    return @"SHA-1";
}

- (int)getDigestSize {
    return DigestLength;
}

- (void)processWord:(NSMutableData*)input withInOff:(int)inOff {
    [self x][self.xOff] = @([Pack BE_To_UInt32:input withOff:inOff]);
    
    if (++self.xOff == 16) {
        [self processBlock];
    }
}

- (void)processLength:(int64_t)bitLength {
    if (self.xOff > 14) {
        [self processBlock];
    }
    
    @autoreleasepool {
        [self x][14] = @((uint)((uint64_t)bitLength >> 32));
        [self x][15] = @((uint)((uint64_t)bitLength));
    }
}

- (int)doFinal:(NSMutableData*)output withOutOff:(int)outOff {
    [self finish];
    
    [Pack UInt32_To_BE:self.h1 withBs:output withOff:outOff];
    [Pack UInt32_To_BE:self.h2 withBs:output withOff:(outOff + 4)];
    [Pack UInt32_To_BE:self.h3 withBs:output withOff:(outOff + 8)];
    [Pack UInt32_To_BE:self.h4 withBs:output withOff:(outOff + 12)];
    [Pack UInt32_To_BE:self.h5 withBs:output withOff:(outOff + 16)];
    
    [self reset];
    
    return DigestLength;
}

/**
 * reset the chaining variables
 */
- (void)reset {
    @autoreleasepool {
        [super reset];
        
        [self setH1:0x67452301];
        [self setH2:0xefcdab89];
        [self setH3:0x98badcfe];
        [self setH4:0x10325476];
        [self setH5:0xc3d2e1f0];
        
        self.xOff = 0;
        [[self x] clearFromIndex:0 withLength:(int)([self x].count)];        
    }
}


// Additive constants
static const uint Y1 = 0x5a827999;
static const uint Y2 = 0x6ed9eba1;
static const uint Y3 = 0x8f1bbcdc;
static const uint Y4 = 0xca62c1d6;

+ (uint)f:(uint)u withV:(uint)v withW:(uint)w {
    return (u & v) | (~u & w);
}

+ (uint)h:(uint)u withV:(uint)v withW:(uint)w {
    return u ^ v ^ w;
}

+ (uint)g:(uint)u withV:(uint)v withW:(uint)w {
    return (u & v) | (u & w) | (v & w);
}

- (void)processBlock {
    // expand 16 word block into 80 word block.
    @autoreleasepool {
        for (int i = 16; i < 80; i++) {
            uint t = [([self x][i - 3]) unsignedIntValue] ^ [([self x][i - 8]) unsignedIntValue] ^ [([self x][i - 14]) unsignedIntValue] ^ [([self x][i - 16]) unsignedIntValue];
            [self x][i] = @(t << 1 | t >> 31);
        }
        // set up working variables.
        uint A = self.h1;
        uint B = self.h2;
        uint C = self.h3;
        uint D = self.h4;
        uint E = self.h5;
        
        // round 1
        int idx = 0;
        
        for (int j = 0; j < 4; j++) {
            E += (A << 5 | (A >> 27)) + [Sha1Digest f:B withV:C withW:D] + [([self x][idx++]) unsignedIntValue] + Y1;
            B = B << 30 | (B >> 2);
            
            D += (E << 5 | (E >> 27)) + [Sha1Digest f:A withV:B withW:C] + [([self x][idx++]) unsignedIntValue] + Y1;
            A = A << 30 | (A >> 2);
            
            C += (D << 5 | (D >> 27)) + [Sha1Digest f:E withV:A withW:B] + [([self x][idx++]) unsignedIntValue] + Y1;
            E = E << 30 | (E >> 2);
            
            B += (C << 5 | (C >> 27)) + [Sha1Digest f:D withV:E withW:A] + [([self x][idx++]) unsignedIntValue] + Y1;
            D = D << 30 | (D >> 2);
            
            A += (B << 5 | (B >> 27)) + [Sha1Digest f:C withV:D withW:E] + [([self x][idx++]) unsignedIntValue] + Y1;
            C = C << 30 | (C >> 2);
        }
        
        // round 2
        for (int j = 0; j < 4; j++) {
            E += (A << 5 | (A >> 27)) + [Sha1Digest h:B withV:C withW:D] + [([self x][idx++]) unsignedIntValue] + Y2;
            B = B << 30 | (B >> 2);
            
            D += (E << 5 | (E >> 27)) + [Sha1Digest h:A withV:B withW:C] + [([self x][idx++]) unsignedIntValue] + Y2;
            A = A << 30 | (A >> 2);
            
            C += (D << 5 | (D >> 27)) + [Sha1Digest h:E withV:A withW:B] + [([self x][idx++]) unsignedIntValue] + Y2;
            E = E << 30 | (E >> 2);
            
            B += (C << 5 | (C >> 27)) + [Sha1Digest h:D withV:E withW:A] + [([self x][idx++]) unsignedIntValue] + Y2;
            D = D << 30 | (D >> 2);
            
            A += (B << 5 | (B >> 27)) + [Sha1Digest h:C withV:D withW:E] + [([self x][idx++]) unsignedIntValue] + Y2;
            C = C << 30 | (C >> 2);
        }
        
        // round 3
        for (int j = 0; j < 4; j++) {
            E += (A << 5 | (A >> 27)) + [Sha1Digest g:B withV:C withW:D] + [([self x][idx++]) unsignedIntValue] + Y3;
            B = B << 30 | (B >> 2);
            
            D += (E << 5 | (E >> 27)) + [Sha1Digest g:A withV:B withW:C] + [([self x][idx++]) unsignedIntValue] + Y3;
            A = A << 30 | (A >> 2);
            
            C += (D << 5 | (D >> 27)) + [Sha1Digest g:E withV:A withW:B] + [([self x][idx++]) unsignedIntValue] + Y3;
            E = E << 30 | (E >> 2);
            
            B += (C << 5 | (C >> 27)) + [Sha1Digest g:D withV:E withW:A] + [([self x][idx++]) unsignedIntValue] + Y3;
            D = D << 30 | (D >> 2);
            
            A += (B << 5 | (B >> 27)) + [Sha1Digest g:C withV:D withW:E] + [([self x][idx++]) unsignedIntValue] + Y3;
            C = C << 30 | (C >> 2);
        }
        
        // round 4
        for (int j = 0; j < 4; j++) {
            E += (A << 5 | (A >> 27)) + [Sha1Digest h:B withV:C withW:D] + [([self x][idx++]) unsignedIntValue] + Y4;
            B = B << 30 | (B >> 2);
            
            D += (E << 5 | (E >> 27)) + [Sha1Digest h:A withV:B withW:C] + [([self x][idx++]) unsignedIntValue] + Y4;
            A = A << 30 | (A >> 2);
            
            C += (D << 5 | (D >> 27)) + [Sha1Digest h:E withV:A withW:B] + [([self x][idx++]) unsignedIntValue] + Y4;
            E = E << 30 | (E >> 2);
            
            B += (C << 5 | (C >> 27)) + [Sha1Digest h:D withV:E withW:A] + [([self x][idx++]) unsignedIntValue] + Y4;
            D = D << 30 | (D >> 2);
            
            A += (B << 5 | (B >> 27)) + [Sha1Digest h:C withV:D withW:E] + [([self x][idx++]) unsignedIntValue] + Y4;
            C = C << 30 | (C >> 2);
        }
        
        self.h1 += A;
        self.h2 += B;
        self.h3 += C;
        self.h4 += D;
        self.h5 += E;
        
        // reset start of the buffer.
        self.xOff = 0;
        [[self x] clearFromIndex:0 withLength:16];
    }
}

- (Memoable*)copy {
    return [[[Sha1Digest alloc] initWithSha1Digest:self] autorelease];
}

- (void)reset:(Memoable*)other {
    Sha1Digest *d = (Sha1Digest*)other;
    
    [self copyIn:d];
}

@end
