//
//  SecP160R2Curve.m
//  
//
//  Created by Pallas on 5/31/16.
//
//  Complete

#import "SecP160R2Curve.h"
#import "SecP160R2Point.h"
#import "SecP160R2FieldElement.h"

#import "CategoryExtend.h"
#import "BigInteger.h"
#import "Hex.h"

@interface SecP160R2Curve ()

@property (nonatomic, readwrite, retain) SecP160R2Point *m_infinity;

@end

@implementation SecP160R2Curve
@synthesize m_infinity = _m_infinity;

+ (BigInteger*)q {
    static BigInteger *_q = nil;
    @synchronized(self) {
        if (_q == nil) {
            @autoreleasepool {
                _q = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFAC73"]];
            }
        }
    }
    return _q;
}

static int const SecP160R2_DEFAULT_COORDS = COORD_JACOBIAN;

- (id)init {
    if (self = [super initWithQ:[SecP160R2Curve q]]) {
        @autoreleasepool {
            SecP160R2Point *tmpPoint = [[SecP160R2Point alloc] initWithCurve:self withX:nil withY:nil];
            [self setM_infinity:tmpPoint];
            BigInteger *tmpa = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFAC70"]];
            [self setM_a:[self fromBigInteger:tmpa]];
            BigInteger *tmpb = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"B4E134D3FB59EB8BAB57274904664D5AF50388BA"]];
            [self setM_b:[self fromBigInteger:tmpb]];
            BigInteger *tmporder = [[BigInteger alloc] initWithSign:1 withBytes:[Hex decodeWithString:@"0100000000000000000000351EE786A818F3A1A16B"]];
            [self setM_order:tmporder];
#if !__has_feature(objc_arc)
            if (tmpPoint != nil) [tmpPoint release]; tmpPoint = nil;
            if (tmpa != nil) [tmpa release]; tmpa = nil;
            if (tmpb != nil) [tmpb release]; tmpb = nil;
            if (tmporder != nil) [tmporder release]; tmporder = nil;
#endif
            [self setM_cofactor:[BigInteger One]];
            [self setM_coord:SecP160R2_DEFAULT_COORDS];
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
    return [[[SecP160R2Curve alloc] init] autorelease];
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
    return [SecP160R2Curve q];
}

- (ECPoint*)infinity {
    return self.m_infinity;
}

- (int)fieldSize {
    return [[SecP160R2Curve q] bitLength];
}

- (ECFieldElement*)fromBigInteger:(BigInteger*)x {
    return [[[SecP160R2FieldElement alloc] initWithBigInteger:x] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withCompression:(BOOL)withCompression {
    return [[[SecP160R2Point alloc] initWithCurve:self withX:x withY:y withCompression:withCompression] autorelease];
}

- (ECPoint*)createRawPoint:(ECFieldElement*)x withY:(ECFieldElement*)y withZS:(NSMutableArray*)zs withCompression:(BOOL)withCompression {
    return [[[SecP160R2Point alloc] initWithCurve:self withX:x withY:y withZS:zs withCompression:withCompression] autorelease];
}

@end
