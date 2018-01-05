//
//  DVCSObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface DVCSObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)id_pkix;
+ (ASN1ObjectIdentifier *)id_smime;
+ (ASN1ObjectIdentifier *)id_ad_dvcs;
+ (ASN1ObjectIdentifier *)id_kp_dvcs;
+ (ASN1ObjectIdentifier *)id_ct_DVCSRequestData;
+ (ASN1ObjectIdentifier *)id_ct_DVCSResponseData;
+ (ASN1ObjectIdentifier *)id_aa_dvcs_dvc;

@end
