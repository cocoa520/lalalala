//
//  Pkcs7Padding.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "Pkcs7Padding.h"
#import "SecureRandom.h"

@implementation Pkcs7Padding

/**
 * Initialise the padder.
 *
 * @param random - a SecureRandom if available.
 */
- (void)init:(SecureRandom *)random {
    // nothing to do.
}

/**
 * Return the name of the algorithm the cipher implements.
 *
 * @return the name of the algorithm the cipher implements.
 */
- (NSString*)paddingName {
    return @"PKCS7";
}

/**
 * add the pad bytes to the passed in block, returning the
 * number of bytes added.
 */
- (int)addPadding:(NSMutableData*)input withInOff:(int)inOff {
    Byte code = (Byte)(((int)input.length) - inOff);
    
    while (inOff < (int)(input.length)) {
        ((Byte*)(input.bytes))[inOff] = code;
        inOff++;
    }
    
    return code;
}

/**
 * return the number of pad bytes present in the block.
 */
- (int)padCount:(NSMutableData*)input {
    Byte countAsByte = ((Byte*)(input.bytes))[(int)(input.length) - 1];
    int count = countAsByte;
    
    if (count < 1 || count > (int)(input.length)) {
        @throw [NSException exceptionWithName:@"InvalidCipherText" reason:@"pad block corrupted" userInfo:nil];
    }
    
    for (int i = 2; i <= count; i++) {
        if (((Byte*)(input.bytes))[(int)(input.length) - i] != countAsByte) {
            @throw [NSException exceptionWithName:@"InvalidCipherText" reason:@"pad block corrupted" userInfo:nil];
        }
    }
    
    return count;
}

@end
