//
//  GlvTypeBEndomorphism.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "GlvEndomorphism.h"

@class ECCurve;
@class GlvTypeBParameters;
@class BigInteger;

@interface GlvTypeBEndomorphism : GlvEndomorphism {
@protected
    ECCurve *                                   _m_curve;
    GlvTypeBParameters *                        _m_parameters;
    ECPointMap *                                _m_pointMap;
}

- (id)initWithCurve:(ECCurve*)curve withParameters:(GlvTypeBParameters*)parameters;

@end
