//
//  LongArray.h
//  
//
//  Created by Pallas on 5/10/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BigInteger;

@interface LongArray : NSObject {
@private
    NSMutableArray *                    _m_ints; // long[]
}

+ (NSData*)BitLengths;

- (id)initWithIntLen:(int)intLen;
// ints == long[]
- (id)initWithInts:(NSMutableArray*)ints;
// ints == long[]
- (id)initWithInts:(NSMutableArray*)ints withOff:(int)off withLen:(int)len;
- (id)initWithBigInt:(BigInteger*)bigInt;

- (BOOL)isOne;
- (BOOL)isZero;
- (int)getUsedLength;
- (int)getUsedLengthFrom:(int)from;
- (int)degree;

- (BigInteger*)toBigInteger;
- (LongArray*)addOne;
- (void)addShiftedByWords:(LongArray*)other withWords:(int)words;
- (int)length;
- (BOOL)testBitZero;

// ks == int[]
- (LongArray*)modMultiplyLD:(LongArray*)other withM:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)modMultiply:(LongArray*)other withM:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)modMultiplyAlt:(LongArray*)other withM:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)modReduce:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)multiply:(LongArray*)other withM:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (void)reduce:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)modSquare:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)modSquareN:(int)n withM:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)square:(int)m withKs:(NSMutableArray*)ks;
// ks == int[]
- (LongArray*)modInverse:(int)m withKs:(NSMutableArray*)ks;

- (BOOL)equalsWithOther:(LongArray*)other;
- (LongArray*)copy;
- (NSString*)toString;

@end
