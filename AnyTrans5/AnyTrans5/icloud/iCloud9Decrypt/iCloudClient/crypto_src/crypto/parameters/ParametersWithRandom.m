//
//  ParametersWithRandom.m
//  
//
//  Created by Pallas on 7/14/16.
//
//  Complete

#import "ParametersWithRandom.h"
#import "SecureRandom.h"

@interface ParametersWithRandom ()

@property (nonatomic, readwrite, retain) CipherParameters *parameters;
@property (nonatomic, readwrite, retain) SecureRandom *random;

@end

@implementation ParametersWithRandom
@synthesize parameters = _parameters;
@synthesize random = _random;

- (id)initWithParameters:(CipherParameters*)parameters withRandom:(SecureRandom*)random {
    if (self = [super init]) {
        if (parameters == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"parameters" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (random == nil) {
            @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"random" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        
        [self setParameters:parameters];
        [self setRandom:random];
        
        return self;
    } else {
        return nil;
    }
}

- (id)initWithParameters:(CipherParameters*)parameters {
    SecureRandom *secRandom = [[SecureRandom alloc] init];
    if (self = [self initWithParameters:parameters withRandom:secRandom]) {
#if !__has_feature(objc_arc)
        if (secRandom != nil) [secRandom release]; secRandom = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (secRandom != nil) [secRandom release]; secRandom = nil;
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setParameters:nil];
    [self setRandom:nil];
    [super dealloc];
#endif
}

- (SecureRandom*)getRandom {
    return [self random];
}

@end
