//
//  BigInteger.h
//  
//
//  Created by Pallas on 4/30/16.
//
//

#import <Foundation/Foundation.h>

@interface BigInteger : NSObject<NSCopying> {
@private
    NSMutableArray *                _magnitude; // array of ints with [0] being the most significant
    int                             _sign; // -1 means -ve; +1 means +ve; 0 means 0
    int                             _nBits; // cache BitCount() value
    int                             _nBitLength; // cache BitLength() value
    int                             _mQuote; // -m^(-1) mod b, b = 2^32 (see Montgomery mult.), 0 when uninitialised
}

// int[][]
+ (NSArray*)primeLists;

// int[]
+ (NSMutableArray*)primeProducts;

// BigInteger
+ (BigInteger*)Zero;
+ (BigInteger*)One;
+ (BigInteger*)Two;
+ (BigInteger*)Three;
+ (BigInteger*)Four;
+ (BigInteger*)Five;
+ (BigInteger*)Six;
+ (BigInteger*)Seven;
+ (BigInteger*)Eight;
+ (BigInteger*)Ten;

+ (BigInteger*)arbitrary:(int)sizeInBits;
- (id)initWithValue:(NSString*)value;
- (id)initWithValue:(NSString*)value withRadix:(int)radix;
- (id)initWithData:(NSData*)bytes;
- (id)initWithData:(NSData*)bytes withOffset:(int)offset withLength:(int)length;
- (id)initWithSign:(int)sign withBytes:(NSData*)bytes;
- (id)initWithSign:(int)sign withBytes:(NSData*)bytes withOffset:(int)offset withLength:(int)length;
- (id)initWithSizeInBits:(int)sizeInBits;
- (id)initWithBitLength:(int)bitLength withCertainty:(int)certainty;

- (BigInteger*)abs;
- (BigInteger*)addWithValue:(BigInteger*)value;
- (BigInteger*)andWithValue:(BigInteger*)value;
- (BigInteger*)andNotWithVal:(BigInteger*)val;
- (int)bitCount;
+ (int)bitCntWithI:(int)i;
- (int)bitLength;

- (int)compareTo:(id)obj;
- (int)compareToWithValue:(BigInteger*)value;

- (NSMutableArray*)divideWithX:(NSMutableArray*)x withY:(NSMutableArray*)y;
- (BigInteger*)divideWithVal:(BigInteger*)val;
- (NSMutableArray*)divideAndRemainderWithVal:(BigInteger*)val;

- (BigInteger*)gcdWithValue:(BigInteger*)value;
- (BigInteger*)inc;
- (int)intValue;

- (BOOL)isProbablePrimeWithCertainty:(int)certainty;
- (BOOL)isProbablePrimeWithCertainty:(int)certainty withRandomlySelected:(BOOL)randomlySelected;

- (BOOL)rabinMillerTestWithCertainty:(int)certainty;
- (BOOL)rabinMillerTestWithCertainty:(int)certainty withRandomlySelected:(BOOL)randomlySelected;

- (int64_t)longValue;
- (BigInteger*)maxWithValue:(BigInteger*)value;
- (BigInteger*)minWithValue:(BigInteger*)value;
- (BigInteger*)modWithM:(BigInteger*)m;
- (BigInteger*)modInverseWithM:(BigInteger*)m;
- (BigInteger*)modPowWithE:(BigInteger*)e withM:(BigInteger*)m;

- (BigInteger*)multiplyWithVal:(BigInteger*)val;
- (BigInteger*)square;
- (BigInteger*)negate;
- (BigInteger*)nextProbablePrime;
- (BigInteger*)Not;
- (BigInteger*)powWithExp:(int)exp;

+ (BigInteger*)probablePrime:(int)bitLength;
- (BigInteger*)remainderWithN:(BigInteger*)n;
- (BigInteger*)shiftLeftWithN:(int)n;
- (BigInteger*)shiftRightWithN:(int)n;
- (int)signValue;

+ (NSMutableArray*)subtractWithXstart:(int)xStart withX:(NSMutableArray*)x withYstart:(int)yStart withY:(NSMutableArray*)y;
- (BigInteger*)subtractWithN:(BigInteger*)n;

- (NSMutableData*)toByteArray;
- (NSMutableData*)toByteArrayUnsigned;
- (NSString*)toString;
- (NSString*)toStringWithRadix:(int)radix;

+ (BigInteger*)valueOf:(int64_t)value;
- (int)getLowestSetBit;
- (BOOL)testBitWithN:(int)n;
- (BigInteger*)orWithValue:(BigInteger*)value;
- (BigInteger*)xorWithValue:(BigInteger*)value;
- (BigInteger*)setBitWithN:(int)n;
- (BigInteger*)clearBitWithN:(int)n;
- (BigInteger*)flipBitWithN:(int)n;
- (BigInteger*)flipExistingBitWithN:(int)n;

@end
