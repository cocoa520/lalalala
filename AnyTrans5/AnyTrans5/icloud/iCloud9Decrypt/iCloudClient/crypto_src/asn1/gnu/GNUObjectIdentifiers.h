//
//  GNUObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface GNUObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)GNU;
+ (ASN1ObjectIdentifier *)GnuPG;
+ (ASN1ObjectIdentifier *)notation;
+ (ASN1ObjectIdentifier *)pkaAddress;
+ (ASN1ObjectIdentifier *)GnuRadar;
+ (ASN1ObjectIdentifier *)digestAlgorithm;
+ (ASN1ObjectIdentifier *)Tiger_192;
+ (ASN1ObjectIdentifier *)encryptionAlgorithm;
+ (ASN1ObjectIdentifier *)Serpent;
+ (ASN1ObjectIdentifier *)Serpent_128_ECB;
+ (ASN1ObjectIdentifier *)Serpent_128_CBC;
+ (ASN1ObjectIdentifier *)Serpent_128_OFB;
+ (ASN1ObjectIdentifier *)Serpent_128_CFB;
+ (ASN1ObjectIdentifier *)Serpent_192_ECB;
+ (ASN1ObjectIdentifier *)Serpent_192_CBC;
+ (ASN1ObjectIdentifier *)Serpent_192_OFB;
+ (ASN1ObjectIdentifier *)Serpent_192_CFB;
+ (ASN1ObjectIdentifier *)Serpent_256_ECB;
+ (ASN1ObjectIdentifier *)Serpent_256_CBC;
+ (ASN1ObjectIdentifier *)Serpent_256_OFB;
+ (ASN1ObjectIdentifier *)Serpent_256_CFB;
+ (ASN1ObjectIdentifier *)CRC;
+ (ASN1ObjectIdentifier *)CRC32;

@end
