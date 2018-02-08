//
//  ScaleYPointMap.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "ScaleYPointMap.h"
#import "ECFieldElement.h"
#import "ECPoint.h"

@interface ScaleYPointMap ()

@property (nonatomic, readwrite, retain) ECFieldElement *scale;

@end

@implementation ScaleYPointMap
@synthesize scale = _scale;

- (id)initWithScale:(ECFieldElement*)scale {
    if (self = [super init]) {
        [self setScale:scale];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setScale:nil];
    [super dealloc];
#endif
}

- (ECPoint*)map:(ECPoint*)p {
    return [p scaleY:self.scale];
}

@end
