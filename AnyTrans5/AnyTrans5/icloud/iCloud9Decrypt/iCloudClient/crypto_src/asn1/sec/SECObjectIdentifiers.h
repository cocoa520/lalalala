//
//  SECObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface SECObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)ellipticCurve;
+ (ASN1ObjectIdentifier *)sect163k1;
+ (ASN1ObjectIdentifier *)sect163r1;
+ (ASN1ObjectIdentifier *)sect239k1;
+ (ASN1ObjectIdentifier *)sect113r1;
+ (ASN1ObjectIdentifier *)sect113r2;
+ (ASN1ObjectIdentifier *)secp112r1;
+ (ASN1ObjectIdentifier *)secp112r2;
+ (ASN1ObjectIdentifier *)secp160r1;
+ (ASN1ObjectIdentifier *)secp160k1;
+ (ASN1ObjectIdentifier *)secp256k1;
+ (ASN1ObjectIdentifier *)sect163r2;
+ (ASN1ObjectIdentifier *)sect283k1;
+ (ASN1ObjectIdentifier *)sect283r1;
+ (ASN1ObjectIdentifier *)sect131r1;
+ (ASN1ObjectIdentifier *)sect131r2;
+ (ASN1ObjectIdentifier *)sect193r1;
+ (ASN1ObjectIdentifier *)sect193r2;
+ (ASN1ObjectIdentifier *)sect233k1;
+ (ASN1ObjectIdentifier *)sect233r1;
+ (ASN1ObjectIdentifier *)secp128r1;
+ (ASN1ObjectIdentifier *)secp128r2;
+ (ASN1ObjectIdentifier *)secp160r2;
+ (ASN1ObjectIdentifier *)secp192k1;
+ (ASN1ObjectIdentifier *)secp224k1;
+ (ASN1ObjectIdentifier *)secp224r1;
+ (ASN1ObjectIdentifier *)secp384r1;
+ (ASN1ObjectIdentifier *)secp521r1;
+ (ASN1ObjectIdentifier *)sect409k1;
+ (ASN1ObjectIdentifier *)sect409r1;
+ (ASN1ObjectIdentifier *)sect571k1;
+ (ASN1ObjectIdentifier *)sect571r1;
+ (ASN1ObjectIdentifier *)secp192r1;
+ (ASN1ObjectIdentifier *)secp256r1;
+ (ASN1ObjectIdentifier *)secg_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha224kdf_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha256kdf_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha384kdf_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_stdDH_sha512kdf_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha224kdf_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha256kdf_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha384kdf_scheme;
+ (ASN1ObjectIdentifier *)dhSinglePass_cofactorDH_sha512kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvSinglePass_sha224kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvSinglePass_sha256kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvSinglePass_sha384kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvSinglePass_sha512kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvFull_sha224kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvFull_sha256kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvFull_sha384kdf_scheme;
+ (ASN1ObjectIdentifier *)mqvFull_sha512kdf_scheme;

@end
