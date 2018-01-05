//
//  NTTObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface NTTObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)id_camellia128_cbc;
+ (ASN1ObjectIdentifier *)id_camellia192_cbc;
+ (ASN1ObjectIdentifier *)id_camellia256_cbc;
+ (ASN1ObjectIdentifier *)id_camellia128_wrap;
+ (ASN1ObjectIdentifier *)id_camellia192_wrap;
+ (ASN1ObjectIdentifier *)id_camellia256_wrap;

@end
