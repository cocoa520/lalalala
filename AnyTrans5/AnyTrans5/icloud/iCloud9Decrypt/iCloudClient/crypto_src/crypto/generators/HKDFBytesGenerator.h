//
//  HKDFBytesGenerator.h
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class HMac;
@class Digest;
@class HKDFParameters;

@interface HKDFBytesGenerator : NSObject {
@private
    HMac *                                  _hMacHash;
    int                                     _hashLen;
    NSMutableData *                         _info;
    NSMutableData *                         _currentT;
    int                                     _generatedBytes;
}

/**
 * Creates a HKDFBytesGenerator based on the given hash function.
 *
 * @param hash the digest to be used as the source of generatedBytes bytes
 */
- (id)initWithDigest:(Digest*)hash;

- (void)init:(HKDFParameters*)param;
- (Digest*)getDigest;
- (int)generateBytes:(NSMutableData*)outBuf withOutOff:(int)outOff withLen:(int)len;

@end
