//
//  BigIntegers.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface BigIntegers : NSObject

+ (NSMutableData*)asUnsignedByteArray:(BigInteger*)n;
+ (NSMutableData*)asUnsignedByteArray:(int)length withN:(BigInteger*)n;
+ (BigInteger*)createRandomInRange:(BigInteger*)min withMax:(BigInteger*)max;
+ (BigInteger*)fromData:(NSMutableData*)data;
+ (BigInteger*)fromData:(NSMutableData*)data withOff:(int)off withLength:(int)length;

@end
