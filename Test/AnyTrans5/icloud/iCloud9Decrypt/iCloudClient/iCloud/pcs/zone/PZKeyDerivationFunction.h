//
//  PZKeyDerivationFunction.h
//
//
//  Created by JGehry on 8/2/16.
//
//
//  Complete

#import <Foundation/Foundation.h>
#import "Digest.h"

@interface PZKeyDerivationFunction : NSObject {
@private
    Digest *                                        _digest;
    NSMutableData *                                 _label;
    int                                             _keyLength;
}

+ (PZKeyDerivationFunction*)instance;

- (id)initWithDigest:(Digest*)digest withLabel:(NSMutableData*)label withKeyLength:(int)keyLength;

- (NSMutableData *)apply:(NSMutableData*)keyDerivationKey;

@end
