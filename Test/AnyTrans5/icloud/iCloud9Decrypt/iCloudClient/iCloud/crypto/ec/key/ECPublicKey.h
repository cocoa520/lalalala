//
//  ECPublicKey.h
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECKey.h"

@class BigInteger;
@class ECCurvePoint;

@interface ECPublicKey : ECKey {
@private
    ECCurvePoint *                      _point;
}

+ (ECPublicKey*)create:(BigInteger*)x withY:(BigInteger*)y withCurveName:(NSString*)curveName;
+ (ECPublicKey*)create:(ECCurvePoint*)point;

@end
