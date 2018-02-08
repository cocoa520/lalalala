//
//  SecP192R1Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP192R1Curve.h"
#import "SecP192R1Point.h"
#import "SecP192R1FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecP192R1Curve ()

@property (nonatomic, readwrite, retain) SecP192R1Point *m_infinity;

@end

@implementation SecP192R1Curve
@synthesize m_infinity = _m_infinity;

+ (BigInteger*)q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            @autoreleasepool {
                _q = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFF"]];
            }
        }
    }
    return _q;
}

static int const SecP192R1_DEFAULT_COORDS = COORD_JACOBIAN;

- (id)init {
    if (self = [super initWithQ:[SecP192R1Curve q]]) {
        @autoreleasepool {
            SecP192R1Point *tmpPoint = [[SecP192R1Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            BigInteger *tmpa = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFC"]];
            [self setM_a:[self fromBigInteger:tmpa]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"64210519E59C80E70FA7E9AB72243049FEB8DEECC146B9B1"]];
            [self setM_b:[self fromBigInteger:tmpb]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"FFFFFFFFFFFFFFFFFFFFFFFF99DEF836146BC9B1B4D22831"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpa != nil) [tmpa release]; tmpa = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger One]];
            [self setM_coord:SecP192R1_DEFAULT_COORDS];
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
    return [[[SecP192R1Curve alloc] init] autorelease];
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
    return [SecP192R1Curve q];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (int)fieldSize {
    return [[SecP192R1Curve q] bitLength];
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecP192R1FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecP192R1Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecP192R1Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

@end
