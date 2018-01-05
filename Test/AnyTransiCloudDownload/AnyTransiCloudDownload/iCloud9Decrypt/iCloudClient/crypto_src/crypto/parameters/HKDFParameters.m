//
//  HKDFParameters.m
//  
//
//  Created by Pallas on 7/22/16.
//
//  Complete

#import "HKDFParameters.h"
#import "CategoryExtend.h"
#import "Arrays.h"

@interface HKDFParameters ()

@property (nonatomic, readwrite, retain) NSMutableData *ikm;
@property (nonatomic, readwrite, assign) BOOL skipExpand;
@property (nonatomic, readwrite, retain) NSMutableData *salt;
@property (nonatomic, readwrite, retain) NSMutableData *info;

@end

@implementation HKDFParameters
@synthesize ikm = _ikm;
@synthesize skipExpand = _skipExpand;
@synthesize salt = _salt;
@synthesize info = _info;

- (id)initWithIkm:(NSMutableData*)ikm withSkip:(BOOL)skip withSalt:(NSMutableData*)salt withInfo:(NSMutableData*)info {
    if (self = [super init]) {
        if (ikm == nil) {
            @throw [NSException exceptionWithName:@"Argument" reason:@"IKM (input keying material) should not be null" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        NSMutableData *tmpData = [Arrays cloneWithByteArray:ikm];
        [self setIkm:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setSkipExpand:skip];
        
        if (salt == nil || salt.length == 0) {
            [self setSalt:nil];
        } else {
            NSMutableData *tmpData = [Arrays cloneWithByteArray:salt];
            [self setSalt:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        
        if (info == nil) {
            NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0];
            [self setInfo:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        } else {
            NSMutableData *tmpData = [Arrays cloneWithByteArray:info];
            [self setInfo:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

/**
 * Generates parameters for HKDF, specifying both the optional salt and
 * optional info. Step 1: Extract won't be skipped.
 *
 * @param ikm  the input keying material or seed
 * @param salt the salt to use, may be null for a salt for hashLen zeros
 * @param info the info to use, may be null for an info field of zero bytes
 */
- (id)initWithIkm:(NSMutableData*)ikm withSalt:(NSMutableData*)salt withInfo:(NSMutableData*)info {
    if (self = [self initWithIkm:ikm withSkip:NO withSalt:salt withInfo:info]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setIkm:nil];
    [self setSalt:nil];
    [self setInfo:nil];
    [super dealloc];
#endif
}

/**
 * Factory method that makes the HKDF skip the extract part of the key
 * derivation function.
 *
 * @param ikm  the input keying material or seed, directly used for step 2:
 *             Expand
 * @param info the info to use, may be null for an info field of zero bytes
 * @return HKDFParameters that makes the implementation skip step 1
 */
+ (HKDFParameters*)skipExtractParameters:(NSMutableData*)ikm withInfo:(NSMutableData*)info {
    return [[[HKDFParameters alloc] initWithIkm:ikm withSkip:YES withSalt:nil withInfo:info] autorelease];
}

+ (HKDFParameters*)defaultParameters:(NSMutableData*)ikm {
    return [[[HKDFParameters alloc] initWithIkm:ikm withSkip:NO withSalt:nil withInfo:nil] autorelease];
}

/**
 * Returns the input keying material or seed.
 *
 * @return the keying material
 */
- (NSMutableData*)getIKM {
    return [[Arrays cloneWithByteArray:[self ikm]] autorelease];
}

/**
 * Returns if step 1: extract has to be skipped or not
 *
 * @return true for skipping, false for no skipping of step 1
 */
- (BOOL)skipExtract {
    return self.skipExpand;
}

/**
 * Returns the salt, or null if the salt should be generated as a byte array
 * of HashLen zeros.
 *
 * @return the salt, or null
 */
- (NSMutableData*)getSalt {
    return [[Arrays cloneWithByteArray:[self salt]] autorelease];
}

/**
 * Returns the info field, which may be empty (null is converted to empty).
 *
 * @return the info field, never null
 */
- (NSMutableData*)getInfo {
    return [[Arrays cloneWithByteArray:[self info]] autorelease];
}

@end
