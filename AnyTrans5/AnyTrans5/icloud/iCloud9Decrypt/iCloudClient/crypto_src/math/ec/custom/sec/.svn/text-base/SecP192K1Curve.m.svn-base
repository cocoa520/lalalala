//
//  SecP192K1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP192K1Curve.h"
#import "SecP192K1Point.h"
#import "SecP192K1FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecP192K1Curve ()

@property (nonatomic, readwrite, retain) SecP192K1Point *m_infinity;

@end

@implementation SecP192K1Curve
@synthesize m_infinity = _m_infinity;

+ (BigInteger*)q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            @autoreleasepool {
                _q = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFEE37"]];
            }
        }
    }
    return _q;
}

static int const SECP192K1_DEFAULT_COORDS = COORD_JACOBIAN;

- (id)init {
    if (self = [super initWithQ:[SecP192K1Curve q]]) {
        @autoreleasepool {
            SecP192K1Point *tmpPoint = [[SecP192K1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            [self setM_a:[self fromBigInteger:[BigInteger Zero]]];
            [self setM_b:[self fromBigInteger:[BigInteger Three]]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"FFFFFFFFFFFFFFFFFFFFFFFE26F2FC170F69466A74DEFD8D"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger One]];
            [self setM_coord:SECP192K1_DEFAULT_COORDS];
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
    return [[[SecP192K1Curve alloc] init] autorelease];
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
    return [SecP192K1Curve q];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (int)fieldSize {
    return [[SecP192K1Curve q] bitLength];
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecP192K1FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint *)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecP192K1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint *)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecP192K1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

@end
