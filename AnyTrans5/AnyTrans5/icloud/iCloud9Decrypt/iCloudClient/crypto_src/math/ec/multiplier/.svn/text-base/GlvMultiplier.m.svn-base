//
//  GlvMultiplier.m
//  
//
//  Created by Pallas on 5/13/16.
//
//  Complete

#import "GlvMultiplier.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "BigInteger.h"
#import "GlvEndomorphism.h"
#import "ECAlgorithms.h"
#import "ECPointMap.h"

@interface GlvMultiplier ()

@property (nonatomic, readwrite, retain) ECCurve *curve;
@property (nonatomic, readwrite, retain) GlvEndomorphism *glvEndomorphism;

@end

@implementation GlvMultiplier
@synthesize curve = _curve;
@synthesize glvEndomorphism = _glvEndomorphism;

- (id)initWithCurve:(ECCurve*)curve withGlvEndomorphism:(GlvEndomorphism*)glvEndomorphism {
    if (self = [super init]) {
        if (curve == nil || [curve order] == nil) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"curve need curve with known group order" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        
        [self setCurve:curve];
        [self setGlvEndomorphism:glvEndomorphism];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCurve:nil];
    [self setGlvEndomorphism:nil];
    [super dealloc];
#endif
}

- (ECPoint*)multiplyPositive:(ECPoint*)p withK:(BigInteger*)k {
    ECPoint *retPoint = nil;
    @autoreleasepool {
        if (![[self curve] equalsWithOther:[p curve]]) {
            @throw [NSException exceptionWithName:@"InvalidOperation" reason:nil userInfo:nil];
        }
        
        BigInteger *n = [[p curve] order];
        NSMutableArray *ab = [[self glvEndomorphism] decomposeScalar:[k modWithM:n]];
        BigInteger *a = ab[0], *b = ab[1];
        
        ECPointMap *pointMap = [[self glvEndomorphism] pointMap];
        if ([[self glvEndomorphism] hasEfficientPointMap]) {
            retPoint = [ECAlgorithms implShamirsTrickWNaf:p withK:a withPointMapQ:pointMap withL:b];
        } else {
            retPoint = [ECAlgorithms implShamirsTrickWNaf:p withK:a withQ:[pointMap map:p] withL:b];
        }
        [retPoint retain];
    }
    return (retPoint ? [retPoint autorelease] : nil);
}

@end
