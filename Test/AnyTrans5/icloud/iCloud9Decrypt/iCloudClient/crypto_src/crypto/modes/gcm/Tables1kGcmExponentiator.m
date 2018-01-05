//
//  Tables1kGcmExponentiator.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "Tables1kGcmExponentiator.h"
#import "GcmUtilities.h"
#import "Arrays.h"

#import "CategoryExtend.h"

@interface Tables1kGcmExponentiator ()

// A lookup table of the power-of-two powers of 'x'
// - lookupPowX2[i] = x^(2^i)
@property (nonatomic, readwrite, retain) NSMutableArray *lookupPowX2;

@end

@implementation Tables1kGcmExponentiator
@synthesize lookupPowX2 = _lookupPowX2;

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setLookupPowX2:nil];
    [super dealloc];
#endif
}

- (void)init:(NSMutableData*)x {
    @autoreleasepool {
        NSMutableArray *y = [GcmUtilities asUints:x];
        if ([self lookupPowX2] != nil && [Arrays areEqualWithUintArray:y withB:(NSMutableArray*)([self lookupPowX2][0])]) {
            return;
        }
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:8];
        [self setLookupPowX2:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
        [[self lookupPowX2] addObject:y];
    }
}

- (void)exponentiateX:(int64_t)pow withOutput:(NSMutableData*)output {
    @autoreleasepool {
        NSMutableArray *y = [GcmUtilities oneAsUints];
        int bit = 0;
        while (pow > 0) {
            if ((pow & 1L) != 0) {
                [self ensureAvailable:bit];
                [GcmUtilities multiplyWithUints:y withY:(NSMutableArray*)([self lookupPowX2][bit])];
            }
            ++bit;
            pow >>= 1;
        }
        
        [GcmUtilities asBytesWithUintArray:y withZ:output];
    }
}

- (void)ensureAvailable:(int)bit {
    @autoreleasepool {
        int count = (int)([self lookupPowX2].count);
        if (count <= bit) {
            NSMutableArray *array = (NSMutableArray*)([self lookupPowX2][count - 1]);
            do {
                int arrayCount = (int)(array.count);
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithSize:arrayCount];
                [tmp copyFromIndex:0 withSource:array withSourceIndex:0 withLength:arrayCount];
                [GcmUtilities multiplyWithUints:tmp withY:tmp];
                [[self lookupPowX2] addObject:tmp];
#if !__has_feature(objc_arc)
                if (tmp != nil) [tmp release]; tmp = nil;
#endif
            } while (++count <= bit);
        }        
    }
}

@end
