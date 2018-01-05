//
//  NISTObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface NISTObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)nistAlgorithm;
+ (ASN1ObjectIdentifier *)hashAlgs;
+ (ASN1ObjectIdentifier *)id_sha256;
+ (ASN1ObjectIdentifier *)id_sha384;
+ (ASN1ObjectIdentifier *)id_sha512;
+ (ASN1ObjectIdentifier *)id_sha224;
+ (ASN1ObjectIdentifier *)id_sha512_224;
+ (ASN1ObjectIdentifier *)id_sha512_256;
+ (ASN1ObjectIdentifier *)id_sha3_224;
+ (ASN1ObjectIdentifier *)id_sha3_256;
+ (ASN1ObjectIdentifier *)id_sha3_384;
+ (ASN1ObjectIdentifier *)id_sha3_512;
+ (ASN1ObjectIdentifier *)id_shake128;
+ (ASN1ObjectIdentifier *)id_shake256;
+ (ASN1ObjectIdentifier *)aes;
+ (ASN1ObjectIdentifier *)id_aes128_ECB;
+ (ASN1ObjectIdentifier *)id_aes128_CBC;
+ (ASN1ObjectIdentifier *)id_aes128_OFB;
+ (ASN1ObjectIdentifier *)id_aes128_CFB;
+ (ASN1ObjectIdentifier *)id_aes128_wrap;
+ (ASN1ObjectIdentifier *)id_aes128_GCM;
+ (ASN1ObjectIdentifier *)id_aes128_CCM;
+ (ASN1ObjectIdentifier *)id_aes192_ECB;
+ (ASN1ObjectIdentifier *)id_aes192_CBC;
+ (ASN1ObjectIdentifier *)id_aes192_OFB;
+ (ASN1ObjectIdentifier *)id_aes192_CFB;
+ (ASN1ObjectIdentifier *)id_aes192_wrap;
+ (ASN1ObjectIdentifier *)id_aes192_GCM;
+ (ASN1ObjectIdentifier *)id_aes192_CCM;
+ (ASN1ObjectIdentifier *)id_aes256_ECB;
+ (ASN1ObjectIdentifier *)id_aes256_CBC;
+ (ASN1ObjectIdentifier *)id_aes256_OFB;
+ (ASN1ObjectIdentifier *)id_aes256_CFB;
+ (ASN1ObjectIdentifier *)id_aes256_wrap;
+ (ASN1ObjectIdentifier *)id_aes256_GCM;
+ (ASN1ObjectIdentifier *)id_aes256_CCM;
+ (ASN1ObjectIdentifier *)id_dsa_with_sha2;
+ (ASN1ObjectIdentifier *)dsa_with_sha224;
+ (ASN1ObjectIdentifier *)dsa_with_sha256;
+ (ASN1ObjectIdentifier *)dsa_with_sha384;
+ (ASN1ObjectIdentifier *)dsa_with_sha512;

@end
