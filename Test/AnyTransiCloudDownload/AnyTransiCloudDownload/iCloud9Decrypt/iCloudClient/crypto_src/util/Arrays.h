//
//  Arrays.h
//  
//
//  Created by Pallas on 5/11/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Arrays : NSObject

// a == b == bool[]
+ (BOOL)areEqualWithBOOLArray:(NSMutableArray*)a withB:(NSMutableArray*)b;
// a == b == ushort[]
+ (BOOL)areEqualWithUShortArray:(NSMutableArray*)a withB:(NSMutableArray*)b;
/// <summary>
/// Are two arrays equal.
/// </summary>
/// <param name="a">Left side.</param>
/// <param name="b">Right side.</param>
/// <returns>True if equal.</returns>
+ (BOOL)areEqualWithByteArray:(NSData*)a withB:(NSData*)b;
+ (BOOL)areSameWithByteArray:(NSData*)a withB:(NSData*)b __deprecated;
/// <summary>
/// A constant time equals comparison - does not terminate early if
/// test will fail.
/// </summary>
/// <param name="a">first array</param>
/// <param name="b">second array</param>
/// <returns>true if arrays equal, false otherwise.</returns>
+ (BOOL)constantTimeAreEqualWithByteArray:(NSMutableData*)a withB:(NSMutableData*)b;
// a == b == int[]
+ (BOOL)areEqualWithIntArray:(NSMutableArray*)a withB:(NSMutableArray*)b;
// a == b == uint[]
+ (BOOL)areEqualWithUintArray:(NSMutableArray*)a withB:(NSMutableArray*)b;

+ (NSString*)toString:(NSMutableArray*)a;
+ (int)getHashCodeWithByteArray:(NSData*)data;
+ (int)getHashCodeWithByteArray:(NSData*)data withOff:(int)off withLen:(int)len;
// data == int[]
+ (int)getHashCodeWithIntArray:(NSMutableArray*)data;
// data == int[]
+ (int)getHashCodeWithIntArray:(NSMutableArray*)data withOff:(int)off withLen:(int)len;
// data == uint[]
+ (BOOL)getHashCodeWithUIntArray:(NSMutableArray*)data;
// data == uint[]
+ (BOOL)getHashCodeWithUIntArray:(NSMutableArray*)data withOff:(int)off withLen:(int)len;
// data == uint64_t[]
+ (int)getHashCodeWithUInt64Array:(NSMutableArray*)data;
// data == uint64_t[]
+ (int)getHashCodeWithUInt64Array:(NSMutableArray*)data withOff:(int)off withLen:(int)len;
+ (NSMutableData*)cloneWithByteArray:(NSMutableData*)data;
+ (NSMutableData*)cloneWithByteArray:(NSMutableData*)data withExisting:(NSMutableData*)existing;
// data == int[]
+ (NSMutableArray*)cloneWithIntArray:(NSMutableArray*)data;
// data == uint[]
+ (NSMutableArray*)cloneWithUIntArray:(NSMutableArray*)data;
// data == long[]
+ (NSMutableArray*)cloneWithLongArray:(NSMutableArray*)data;
// NSMutableArray == uint64_t[]
+ (NSMutableArray*)cloneWithUInt64Array:(NSMutableArray*)data;
// NSMutableArray == uint64_t[]
+ (NSMutableArray*)cloneWithUInt64Array:(NSMutableArray*)data withExisting:(NSMutableArray*)existing;
+ (BOOL)containsWithByteArray:(NSMutableData*)a withN:(Byte)n;
// NSMutableArray == short[]
+ (BOOL)containsWithShortArray:(NSMutableArray*)a withN:(short)n;
// NSMutableArray == int[]
+ (BOOL)containsWithIntArray:(NSMutableArray*)a withN:(int)n;
+ (void)fillWithByteArray:(NSMutableData*)buf withB:(Byte)b;
+ (NSMutableData*)copyOfWithData:(NSMutableData*)data withNewLength:(int)newLength;
// NSMutableArray == ushort[]
+ (NSMutableArray*)copyOfWithUShortArray:(NSMutableArray*)data withNewLength:(int)newLength;
// NSMutableArray == int[]
+ (NSMutableArray*)copyOfWithIntArray:(NSMutableArray*)data withNewLength:(int)newLength;
// NSMutableArray == long[]
+ (NSMutableArray*)copyOfLongArray:(NSMutableArray*)data withNewLength:(int)newLength;
// NSMutableArray == BigInteger[]
+ (NSMutableArray*)copyOfBigIntegerArray:(NSMutableArray*)data withNewLength:(int)newLength;
/**
 * Make a copy of a range of bytes from the passed in data array. The range can
 * extend beyond the end of the input array, in which case the return array will
 * be padded with zeroes.
 *
 * @param data the array from which the data is to be copied.
 * @param from the start index at which the copying should take place.
 * @param to the final index of the range (exclusive).
 *
 * @return a new byte array containing the range given.
 */
+ (NSMutableData*)copyOfRangeWithByteArray:(NSMutableData*)data withFrom:(int)from withTo:(int)to;
// NSMutableArray == int[]
+ (NSMutableArray*)copyOfRangeWithIntArray:(NSMutableArray*)data withFrom:(int)from withTo:(int)to;
// NSMutableArray == long[]
+ (NSMutableArray*)copyOfRangeWithLongArray:(NSMutableArray*)data withFrom:(int)from withTo:(int)to;
// NSMutableArray == BigInteger[]
+ (NSMutableArray*)copyOfRangeWithBigIntegerArray:(NSMutableArray*)data withFrom:(int)from withTo:(int)to;

+ (NSMutableData*)appendWithByteArray:(NSMutableData*)a withB:(Byte)b;
// NSMutableArray == short[]
+ (NSMutableArray*)appendWithShortArray:(NSMutableArray*)a withB:(short)b;
// NSMutableArray == int[]
+ (NSMutableArray*)appendWithIntArray:(NSMutableArray*)a withB:(int)b;

+ (NSMutableData*)concatenateWithByteArray:(NSMutableData*)a withB:(NSMutableData*)b;
// NSMutableArray == byte[][]
+ (NSMutableData*)concatenateAllWithByte2Array:(NSMutableArray*)vs;
// NSMutableArray == int[]
+ (NSMutableArray*)concatenateWithIntArray:(NSMutableArray*)a withB:(NSMutableArray*)b;

+ (NSMutableData*)prependWithByteArray:(NSMutableData*)a withB:(Byte)b;
// NSMutableArray == short
+ (NSMutableArray*)prependWithShortArray:(NSMutableArray*)a withB:(short)b;
// NSMutableArray == int[]
+ (NSMutableArray*)prependWithIntArray:(NSMutableArray*)a withB:(int)b;

+ (NSMutableData*)reverse:(NSMutableData*)a;
// NSMutableArray == int[]
+ (NSMutableArray*)reverseWithIntArray:(NSMutableArray*)a;

@end
