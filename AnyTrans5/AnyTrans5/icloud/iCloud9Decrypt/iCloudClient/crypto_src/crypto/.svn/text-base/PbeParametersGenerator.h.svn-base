//
//  PbeParametersGenerator.h
//  
//
//  Created by Pallas on 7/20/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class CipherParameters;

@interface PbeParametersGenerator : NSObject {
@protected
    NSMutableData *                     _mPassword;
    NSMutableData *                     _mSalt;
    int                                 _mIterationCount;
}

@property (nonatomic, readwrite, retain) NSMutableData *mPassword;
@property (nonatomic, readwrite, retain) NSMutableData *mSalt;
@property (nonatomic, readwrite, assign) int mIterationCount;

/**
 * initialise the Pbe generator.
 *
 * @param password the password converted into bytes (see below).
 * @param salt the salt to be mixed with the password.
 * @param iterationCount the number of iterations the "mixing" function
 * is to be applied for.
 */
- (void)init:(NSMutableData*)password withSalt:(NSMutableData*)salt withIterationCount:(int)iterationCount;
- (NSMutableData*)password;
/**
 * return the password byte array.
 *
 * @return the password byte array.
 */
- (NSMutableData*)getPassword __deprecated;
- (NSMutableData*)salt;
/**
 * return the salt byte array.
 *
 * @return the salt byte array.
 */
- (NSMutableData*)getSalt __deprecated;
/**
 * return the iteration count.
 *
 * @return the iteration count.
 */
- (int)iterationCount;
/**
 * Generate derived parameters for a key of length keySize.
 *
 * @param keySize the length, in bits, of the key required.
 * @return a parameters object representing a key.
 */
- (CipherParameters*)generateDerivedParameters:(int)keySize __deprecated;
- (CipherParameters*)generateDerivedParameters:(NSString*)algorithm withKeySize:(int)keySize;
/**
 * Generate derived parameters for a key of length keySize, and
 * an initialisation vector (IV) of length ivSize.
 *
 * @param keySize the length, in bits, of the key required.
 * @param ivSize the length, in bits, of the iv required.
 * @return a parameters object representing a key and an IV.
 */
- (CipherParameters*)generateDerivedParameters:(int)keySize withIvSize:(int)ivSize __deprecated;
- (CipherParameters*)generateDerivedParameters:(NSString*)algorithm withKeySize:(int)keySize withIvSize:(int)ivSize;
/**
 * Generate derived parameters for a key of length keySize, specifically
 * for use with a MAC.
 *
 * @param keySize the length, in bits, of the key required.
 * @return a parameters object representing a key.
 */
- (CipherParameters*)generateDerivedMacParameters:(int)keySize;
/**
 * converts a password to a byte array according to the scheme in
 * Pkcs5 (ascii, no padding)
 *
 * @param password a character array representing the password.
 * @return a byte array representing the password.
 */
+ (NSMutableData*)pkcs5PasswordToBytesWithUniCharArray:(NSMutableArray*)password;
+ (NSMutableData*)pkcs5PasswordToBytesWithString:(NSString*)password __deprecated;
/**
 * converts a password to a byte array according to the scheme in
 * PKCS5 (UTF-8, no padding)
 *
 * @param password a character array representing the password.
 * @return a byte array representing the password.
 */
+ (NSMutableData*)pkcs5PasswordToUtf8BytesWithUniCharArray:(NSMutableArray*)password;
+ (NSMutableData*)pkcs5PasswordToUtf8BytesWithString:(NSString*)password __deprecated;
/**
 * converts a password to a byte array according to the scheme in
 * Pkcs12 (unicode, big endian, 2 zero pad bytes at the end).
 *
 * @param password a character array representing the password.
 * @return a byte array representing the password.
 */
+ (NSMutableData*)pkcs12PasswordToBytesWithUniCharArray:(NSMutableArray*)password;
+ (NSMutableData*)pkcs12PasswordToBytesWithUniCharArray:(NSMutableArray*)password withWrongPkcs12Zero:(BOOL)wrongPkcs12Zero;

@end
