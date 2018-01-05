//
//  TeleTrusTObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/16/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface TeleTrusTObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)teleTrusTAlgorithm;
+ (ASN1ObjectIdentifier *)ripemd160;
+ (ASN1ObjectIdentifier *)ripemd128;
+ (ASN1ObjectIdentifier *)ripemd256;
+ (ASN1ObjectIdentifier *)teleTrusTRSAsignatureAlgorithm;
+ (ASN1ObjectIdentifier *)rsaSignatureWithripemd160;
+ (ASN1ObjectIdentifier *)rsaSignatureWithripemd128;
+ (ASN1ObjectIdentifier *)rsaSignatureWithripemd256;
+ (ASN1ObjectIdentifier *)ecSign;
+ (ASN1ObjectIdentifier *)ecSignWithSha1;
+ (ASN1ObjectIdentifier *)ecSignWithRipemd160;
+ (ASN1ObjectIdentifier *)ecc_brainpool;
+ (ASN1ObjectIdentifier *)ellipticCurve;
+ (ASN1ObjectIdentifier *)versionOne;
+ (ASN1ObjectIdentifier *)brainpoolP160r1;
+ (ASN1ObjectIdentifier *)brainpoolP160t1;
+ (ASN1ObjectIdentifier *)brainpoolP192r1;
+ (ASN1ObjectIdentifier *)brainpoolP192t1;
+ (ASN1ObjectIdentifier *)brainpoolP224r1;
+ (ASN1ObjectIdentifier *)brainpoolP224t1;
+ (ASN1ObjectIdentifier *)brainpoolP256r1;
+ (ASN1ObjectIdentifier *)brainpoolP256t1;
+ (ASN1ObjectIdentifier *)brainpoolP320r1;
+ (ASN1ObjectIdentifier *)brainpoolP320t1;
+ (ASN1ObjectIdentifier *)brainpoolP384r1;
+ (ASN1ObjectIdentifier *)brainpoolP384t1;
+ (ASN1ObjectIdentifier *)brainpoolP512r1;
+ (ASN1ObjectIdentifier *)brainpoolP512t1;

@end
