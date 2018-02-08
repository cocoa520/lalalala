//
//  ECAssistant.h
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;
@class ECCurve;
@class X9ECParameters;

@interface ECAssistant : NSObject

+ (NSString*)fieldLengthToCurveName:(NSArray*)curveName withDataLength:(int)dataLength;
+ (int)fieldLengthWithCurveName:(NSString *)curveName;
+ (int)fieldLengthWithX9ECParameters:(X9ECParameters*)x9ECParameters;
+ (int)fieldLengthWithECCurve:(ECCurve*)curve;
+ (int)fieldLengthWithInt:(int)fieldBitLength;
+ (NSMutableData*)encodedField:(int)length withBigInteger:(BigInteger*)i;
+ (X9ECParameters*)x9ECParameters:(NSString*)curveName;

@end
