//
//  SecP160K1Curve.m
//  
//
//  Created by Pallas on 6/1/16.
//
//  Complete

#import "SecP160K1Curve.h"
#import "SecP160R2Curve.h"
#import "SecP160K1Point.h"
#import "SecP160R2FieldElement.h"

#import "BigInteger.h"
#import "Hex.h"

@interface SecP160K1Curve ()

@property (nonatomic, readwrite, retain) SecP160K1Point *m_infinity;

@end

@implementation SecP160K1Curve
@synthesize m_infinity = _m_infinity;

+ (BigInteger*)q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            _q = [[SecP160R2Curve q] retain];
        }
    }
    return _q;
}

static int const SECP160K1_DEFAULT_COORDS = COORD_JACOBIAN;

- (id)init {
    if (self = [super initWithQ:[SecP160K1Curve q]]) {
        @autoreleasepool {
            SecP160K1Point *tmpPoint = [[SecP160K1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger Zero]]];
            [self setM_b:[self fromBigInteger:[BigInteger Seven]]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"0100000000000000000001B8FA16DFAB9ACA16B6B3"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger One]];
            [self setM_coord:SECP160K1_DEFAULT_COORDS];
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
    return [[[SecP160K1Curve alloc] init] autorelease];
}

- (BOOL)supportsCoordinateSystem:(int)coord {
    switch (coord) {
        case COORD_JACOBIAN: {
            return YES;
        }
        default: {
            return NO;
        }
    }
}

- (BigInteger*)Q {
    return [SecP160K1Curve q];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (int)fieldSize {
    return [[SecP160K1Curve q] bitLength];
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecP160R2FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint *)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecP160K1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint *)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecP160K1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

@end
