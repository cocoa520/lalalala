//
//  GlvTypeBParameters.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface GlvTypeBParameters : NSObject {
@protected
    BigInteger *                                _m_beta;
    BigInteger *                                _m_lambda;
    NSMutableArray *                            _m_v1;                  // BigInteger[]
    NSMutableArray *                            _m_v2;                  // BigInteger[]
    BigInteger *                                _m_g1;
    BigInteger *                                _m_g2;
    int                                         _m_bits;
}

- (id)initWithBeta:(BigInteger*)beta withLambda:(BigInteger*)lambda withV1:(NSMutableArray*)v1 withV2:(NSMutableArray*)v2 withG1:(BigInteger*)g1 withG2:(BigInteger*)g2 withBits:(int)bits;

- (BigInteger*)beta;
- (BigInteger*)lambda;
- (NSMutableArray*)v1;
- (NSMutableArray*)v2;
- (BigInteger*)g1;
- (BigInteger*)g2;
- (int)bits;

@end
