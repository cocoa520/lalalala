//
//  BigIntegers.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "BigIntegers.h"
#import "CategoryExtend.h"
#import "BigInteger.h"

int const MaxIterations = 1000;

@implementation BigIntegers

/**
 * Return the passed in value as an unsigned byte array.
 *
 * @param value value to be converted.
 * @return a byte array without a leading zero byte if present in the signed encoding.
 */
+ (NSMutableData*)asUnsignedByteArray:(BigInteger*)n {
    return [n toByteArrayUnsigned];
}

/**
 * Return the passed in value as an unsigned byte array of specified length, zero-extended as necessary.
 *
 * @param length desired length of result array.
 * @param n value to be converted.
 * @return a byte array of specified length, with leading zeroes as necessary given the size of n.
 */
+ (NSMutableData*)asUnsignedByteArray:(int)length withN:(BigInteger*)n {
    NSMutableData *bytes = [n toByteArrayUnsigned];
    
    if (bytes.length > length) {
        @throw [NSException exceptionWithName:@"Argument" reason:@"standard length exceeded" userInfo:nil];
    }
    
    if (bytes.length == length)
        return bytes;
    
    NSMutableData *tmp = [[[NSMutableData alloc] initWithSize:length] autorelease];
    [tmp copyFromIndex:((int)(tmp.length) - (int)(bytes.length)) withSource:bytes withSourceIndex:0 withLength:(int)(bytes.length)];
    return tmp;
}

/**
 * Return a random BigInteger not less than 'min' and not greater than 'max'
 *
 * @param min the least value that may be generated
 * @param max the greatest value that may be generated
 * @param random the source of randomness
 * @return a random BigInteger value in the range [min,max]
 */
+ (BigInteger*)createRandomInRange:(BigInteger*)min withMax:(BigInteger*)max {
    int cmp = [min compareToWithValue:max];
    if (cmp >= 0) {
        if (cmp > 0) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"'min' may not be greater than 'max'" userInfo:nil];
        }
        return min;
    }
    
    if ([min bitLength] > [max bitLength] / 2) {
        return [[BigIntegers createRandomInRange:[BigInteger Zero] withMax:[max subtractWithN:min]] addWithValue:min];
    }
    
    for (int i = 0; i < MaxIterations; ++i) {
        BigInteger *x = [[[BigInteger alloc] initWithSizeInBits:[max bitLength]] autorelease];
        if ([x compareToWithValue:min] >= 0 && [x compareToWithValue:max] <= 0) {
            return x;
        }
    }
    
    // fall back to a faster (restricted) method
    BigInteger *bigInt = [[BigInteger alloc] initWithSizeInBits:([[max subtractWithN:min] bitLength] - 1)];
    BigInteger *retVal = [bigInt addWithValue:min];
#if !__has_feature(objc_arc)
    if (bigInt) [bigInt release]; bigInt = nil;
#endif
    return retVal;
}

+ (BigInteger*)fromData:(NSMutableData*)data {
    return [[[BigInteger alloc] initWithSign:1 withBytes:data] autorelease];
}

+ (BigInteger*)fromData:(NSMutableData*)data withOff:(int)off withLength:(int)length {
    BigInteger *retVal = nil;
    @autoreleasepool {
        if (off != 0 || length != (int)(data.length)) {
            NSMutableData *mag = [[NSMutableData alloc] initWithSize:length];
            [mag copyFromIndex:0 withSource:data withSourceIndex:off withLength:length];
            retVal = [[BigInteger alloc] initWithSign:1 withBytes:mag];
#if !__has_feature(objc_arc)
            if (mag != nil) [mag release]; mag =nil;
#endif
        } else {
            retVal = [[BigInteger alloc] initWithSign:1 withBytes:data];
        }
    }
    return (retVal ? [retVal autorelease] : nil);
}

@end
