//
//  BasicGcmExponentiator.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "BasicGcmExponentiator.h"
#import "GcmUtilities.h"
#import "Arrays.h"

@interface BasicGcmExponentiator ()

@property (nonatomic, readwrite, retain) NSMutableArray *x;

@end

@implementation BasicGcmExponentiator
@synthesize x = _x;

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setX:nil];
    [super dealloc];
#endif
}

- (void)init:(NSMutableData*)x {
    @autoreleasepool {
        [self setX:[GcmUtilities asUints:x]];
    }
}

- (void)exponentiateX:(int64_t)pow withOutput:(NSMutableData*)output {
    @autoreleasepool {
        // Initial value is little-endian 1
        NSMutableArray *y = [GcmUtilities oneAsUints];
        
        if (pow > 0) {
            NSMutableArray *powX = [Arrays cloneWithUIntArray:[self x]];
            do {
                if ((pow & 1L) != 0) {
                    [GcmUtilities multiplyWithUints:y withY:powX];
                }
                [GcmUtilities multiplyWithUints:powX withY:powX];
                pow >>= 1;
            } while (pow > 0);
        }
        
        [GcmUtilities asBytesWithUintArray:y withZ:output];
    }
}

@end
