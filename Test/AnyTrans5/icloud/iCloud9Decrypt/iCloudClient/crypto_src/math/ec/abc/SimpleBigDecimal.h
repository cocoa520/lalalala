//
//  SimpleBigDecimal.h
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface SimpleBigDecimal : NSObject {
@private
    BigInteger *                    _bigInt;
    int                             _scale;
}

+ (SimpleBigDecimal*)getInstance:(BigInteger*)val withScale:(int)scale;
- (id)initWithBigInt:(BigInteger*)bigInt withScale:(int)scale;

- (SimpleBigDecimal*)adjustScale:(int)newScale;
- (SimpleBigDecimal*)addWithSimpleBigDecimal:(SimpleBigDecimal*)b;
- (SimpleBigDecimal*)addWithBigInteger:(BigInteger*)b;
- (SimpleBigDecimal*)negate;
- (SimpleBigDecimal*)subtractWithSimpleBigDecimal:(SimpleBigDecimal*)b;
- (SimpleBigDecimal*)subtractWithBigInteger:(BigInteger*)b;
- (SimpleBigDecimal*)multiplyWithSimpleBigDecimal:(SimpleBigDecimal*)b;
- (SimpleBigDecimal*)multiplyWithBigInteger:(BigInteger*)b;
- (SimpleBigDecimal*)divideWithSimpleBigDecimal:(SimpleBigDecimal*)b;
- (SimpleBigDecimal*)divideWithBigInteger:(BigInteger*)b;
- (SimpleBigDecimal*)shiftLeft:(int)n;
- (int)compareToWithSimpleBigDecimal:(SimpleBigDecimal*)val;
- (int)compareToWithBigInteger:(BigInteger*)val;
- (BigInteger*)floor;
- (BigInteger*)round;
- (int)intValue;
- (int64_t)longValue;
- (int)scale;
- (NSString*)toString;

@end
