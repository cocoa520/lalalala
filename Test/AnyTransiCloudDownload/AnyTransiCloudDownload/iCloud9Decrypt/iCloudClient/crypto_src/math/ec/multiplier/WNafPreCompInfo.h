//
//  WNafPreCompInfo.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "PreCompInfo.h"

@class ECPoint;

@interface WNafPreCompInfo : PreCompInfo {
@protected
    // Array holding the precomputed <code>ECPoint</code>s used for a Window NAF multiplication.
    NSMutableArray *                    _m_preComp; // ECPoint[]
    // Array holding the negations of the precomputed <code>ECPoint</code>s used for a Window NAF multiplication.
    NSMutableArray *                    _m_preCompNeg; // ECPoint[]
    // Holds an <code>ECPoint</code> representing Twice(this). Used for the Window NAF multiplication to create or extend the precomputed values.
    ECPoint *                           _m_twice;
}

- (NSMutableArray*)preComp;
- (void)setPreComp:(NSMutableArray*)preComp;

- (NSMutableArray*)preCompNeg;
- (void)setPreCompNeg:(NSMutableArray*)preCompNeg;

- (ECPoint*)twice;
- (void)setTwice:(ECPoint*)twice;

@end
