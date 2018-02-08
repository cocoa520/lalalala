//
//  ECCurvePoint.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "ECCurvePoint.h"
#import "BigInteger.h"
#import "ECCurve.h"
#import "ECPoint.h"
#import "ECAssistant.h"
#import "ECFieldElement.h"
#import "FixedPointCombMultiplier.h"
#import "X9ECParameters.h"

@interface ECCurvePoint ()

@property (nonatomic, readwrite, retain) NSObject *lock;
@property (nonatomic, readwrite, retain) ECPoint *q;
@property (nonatomic, readwrite, retain) NSString *curveName;
@property (nonatomic, readwrite, retain) X9ECParameters *x9ECParameters;

@end

@implementation ECCurvePoint
@synthesize lock = _lock;
@synthesize q = _q;
@synthesize curveName = _curveName;
@synthesize x9ECParameters = _x9ECParameters;

+ (ECCurvePoint*)create:(BigInteger*)x withY:(BigInteger*)y withCurveName:(NSString*)curveName {
    X9ECParameters *x9ECParameters = [ECAssistant x9ECParameters:curveName];
    ECPoint *Q = [[x9ECParameters curve] createPoint:x withY:y];
    
    if (![Q isValid]) {
        return nil;
    }
    
    ECCurvePoint *point = [[[ECCurvePoint alloc] initWithQ:Q withCurveName:curveName withX9ECParameters:x9ECParameters] autorelease];
    return point;
}

+ (ECCurvePoint*)create:(BigInteger*)d withCurveName:(NSString*)curveName {
    X9ECParameters *x9ECParameters = [ECAssistant x9ECParameters:curveName];
    FixedPointCombMultiplier *fixedPCM = [[FixedPointCombMultiplier alloc] init];
    ECPoint *Q = [[fixedPCM multiply:[x9ECParameters getG] withK:d] normalize];
    
    ECCurvePoint *point = [[[ECCurvePoint alloc] initWithQ:Q withCurveName:curveName withX9ECParameters:x9ECParameters] autorelease];
#if !__has_feature(objc_arc)
    if (fixedPCM != nil) [fixedPCM release]; fixedPCM = nil;
#endif
    return point;
}

- (id)initWithLock:(NSObject*)lock withQ:(ECPoint*)q withCurveName:(NSString*)curveName withX9ECParameters:(X9ECParameters*)x9ECParameters {
    if (self = [super init]) {
        [self setLock:lock];
        [self setQ:q];
        [self setCurveName:curveName];
        [self setX9ECParameters:x9ECParameters];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithQ:(ECPoint*)q withCurveName:(NSString*)curveName withX9ECParameters:(X9ECParameters*)x9ECParameters {
    NSObject *obj = [[NSObject alloc] init];
    if (obj) {
        if (self = [self initWithLock:obj withQ:q withCurveName:curveName withX9ECParameters:x9ECParameters]) {
#if !__has_feature(objc_arc)
            if (obj != nil) [obj release]; obj = nil;
#endif
            return self;
        } else {
#if !__has_feature(objc_arc)
            if (obj != nil) [obj release]; obj = nil;
#endif
            return nil;
        }
    } else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData*)agreement:(BigInteger*)d {
    // TODO thread safety of ECPoint unclear.
    @synchronized([self lock]) {
        ECPoint *P = [[[self q] multiply:d] normalize];
        if ([P isInfinity]) {
            @throw [NSException exceptionWithName:@"IllegalState" reason:@"invalid EDCH: infinity" userInfo:nil];
        }
        
        return [[P affineXCoord] getEncoded];
    }
}

- (ECPoint*)copyQ {
    return [[[self x9ECParameters] curve] createPoint:[self x] withY:[self y]];
}

- (BigInteger*)x {
    return [[[self q] xCoord] toBigInteger];
}

- (BigInteger*)y {
    return [[[self q] yCoord] toBigInteger];
}

- (NSMutableData*)xEncoded {
    return [[[self q] xCoord] getEncoded];
}

- (NSMutableData*)yEncoded {
    return [[[self q] yCoord] getEncoded];
}

- (X9ECParameters*)getX9ECParameters {
    return [ECAssistant x9ECParameters:[self curveName]];
}

- (int)fieldBitLength {
    return [[[self x9ECParameters] curve] fieldSize];
}

- (int)fieldLength {
    return [ECAssistant fieldLengthWithInt:[self fieldBitLength]];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object == nil) {
        return NO;
    }
    if ([self class] != [object class]) {
        return NO;
    }
    ECCurvePoint *other = (ECCurvePoint*)object;
    if (![[self curveName] isEqualToString:[other curveName]]) {
        return NO;
    }
    if (![[self q] isEqual:[other q]]) {
        return NO;
    }
    return YES;
}

@end
