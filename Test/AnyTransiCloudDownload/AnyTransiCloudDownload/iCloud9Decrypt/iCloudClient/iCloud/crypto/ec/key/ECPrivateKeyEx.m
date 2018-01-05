//
//  ECPrivateKey.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECPrivateKeyEx.h"
#import "BigInteger.h"
#import "BigIntegers.h"
#import "ECCurvePoint.h"
#import "ECPublicKey.h"

@interface ECPrivateKeyEx ()

@property (nonatomic, readwrite, retain) ECPublicKey *publicKey;
@property (nonatomic, readwrite, retain) BigInteger *d;

@end

@implementation ECPrivateKeyEx
@synthesize publicKey = _publicKey;
@synthesize d = _d;

+ (ECPrivateKeyEx*)create:(BigInteger*)x withY:(BigInteger*)y withD:(BigInteger*)d withCurveName:(NSString*)curveName {
    ECPrivateKeyEx *priKey = nil;
    @autoreleasepool {
        @try {
            ECCurvePoint *curvePoint = [ECCurvePoint create:d withCurveName:curveName];
            if (curvePoint != nil && [ECPrivateKeyEx correlate:x withY:y withQ:curvePoint]) {
                ECPublicKey *pubKey = [ECPublicKey create:curvePoint];
                if (pubKey != nil) {
                    priKey = [[ECPrivateKeyEx alloc] initWithPublicKey:pubKey withD:d];
                }
            }
        }
        @catch (NSException *exception) {
        }
    }
    return (priKey ? [priKey autorelease] : nil);
}

+ (BOOL)correlate:(BigInteger*)x withY:(BigInteger*)y withQ:(ECCurvePoint*)q {
    BOOL xBool = NO;
    if (x != nil) {
        xBool = [x isEqual:[q x]];
    } else {
        xBool = YES;
    }
    
    BOOL yBool = NO;
    if (y != nil) {
        yBool = [y isEqual:[q y]];
    } else {
        yBool = YES;
    }
    
    return xBool && yBool;
}

- (id)initWithPublicKey:(ECPublicKey*)publicKey withD:(BigInteger*)d {
    if (self = [super init]) {
        if (publicKey == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"publicKey" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setPublicKey:publicKey];
        [self setD:d];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setPublicKey:nil];
    [self setD:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)agreement:(ECPublicKey*)publicKey {
    NSMutableData *retData = nil;
    @autoreleasepool {
        @try {
            retData = [[publicKey getPoint] agreement:[self d]];
            [retData retain];
        }
        @catch (NSException *exception) {
        }
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)dEncoded {
    NSMutableData *retData = nil;
    @autoreleasepool {
        @try {
            retData = [BigIntegers asUnsignedByteArray:[[[self publicKey] getPoint] fieldLength] withN:[self d]];
            [retData retain];            
        }
        @catch (NSException *exception) {
        }
    }
    return (retData ? [retData autorelease] : nil);
}

- (ECCurvePoint*)getPoint {
    return [[self publicKey] getPoint];
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
    ECPrivateKeyEx *other = (ECPrivateKeyEx*)object;
    if (![[self publicKey] isEqual:[other publicKey]]) {
        return NO;
    }
    if (![[self d] isEqual:[other d]]) {
        return NO;
    }
    return YES;
}

@end
