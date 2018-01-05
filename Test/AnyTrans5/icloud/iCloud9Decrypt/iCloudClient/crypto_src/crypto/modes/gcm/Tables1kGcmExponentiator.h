//
//  Tables1kGcmExponentiator.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "GcmExponentiator.h"

@interface Tables1kGcmExponentiator : GcmExponentiator {
@private
    NSMutableArray *                    _lookupPowX2;
}

- (void)init:(NSMutableData*)x;
- (void)exponentiateX:(int64_t)pow withOutput:(NSMutableData*)output;

@end
