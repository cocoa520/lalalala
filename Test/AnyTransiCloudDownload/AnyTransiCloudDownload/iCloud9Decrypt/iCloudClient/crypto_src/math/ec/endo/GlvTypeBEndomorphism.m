//
//  GlvTypeBEndomorphism.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "GlvTypeBEndomorphism.h"
#import "ECCurve.h"
#import "GlvTypeBParameters.h"
#import "BigInteger.h"
#import "ECPointMap.h"
#import "ScaleXPointMap.h"

@interface GlvTypeBEndomorphism ()

@property (nonatomic, readwrite, retain) ECCurve *m_curve;
@property (nonatomic, readwrite, retain) GlvTypeBParameters *m_parameters;
@property (nonatomic, readwrite, retain) ECPointMap *m_pointMap;

@end

@implementation GlvTypeBEndomorphism
@synthesize m_curve = _m_curve;
@synthesize m_parameters = _m_parameters;
@synthesize m_pointMap = _m_pointMap;

- (id)initWithCurve:(ECCurve*)curve withParameters:(GlvTypeBParameters*)parameters {
    if (self = [super init]) {
        @autoreleasepool {
            [self setM_curve:curve];
            [self setM_parameters:parameters];
            ScaleXPointMap *tmpMap = [[ScaleXPointMap alloc] initWithScale:[curve fromBigInteger:[parameters beta]]];
            [self setM_pointMap:tmpMap];
#if !__has_feature(objc_arc)
            if (tmpMap != nil) [tmpMap release]; tmpMap = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_curve:nil];
    [self setM_parameters:nil];
    [self setM_pointMap:nil];
    [super dealloc];
#endif
}

- (NSMutableArray *)decomposeScalar:(BigInteger *)k {
    NSMutableArray *retVal = nil;
    @autoreleasepool {
        int bits = [self.m_parameters bits];
        BigInteger *b1 = [self calculateB:k withG:[self.m_parameters g1] withT:bits];
        BigInteger *b2 = [self calculateB:k withG:[self.m_parameters g2] withT:bits];
        
        NSMutableArray *v1 = [self.m_parameters v1];
        NSMutableArray *v2 = [self.m_parameters v2];
        
        BigInteger *a = [k subtractWithN:([[b1 multiplyWithVal:v1[0]] addWithValue:[b2 multiplyWithVal:v2[0]]])];
        BigInteger *b = [[[b1 multiplyWithVal:(v1[1])] addWithValue:[b2 multiplyWithVal:v2[1]]] negate];
        retVal = [[NSMutableArray alloc] initWithObjects:a, b, nil];
    }
    
    return (retVal ? [retVal autorelease] : nil);
}

- (ECPointMap*)pointMap {
    return self.m_pointMap;
}

- (BOOL)hasEfficientPointMap {
    return YES;
}

- (BigInteger*)calculateB:(BigInteger*)k withG:(BigInteger*)g withT:(int)t {
    BigInteger *bigInt = nil;
    @autoreleasepool {
        BOOL negative = ([g signValue] < 0);
        BigInteger *b = [k multiplyWithVal:[g abs]];
        BOOL extra = [b testBitWithN:(t - 1)];
        b = [b shiftRightWithN:t];
        if (extra) {
            b = [b addWithValue:[BigInteger One]];
        }
        bigInt = (negative ? [b negate] : b);
        [bigInt retain];
    }
    return (bigInt ? [bigInt autorelease] : nil);
}

@end
