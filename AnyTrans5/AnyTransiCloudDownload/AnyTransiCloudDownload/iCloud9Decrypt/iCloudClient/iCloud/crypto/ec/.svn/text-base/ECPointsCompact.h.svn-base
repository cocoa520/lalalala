//
//  ECPointsCompact.h
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class ECCurve;
@class ECPoint;

@interface ECPointsCompact : NSObject

+ (BigInteger*)y:(ECCurve*)curve withX:(BigInteger*)x;
+ (ECPoint*)decodeFPPoint:(ECCurve*)curve withData:(NSMutableData*)data __deprecated;
+ (ECPoint*)decompressFPPoint:(ECCurve*)curve withX:(BigInteger*)x __deprecated;
+ (BOOL)satisfiesCofactor:(ECCurve*)curve withPoint:(ECPoint*)point __deprecated;

@end
