//
//  PbeParametersGenerator.m
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import "PbeParametersGenerator.h"
#import "CipherParameters.h"
#import "Arrays.h"
#import "StringsEx.h"
#import "CategoryExtend.h"

@implementation PbeParametersGenerator
@synthesize mPassword = _mPassword;
@synthesize mSalt = _mSalt;
@synthesize mIterationCount = _mIterationCount;

/**
 * base constructor.
 */
- (id)init {
    if (self = [super init]) {
        return self;
    } else {
        return nil;
    }
}

/**
 * initialise the Pbe generator.
 *
 * @param password the password converted into bytes (see below).
 * @param salt the salt to be mixed with the password.
 * @param iterationCount the number of iterations the "mixing" function
 * is to be applied for.
 */
- (void)init:(NSMutableData*)password withSalt:(NSMutableData*)salt withIterationCount:(int)iterationCount {
    if (password == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"password" userInfo:nil];
    }
    if (salt == nil) {
        @throw [NSException exceptionWithName:@"ArgumentNull" reason:@"salt" userInfo:nil];
    }
    @autoreleasepool {
        NSMutableData *mPasswordData = [Arrays cloneWithByteArray:password];
        NSMutableData *mSaltData = [Arrays cloneWithByteArray:salt];
        [self setMPassword:mPasswordData];
        [self setMSalt:mSaltData];
        [self setMIterationCount:iterationCount];
#if !__has_feature(objc_arc)
        if (mPasswordData) [mPasswordData release]; mPasswordData = nil;
        if (mSaltData) [mSaltData release]; mSaltData = nil;
#endif
    }
}

- (NSMutableData*)password {
    return [[Arrays cloneWithByteArray:[self mPassword]] autorelease];
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setMPassword:nil];
    [self setMSalt:nil];
    [super dealloc];
#endif
}

/**
 * return the password byte array.
 *
 * @return the password byte array.
 */
- (NSMutableData*)getPassword {
    return [self password];
}

- (NSMutableData*)salt {
    return [[Arrays cloneWithByteArray:[self mSalt]] autorelease];
}

/**
 * return the salt byte array.
 *
 * @return the salt byte array.
 */
- (NSMutableData*)getSalt {
    return [self salt];
}

/**
 * return the iteration count.
 *
 * @return the iteration count.
 */
- (int)iterationCount {
    return [self mIterationCount];
}

/**
 * Generate derived parameters for a key of length keySize.
 *
 * @param keySize the length, in bits, of the key required.
 * @return a parameters object representing a key.
 */
- (CipherParameters*)generateDerivedParameters:(int)keySize {
    return nil;
}

- (CipherParameters*)generateDerivedParameters:(NSString*)algorithm withKeySize:(int)keySize {
    return nil;
}

/**
 * Generate derived parameters for a key of length keySize, and
 * an initialisation vector (IV) of length ivSize.
 *
 * @param keySize the length, in bits, of the key required.
 * @param ivSize the length, in bits, of the iv required.
 * @return a parameters object representing a key and an IV.
 */
- (CipherParameters*)generateDerivedParameters:(int)keySize withIvSize:(int)ivSize {
    return nil;
}

- (CipherParameters*)generateDerivedParameters:(NSString*)algorithm withKeySize:(int)keySize withIvSize:(int)ivSize {
    return nil;
}

/**
 * Generate derived parameters for a key of length keySize, specifically
 * for use with a MAC.
 *
 * @param keySize the length, in bits, of the key required.
 * @return a parameters object representing a key.
 */
- (CipherParameters*)generateDerivedMacParameters:(int)keySize {
    return nil;
}

/**
 * converts a password to a byte array according to the scheme in
 * Pkcs5 (ascii, no padding)
 *
 * @param password a character array representing the password.
 * @return a byte array representing the password.
 */
+ (NSMutableData*)pkcs5PasswordToBytesWithUniCharArray:(NSMutableArray*)password {
    if (password == nil) {
        return [[[NSMutableData alloc] initWithSize:0] autorelease];
    }
    
    return [StringsEx toByteArrayWithUnicharArray:password];
}


+ (NSMutableData*)pkcs5PasswordToBytesWithString:(NSString*)password {
    if (password == nil) {
        return [[[NSMutableData alloc] initWithSize:0] autorelease];
    }
    
    return [StringsEx toByteArrayWithString:password];
}

/**
 * converts a password to a byte array according to the scheme in
 * PKCS5 (UTF-8, no padding)
 *
 * @param password a character array representing the password.
 * @return a byte array representing the password.
 */
+ (NSMutableData*)pkcs5PasswordToUtf8BytesWithUniCharArray:(NSMutableArray*)password {
    NSMutableData *retData = nil;
    @autoreleasepool {
        if (password == nil) {
            retData = [[NSMutableData alloc] initWithSize:0];
        } else {
            int size = (int)(password.count);
            NSMutableString *cs = [[NSMutableString alloc] initWithCapacity:size];
            for (int i = 0; i < size; ++i) {
                [cs appendFormat:@"%C", (unichar)[password[i] unsignedShortValue]];
            }
            retData = [[NSMutableData alloc] initWithData:[cs dataUsingEncoding:NSUTF8StringEncoding]];
#if !__has_feature(objc_arc)
            if (cs != nil) [cs release]; cs = nil;
#endif
        }
    }
    return (retData ? [retData autorelease] : nil);
}

+ (NSMutableData*)pkcs5PasswordToUtf8BytesWithString:(NSString*)password {
    NSMutableData *retData = nil;
    @autoreleasepool {
        if (password == nil) {
            retData = [[NSMutableData alloc] initWithSize:0];
        } else {
            retData = [[NSMutableData alloc] initWithData:[password dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return (retData ? [retData autorelease] : nil);
}

/**
 * converts a password to a byte array according to the scheme in
 * Pkcs12 (unicode, big endian, 2 zero pad bytes at the end).
 *
 * @param password a character array representing the password.
 * @return a byte array representing the password.
 */
+ (NSMutableData*)pkcs12PasswordToBytesWithUniCharArray:(NSMutableArray*)password {
    return [PbeParametersGenerator pkcs12PasswordToBytesWithUniCharArray:password withWrongPkcs12Zero:NO];
}

+ (NSMutableData*)pkcs12PasswordToBytesWithUniCharArray:(NSMutableArray*)password withWrongPkcs12Zero:(BOOL)wrongPkcs12Zero {
    NSMutableData *bytes = nil;
    @autoreleasepool {
        if (password == nil || password.count < 1) {
            bytes = [[NSMutableData alloc] initWithSize:(wrongPkcs12Zero ? 2 : 0)];
        } else {
            // +1 for extra 2 pad bytes.
            bytes = [[NSMutableData alloc] initWithSize:(((int)(password.count) + 1) * 2)];
            
            int count = (int)(password.count);
            for (int i = 0; i < count; i++) {
                unichar uc = (unichar)[password[i] unsignedShortValue];
                ushort_16.ushort16 = uc;
                Byte *rb = NULL;
                if ([BigEndianBitConverter isLitte_Endian]) {
                    rb = [BigEndianBitConverter reverseBytes:(Byte*)(ushort_16.c) offset:0 count:2];
                    [bytes replaceBytesInRange:NSMakeRange((i * 2), 2) withBytes:rb length:2];
                    free(rb);
                    rb = NULL;
                } else {
                    rb = (Byte*)(ushort_16.c);
                    [bytes replaceBytesInRange:NSMakeRange((i * 2), 2) withBytes:rb length:2];
                }
            }
        }
    }
    
    return (bytes ? [bytes autorelease] : nil);
}

@end
