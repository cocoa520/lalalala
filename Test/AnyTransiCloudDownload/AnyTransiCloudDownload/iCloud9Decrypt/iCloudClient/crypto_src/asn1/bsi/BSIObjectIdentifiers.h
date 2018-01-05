//
//  BSIObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface BSIObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)bsi_de;
+ (ASN1ObjectIdentifier *)id_ecc;
+ (ASN1ObjectIdentifier *)ecdsa_plain_signatures;
+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA1;
+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA224;
+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA256;
+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA384;
+ (ASN1ObjectIdentifier *)ecdsa_plain_SHA512;
+ (ASN1ObjectIdentifier *)ecdsa_plain_RIPEMD160;

@end
