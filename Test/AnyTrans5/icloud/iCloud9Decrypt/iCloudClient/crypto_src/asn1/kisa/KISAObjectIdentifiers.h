//
//  KISAObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface KISAObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)id_seedCBC;
+ (ASN1ObjectIdentifier *)id_seedMAC;
+ (ASN1ObjectIdentifier *)pbeWithSHA1AndSEED_CBC;
+ (ASN1ObjectIdentifier *)id_npki_app_cmsSeed_wrap;
+ (ASN1ObjectIdentifier *)id_mod_cms_seed;


@end
