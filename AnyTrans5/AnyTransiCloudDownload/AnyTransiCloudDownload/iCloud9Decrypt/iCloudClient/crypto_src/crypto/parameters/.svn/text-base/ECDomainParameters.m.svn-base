//
//  ECDomainParameters.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECDomainParameters.h"
#import "Arrays.h"
#import "BigInteger.h"
#import "ECCurve.h"
#import "ECPoint.h"

@implementation ECDomainParameters
@synthesize curve = _curve;
@synthesize seed = _seed;
@synthesize g = _g;
@synthesize n = _n;
@synthesize h = _h;

- (id)initWithCurve:(ECCurve*)curve withG:(ECPoint*)g withN:(BigInteger*)n {
    if (self = [self initWithCurve:curve withG:g withN:n withH:[BigInteger One]]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve*)curve withG:(ECPoint*)g withN:(BigInteger*)n withH:(BigInteger*)h {
    if (self = [self initWithCurve:curve withG:g withN:n withH:h withSeed:nil]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithCurve:(ECCurve*)curve withG:(ECPoint*)g withN:(BigInteger*)n withH:(BigInteger*)h withSeed:(NSMutableData*)seed {
    if (self = [super init]) {
        if (curve == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"curve" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (g == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"g" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (n == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"n" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (h == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"h" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        @autoreleasepool {
            [self setCurve:curve];
            [self setG:[g normalize]];
            [self setN:n];
            [self setH:h];
            if (seed != nil) {
                NSMutableData *tmpData = [Arrays cloneWithByteArray:seed];
                [self setSeed:tmpData];
#if !__has_feature(objc_arc)
                if (tmpData) [tmpData release]; tmpData = nil;
#endif
            } else {
                [self setSeed:nil];
            }
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setCurve:nil];
    [self setSeed:nil];
    [self setG:nil];
    [self setN:nil];
    [self setH:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getSeed {
    return [[Arrays cloneWithByteArray:[self seed]] autorelease];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (object && [object isKindOfClass:[ECDomainParameters class]]) {
        return [self equalsWithOther:(ECDomainParameters*)object];
    } else {
        return NO;
    }
}

- (BOOL)equalsWithOther:(ECDomainParameters*)other {
    return [[self curve] equalsWithOther:[other curve]] && [[self g] equalsWithOther:[other g]] && [[self n] isEqual:[other n]] && [[self h] isEqual:[self h]] && [Arrays areEqualWithByteArray:[self seed] withB:[other seed]];
}

@end
