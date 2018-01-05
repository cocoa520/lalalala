//
//  ISOIECObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface ISOIECObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)iso_encryption_algorithms;
+ (ASN1ObjectIdentifier *)hash_algorithms;
+ (ASN1ObjectIdentifier *)ripemd160;
+ (ASN1ObjectIdentifier *)ripemd128;
+ (ASN1ObjectIdentifier *)whirlpool;
+ (ASN1ObjectIdentifier *)is18033_2;
+ (ASN1ObjectIdentifier *)id_ac_generic_hybrid;
+ (ASN1ObjectIdentifier *)id_kem_rsa;

@end
