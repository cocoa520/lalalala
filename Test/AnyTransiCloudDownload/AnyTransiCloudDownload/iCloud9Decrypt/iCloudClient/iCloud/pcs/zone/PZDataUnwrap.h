//
//  PZDataUnwrap.h
//
//
//  Created by Pallas on 8/1/16.
//
//
//  Complete

#import <Foundation/Foundation.h>
#import "RFC6637.h"

@interface PZDataUnwrap : NSObject {
@private
    RFC6637 *_rfc6637;
    NSMutableData *_fingerprint;
}

+ (PZDataUnwrap*)instance;

- (id)initWithRfc6637:(RFC6637*)rfc6637 withFingerprint:(NSMutableData*)fingerprint;

- (NSMutableData*)apply:(NSMutableData*)wrappedData withD:(BigInteger*)d;

@end