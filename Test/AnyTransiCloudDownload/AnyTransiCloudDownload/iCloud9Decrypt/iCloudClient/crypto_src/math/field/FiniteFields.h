//
//  FiniteFields.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class IFiniteField;
@class IPolynomialExtensionField;
@class BigInteger;

@interface FiniteFields : NSObject

+ (IFiniteField*)GF_2;
+ (IFiniteField*)GF_3;

// exponents == int[]
+ (IPolynomialExtensionField*)getBinaryExtensionField:(NSMutableArray*)exponents;
+ (IFiniteField*)getPrimeField:(BigInteger*)characteristic;

@end
