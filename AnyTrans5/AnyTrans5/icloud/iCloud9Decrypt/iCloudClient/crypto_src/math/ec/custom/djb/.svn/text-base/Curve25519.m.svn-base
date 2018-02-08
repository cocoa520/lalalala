//
//  Curve25519.m
//  
//
//  Created by Pallas on 5/25/16.
//
//  Complete

#import "Curve25519.h"
#import "ECCurve.h"
#import "BigInteger.h"
#import "Nat256.h"
#import "Curve25519FieldElement.h"
#import "Curve25519Field.h"
#import "Curve25519Point.h"
#import "Hex.h"

@interface Curve25519 ()

@property (nonatomic, readwrite, retain) Curve25519Point *m_infinity;

@end

@implementation Curve25519
@synthesize m_infinity = _m_infinity;

+ (BigInteger*)q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[Nat256 toBigInteger:[Curve25519Field P]] retain];
        }
    }
    return _q;
}

static int const Curve25519_DEFAULT_COORDS = COORD_JACOBIAN_MODIFIED;

- (id)init {
    if (self = [super initWithQ:[Curve25519 q]]) {
        @autoreleasepool {
            Curve25519Point *tmpPoint = [[Curve25519Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            BigInteger *tmpa = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA984914A144"]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"7B425ED097B425ED097B425ED097B425ED097B425ED097B4260B5E9C7710C864"]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED"]];
            [self setM_a:[self fromBigInteger:tmpa]];
            [self setM_b:[self fromBigInteger:tmpb]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpa != nil) [tmpa release]; tmpa = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger Eight]];
            [self setM_coord:Curve25519_DEFAULT_COORDS];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_infinity:nil];
    [super dealloc];
#endif
}

- (ECCurve*)cloneCurve {
    return [[[Curve25519 alloc] init] autorelease];
}

- (BOOL)supportsCoordinateSystem:(int)coord {
    switch (coord) {
        case COORD_JACOBIAN_MODIFIED: {
            return YES;
        }
        default: {
            return NO;
        }
    }
}

- (BigInteger*)Q {
    return [Curve25519 q];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (int)fieldSize {
    return [[Curve25519 q] bitLength];
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[Curve25519FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[Curve25519Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[Curve25519Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

@end
