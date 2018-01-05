//
//  SigIObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface SigIObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)id_sigi;
+ (ASN1ObjectIdentifier *)id_sigi_kp;
+ (ASN1ObjectIdentifier *)id_sigi_cp;
+ (ASN1ObjectIdentifier *)id_sigi_on;
+ (ASN1ObjectIdentifier *)id_sigi_kp_directoryService;
+ (ASN1ObjectIdentifier *)id_sigi_on_personalData;
+ (ASN1ObjectIdentifier *)id_sigi_cp_sigconform;

@end
