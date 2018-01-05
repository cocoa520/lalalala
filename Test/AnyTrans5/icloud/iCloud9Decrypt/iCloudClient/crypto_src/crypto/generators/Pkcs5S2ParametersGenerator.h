//
//  Pkcs5S2ParametersGenerator.h
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "PbeParametersGenerator.h"

@class Mac;
@class Digest;

@interface Pkcs5S2ParametersGenerator : PbeParametersGenerator {
@private
    Mac *                       _hMac;
    NSMutableData *             _state;
}

- (id)initWithDigest:(Digest*)digest;

@end