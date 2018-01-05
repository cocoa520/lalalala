//
//  GcmExponentiator.h
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface GcmExponentiator : NSObject

- (void)init:(NSMutableData*)x;
- (void)exponentiateX:(int64_t)pow withOutput:(NSMutableData*)output;

@end
