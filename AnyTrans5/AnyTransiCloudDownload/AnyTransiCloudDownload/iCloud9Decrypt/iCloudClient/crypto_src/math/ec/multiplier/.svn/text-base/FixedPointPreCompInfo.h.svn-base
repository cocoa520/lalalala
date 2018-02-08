//
//  FixedPointPreCompInfo.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "PreCompInfo.h"

@interface FixedPointPreCompInfo : PreCompInfo {
@protected
    // _m_preComp == ECPoint[]
    NSMutableArray *    _m_preComp; // Array holding the precomputed <code>ECPoint</code>s used for a fixed point multiplication.
    int                 _m_width; //The width used for the precomputation. If a larger width precomputation is already available this may be larger than was requested, so calling code should refer to the actual width.
}

- (NSMutableArray*)preComp;
- (void)setPreComp:(NSMutableArray*)preComp;

- (int)width;
- (void)setWidth:(int)width;

@end
