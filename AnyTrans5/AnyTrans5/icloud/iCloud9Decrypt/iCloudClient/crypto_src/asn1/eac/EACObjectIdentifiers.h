//
//  EACObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface EACObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)bsi_de;
+ (ASN1ObjectIdentifier *)id_PK;
+ (ASN1ObjectIdentifier *)id_PK_DH;
+ (ASN1ObjectIdentifier *)id_PK_ECDH;
+ (ASN1ObjectIdentifier *)id_CA;
+ (ASN1ObjectIdentifier *)id_CA_DH;
+ (ASN1ObjectIdentifier *)id_CA_DH_3DES_CBC_CBC;
+ (ASN1ObjectIdentifier *)id_CA_ECDH;
+ (ASN1ObjectIdentifier *)id_CA_ECDH_3DES_CBC_CBC;
+ (ASN1ObjectIdentifier *)id_TA;
+ (ASN1ObjectIdentifier *)id_TA_RSA;
+ (ASN1ObjectIdentifier *)id_TA_RSA_v1_5_SHA_1;
+ (ASN1ObjectIdentifier *)id_TA_RSA_v1_5_SHA_256;
+ (ASN1ObjectIdentifier *)id_TA_RSA_PSS_SHA_1;
+ (ASN1ObjectIdentifier *)id_TA_RSA_PSS_SHA_256;
+ (ASN1ObjectIdentifier *)id_TA_RSA_v1_5_SHA_512;
+ (ASN1ObjectIdentifier *)id_TA_RSA_PSS_SHA_512;
+ (ASN1ObjectIdentifier *)id_TA_ECDSA;
+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_1;
+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_224;
+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_256;
+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_384;
+ (ASN1ObjectIdentifier *)id_TA_ECDSA_SHA_512;
+ (ASN1ObjectIdentifier *)id_EAC_ePassport;

@end
