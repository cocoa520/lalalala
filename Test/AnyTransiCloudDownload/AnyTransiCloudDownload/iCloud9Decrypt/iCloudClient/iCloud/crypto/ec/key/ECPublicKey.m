//
//  ECPublicKey.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPublicKey.h"
#import "BigInteger.h"
#import "ECCurvePoint.h"

@interface ECPublicKey ()

@property (nonatomic, readwrite, retain) ECCurvePoint *point;

@end

@implementation ECPublicKey
@synthesize point = _point;

+ (ECPublicKey*)create:(BigInteger*)x withY:(BigInteger*)y withCurveName:(NSString*)curveName {
    ECPublicKey *retPubKey = nil;
    @try {
        ECCurvePoint *curvePoint = [ECCurvePoint create:x withY:y withCurveName:curveName];
        if (curvePoint != nil) {
            retPubKey = [ECPublicKey create:curvePoint];
        }
    }
    @catch (NSException *exception) {
    }
    return retPubKey;
}

+ (ECPublicKey*)create:(ECCurvePoint*)point {
    return [[[ECPublicKey alloc] initWithPoint:point] autorelease];
}

- (id)initWithPoint:(ECCurvePoint*)point {
    if (self = [super init]) {
        if (point == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"point" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setPoint:point];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_point != nil) [_point release]; _point = nil;
    [super dealloc];
#endif
}

- (ECCurvePoint*)getPoint {
    return [self point];
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
    ECPublicKey *other = (ECPublicKey*)object;
    if (![[self point] isEqual:[other point]]) {
        return NO;
    }
    return YES;
}

@end
