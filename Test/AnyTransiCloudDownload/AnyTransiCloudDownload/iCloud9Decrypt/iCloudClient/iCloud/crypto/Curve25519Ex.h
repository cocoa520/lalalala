//
//  Curve25519.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Curve25519Ex : NSObject

+ (NSMutableData*)agreement:(NSData*)publicKey withPrivateKey:(NSData*)privateKey;

/* key size */
+ (int)KeySize;

/********* KEY AGREEMENT *********/

/// <summary>
/// Private key clamping (inline, for performance)
/// </summary>
/// <param name="key">[out] 32 random bytes</param>
+ (void)clampPrivateKeyInline:(NSMutableData*)key;

/// <summary>
/// Private key clamping
/// </summary>
/// <param name="rawKey">[out] 32 random bytes</param>
+ (NSMutableData*)clampPrivateKey:(NSMutableData*)rawKey;

/// <summary>
/// Creates a random private key
/// </summary>
/// <returns>32 random bytes that are clamped to a suitable private key</returns>
+ (NSMutableData*)createRandomPrivateKey;

/// <summary>
/// Key-pair generation (inline, for performance)
/// </summary>
/// <param name="publicKey">[out] public key</param>
/// <param name="signingKey">[out] signing key (ignored if NULL)</param>
/// <param name="privateKey">[out] private key</param>
/// <remarks>WARNING: if signingKey is not NULL, this function has data-dependent timing</remarks>
+ (void)keyGenInline:(NSMutableData*)publicKey withSigningKey:(NSMutableData*)signingKey withPrivateKey:(NSMutableData*)privateKey;

/// <summary>
/// Generates the public key out of the clamped private key
/// </summary>
/// <param name="privateKey">private key (must use ClampPrivateKey first!)</param>
+ (NSMutableData*)getPublicKey:(NSMutableData*)privateKey;

/// <summary>
/// Generates signing key out of the clamped private key
/// </summary>
/// <param name="privateKey">private key (must use ClampPrivateKey first!)</param>
+ (NSMutableData*)getSigningKey:(NSMutableData*)privateKey;



@end

/* sahn0:
 * Using this class instead of long[10] to avoid bounds checks. */

@interface Long10 : NSObject {
@private
    int64_t                        _n0;
    int64_t                        _n1;
    int64_t                        _n2;
    int64_t                        _n3;
    int64_t                        _n4;
    int64_t                        _n5;
    int64_t                        _n6;
    int64_t                        _n7;
    int64_t                        _n8;
    int64_t                        _n9;
}

@property (nonatomic, readwrite, assign) int64_t n0;
@property (nonatomic, readwrite, assign) int64_t n1;
@property (nonatomic, readwrite, assign) int64_t n2;
@property (nonatomic, readwrite, assign) int64_t n3;
@property (nonatomic, readwrite, assign) int64_t n4;
@property (nonatomic, readwrite, assign) int64_t n5;
@property (nonatomic, readwrite, assign) int64_t n6;
@property (nonatomic, readwrite, assign) int64_t n7;
@property (nonatomic, readwrite, assign) int64_t n8;
@property (nonatomic, readwrite, assign) int64_t n9;

- (id)initWithN0:(int64_t)n0 withN1:(int64_t)n1 withN2:(int64_t)n2 withN3:(int64_t)n3 withN4:(int64_t)n4 withN5:(int64_t)n5 withN6:(int64_t)n6 withN7:(int64_t)n7 withN8:(int64_t)n8 withN9:(int64_t)n9;

@end
