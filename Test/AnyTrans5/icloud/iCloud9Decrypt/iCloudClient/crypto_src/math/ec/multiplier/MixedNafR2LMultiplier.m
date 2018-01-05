//
//  MixedNafR2LMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "MixedNafR2LMultiplier.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "WNafUtilities.h"

@interface MixedNafR2LMultiplier ()

@property (nonatomic, readwrite, assign) int additionCoord;
@property (nonatomic, readwrite, assign) int doublingCoord;

@end

@implementation MixedNafR2LMultiplier
@synthesize additionCoord = _additionCoord;
@synthesize doublingCoord = _doublingCoord;

/**
 * By default, addition will be done in Jacobian coordinates, and doubling will be done in
 * Modified Jacobian coordinates (independent of the original coordinate system of each point).
 */
- (id)init {
    if (self = [self initWithAdditionCoord:COORD_JACOBIAN withDoublingCoord:COORD_JACOBIAN_MODIFIED]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithAdditionCoord:(int)additionCoord withDoublingCoord:(int)doublingCoord {
    if (self = [super init]) {
        [self setAdditionCoord:additionCoord];
        [self setDoublingCoord:doublingCoord];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        ECCurve *curveOrig = [p curve];
        
        ECCurve *curveAdd = [self configureCurve:curveOrig withCoord:[self additionCoord]];
        ECCurve *curveDouble = [self configureCurve:curveOrig withCoord:[self doublingCoord]];
        
        // NSMutableArray == int[]
        NSMutableArray *naf = [WNafUtilities generateCompactNaf:k];
        
        ECPoint *Ra = [curveAdd infinity];
        ECPoint *Td = [curveDouble importPoint:p];
        
        int zeroes = 0;
        for (int i = 0; i < naf.count; ++i) {
            int ni = [naf[i] intValue];
            int digit = ni >> 16;
            zeroes += ni & 0xFFFF;
            
            Td = [Td timesPow2:zeroes];
            
            ECPoint *Tj = [curveAdd importPoint:Td];
            if (digit < 0) {
                Tj = [Tj negate];
            }
            
            Ra = [Ra add:Tj];
            
            zeroes = 1;
        }
        retPoint = [curveOrig importPoint:Ra];
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

- (ECCurve*)configureCurve:(ECCurve*)c withCoord:(int)coord {
    if ([c coordinateSystem] == coord) {
        return c;
    }

    ECCurve *retCurve = nil;
    @autoreleasepool {
        if (![c supportsCoordinateSystem:coord]) {
            @throw [NSException exceptionWithName:@"Argument" reason:[NSString stringWithFormat:@"Coordinate system %d  not supported by this curve", coord] userInfo:nil];
        }
        
        retCurve = [[[c configure] setCoordinateSystemWithCoord:coord] create];
        [retCurve retain];
    }
    return (retCurve ? [retCurve autorelease] : nil);
}

@end
