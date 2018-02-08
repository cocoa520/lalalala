//
//  KDFCounterParameters.m
//  
//
//  Created by iMobie on 7/22/16.
//
//  Complete

#import "KDFCounterParameters.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@interface KDFCounterParameters ()

@property (nonatomic, readwrite, retain) NSMutableData *ki;
@property (nonatomic, readwrite, retain) NSMutableData *fixedInputDataCounterPrefix;
@property (nonatomic, readwrite, retain) NSMutableData *fixedInputDataCounterSuffix;
@property (nonatomic, readwrite, assign) int r;

@end

@implementation KDFCounterParameters
@synthesize ki = _ki;
@synthesize fixedInputDataCounterPrefix = _fixedInputDataCounterPrefix;
@synthesize fixedInputDataCounterSuffix = _fixedInputDataCounterSuffix;
@synthesize r = _r;

/**
 * Base constructor - suffix fixed input data only.
 *
 * @param ki the KDF seed
 * @param fixedInputDataCounterSuffix  fixed input data to follow counter.
 * @param r length of the counter in bits.
 */
- (id)initWithKi:(NSMutableData*)ki withFixedInputDataCounterSuffix:(NSMutableData*)fixedInputDataCounterSuffix withR:(int)r {
    if (self = [self initWithKi:ki withFixedInputDataCounterPrefix:nil withFixedInputDataCounterSuffix:fixedInputDataCounterSuffix withR:r]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * Base constructor - prefix and suffix fixed input data.
 *
 * @param ki the KDF seed
 * @param fixedInputDataCounterPrefix fixed input data to precede counter
 * @param fixedInputDataCounterSuffix fixed input data to follow counter.
 * @param r length of the counter in bits.
 */
- (id)initWithKi:(NSMutableData*)ki withFixedInputDataCounterPrefix:(NSMutableData*)fixedInputDataCounterPrefix withFixedInputDataCounterSuffix:(NSMutableData*)fixedInputDataCounterSuffix withR:(int)r {
    if (self = [super init]) {
        if (ki == nil) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"A KDF requires Ki (a seed) as input" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (r != 8 && r != 16 && r != 24 && r != 32) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"Length of counter should be 8, 16, 24 or 32" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        @autoreleasepool {
            NSMutableData *tmpData = [Arrays cloneWithByteArray:ki];
            [self setKi:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
            
            if (fixedInputDataCounterPrefix == nil) {
                NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0];
                [self setFixedInputDataCounterPrefix:tmpData];
#if !__has_feature(objc_arc)
                if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            } else {
                NSMutableData *tmpData = [Arrays cloneWithByteArray:fixedInputDataCounterPrefix];
                [self setFixedInputDataCounterPrefix:tmpData];
#if !__has_feature(objc_arc)
                if (tmpData) [tmpData release]; tmpData = nil;
#endif
            }
            
            if (fixedInputDataCounterSuffix == nil) {
                NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0];
                [self setFixedInputDataCounterSuffix:tmpData];
#if !__has_feature(objc_arc)
                if (tmpData != nil) [tmpData release]; tmpData = nil;
#endif
            } else {
                NSMutableData *tmpData = [Arrays cloneWithByteArray:fixedInputDataCounterSuffix];
                [self setFixedInputDataCounterSuffix:tmpData];
#if !__has_feature(objc_arc)
                if (tmpData) [tmpData release]; tmpData = nil;
#endif
            }

            [self setR:r];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setKi:nil];
    [self setFixedInputDataCounterPrefix:nil];
    [self setFixedInputDataCounterSuffix:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getKI {
    return [self ki];
}

- (NSMutableData*)getFixedInputData {
    //Retained for backwards compatibility
    return [[Arrays cloneWithByteArray:[self fixedInputDataCounterSuffix]] autorelease];
}

- (NSMutableData*)getFixedInputDataCounterPrefix {
    return [[Arrays cloneWithByteArray:[self fixedInputDataCounterPrefix]] autorelease];
}

- (NSMutableData*)getFixedInputDataCounterSuffix {
    return [[Arrays cloneWithByteArray:[self fixedInputDataCounterSuffix]] autorelease];
}

- (int)getR {
    return [self r];
}

@end
