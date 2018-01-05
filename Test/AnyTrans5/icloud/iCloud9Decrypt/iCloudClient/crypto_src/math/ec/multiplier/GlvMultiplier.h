//
//  GlvMultiplier.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "AbstractECMultiplier.h"

@class ECCurve;
@class GlvEndomorphism;
@class ECPoint;
@class BigInteger;

@interface GlvMultiplier : AbstractECMultiplier {
@protected
    ECCurve *                       _curve;
    GlvEndomorphism *               _glvEndomorphism;
}

- (ECCurve*)curve;
- (GlvEndomorphism*)glvEndomorphism;

- (id)initWithCurve:(ECCurve*)curve withGlvEndomorphism:(GlvEndomorphism*)glvEndomorphism;

@end
