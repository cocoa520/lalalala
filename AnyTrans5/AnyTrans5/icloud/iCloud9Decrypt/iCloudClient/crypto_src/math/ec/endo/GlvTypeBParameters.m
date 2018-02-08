//
//  GlvTypeBParameters.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "GlvTypeBParameters.h"
#import "BigInteger.h"

@interface GlvTypeBParameters ()

@property (nonatomic, readwrite, retain) BigInteger *m_beta;
@property (nonatomic, readwrite, retain) BigInteger *m_lambda;
@property (nonatomic, readwrite, retain) NSMutableArray *m_v1;
@property (nonatomic, readwrite, retain) NSMutableArray *m_v2;
@property (nonatomic, readwrite, retain) BigInteger *m_g1;
@property (nonatomic, readwrite, retain) BigInteger *m_g2;
@property (nonatomic, readwrite, assign) int m_bits;

@end

@implementation GlvTypeBParameters
@synthesize m_beta = _m_beta;
@synthesize m_lambda = _m_lambda;
@synthesize m_v1 = _m_v1;
@synthesize m_v2 = _m_v2;
@synthesize m_g1 = _m_g1;
@synthesize m_g2 = _m_g2;
@synthesize m_bits = _m_bits;

- (id)initWithBeta:(BigInteger*)beta withLambda:(BigInteger*)lambda withV1:(NSMutableArray*)v1 withV2:(NSMutableArray*)v2 withG1:(BigInteger*)g1 withG2:(BigInteger*)g2 withBits:(int)bits {
    if (self = [super init]) {
        [self setM_beta:beta];
        [self setM_lambda:lambda];
        [self setM_v1:v1];
        [self setM_v2:v2];
        [self setM_g1:g1];
        [self setM_g2:g2];
        [self setM_bits:bits];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setM_beta:nil];
    [self setM_lambda:nil];
    [self setM_v1:nil];
    [self setM_v2:nil];
    [self setM_g1:nil];
    [self setM_g2:nil];
    [super dealloc];
#endif
}

- (BigInteger*)beta {
    return self.m_beta;
}

- (BigInteger*)lambda {
    return self.m_lambda;
}

- (NSMutableArray*)v1 {
    return self.m_v1;
}

- (NSMutableArray*)v2 {
    return self.m_v2;
}

- (BigInteger*)g1 {
    return self.m_g1;
}

- (BigInteger*)g2 {
    return self.m_g2;
}

- (int)bits {
    return self.m_bits;
}

@end
