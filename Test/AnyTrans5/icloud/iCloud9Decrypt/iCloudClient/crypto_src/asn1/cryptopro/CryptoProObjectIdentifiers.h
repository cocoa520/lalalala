//
//  CryptoProObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface CryptoProObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)GOST_id;
+ (ASN1ObjectIdentifier *)gostR3411;
+ (ASN1ObjectIdentifier *)gostR3411Hmac;
+ (ASN1ObjectIdentifier *)gostR28147_Cbc;
+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_A_ParamSet;
+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_B_ParamSet;
+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_C_ParamSet;
+ (ASN1ObjectIdentifier *)id_Gost28147_89_CryptoPro_D_ParamSet;
+ (ASN1ObjectIdentifier *)gostR3410_94;
+ (ASN1ObjectIdentifier *)gostR3410_2001;
+ (ASN1ObjectIdentifier *)gostR3411_94_with_gostR3410_94;
+ (ASN1ObjectIdentifier *)gostR3411_94_with_gostR3410_2001;
+ (ASN1ObjectIdentifier *)gostR3411_94_CryptoProParamSet;
+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_A;
+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_B;
+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_C;
+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_D;
+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_XchA;
+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_XchB;
+ (ASN1ObjectIdentifier *)gostR3410_94_CryptoPro_XchC;
+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_A;
+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_B;
+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_C;
+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_XchA;
+ (ASN1ObjectIdentifier *)gostR3410_2001_CryptoPro_XchB;
+ (ASN1ObjectIdentifier *)gost_ElSgDH3410_default;
+ (ASN1ObjectIdentifier *)gost_ElSgDH3410_1;

@end
