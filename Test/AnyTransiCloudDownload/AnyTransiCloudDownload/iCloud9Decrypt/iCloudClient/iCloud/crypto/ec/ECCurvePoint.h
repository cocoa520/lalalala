//
//  ECCurvePoint.h
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class ECPoint;
@class X9ECParameters;

@interface ECCurvePoint : NSObject {
@private
    NSObject *                      _lock;
    ECPoint *                       _q;
    NSString *                      _curveName;
    X9ECParameters *                _x9ECParameters;
}

- (NSString*)curveName;

+ (ECCurvePoint*)create:(BigInteger*)x withY:(BigInteger*)y withCurveName:(NSString*)curveName;
+ (ECCurvePoint*)create:(BigInteger*)d withCurveName:(NSString*)curveName;

- (NSMutableData*)agreement:(BigInteger*)d;
- (ECPoint*)copyQ;
- (BigInteger*)x;
- (BigInteger*)y;
- (NSMutableData*)xEncoded;
- (NSMutableData*)yEncoded;
- (X9ECParameters*)getX9ECParameters;
- (int)fieldBitLength;
- (int)fieldLength;

@end
