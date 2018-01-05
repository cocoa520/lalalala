//
//  ECEndomorphism.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "ECEndomorphism.h"
#import "ECPointMap.h"

@implementation ECEndomorphism
@synthesize pointMap = _pointMap;
@synthesize hasEfficientPointMap = _hasEfficientPointMap;

- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setPointMap:nil];
    [super dealloc];
#endif
}

@end
