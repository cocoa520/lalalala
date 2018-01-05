//
//  BasicGcmMultiplier.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "BasicGcmMultiplier.h"
#import "GcmUtilities.h"

@interface BasicGcmMultiplier ()

@property (nonatomic, readwrite, retain) NSMutableArray *h;

@end

@implementation BasicGcmMultiplier
@synthesize h = _h;

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setH:nil];
    [super dealloc];
#endif
}

- (void)init:(NSMutableData*)h {
    @autoreleasepool {
        [self setH:[GcmUtilities asUints:h]];
    }
}

- (void)multiplyH:(NSMutableData*)x {
    @autoreleasepool {
        NSMutableArray *t = [GcmUtilities asUints:x];
        [GcmUtilities multiplyWithUints:t withY:[self h]];
        [GcmUtilities asBytesWithUintArray:t withZ:x];
    }
}

@end
