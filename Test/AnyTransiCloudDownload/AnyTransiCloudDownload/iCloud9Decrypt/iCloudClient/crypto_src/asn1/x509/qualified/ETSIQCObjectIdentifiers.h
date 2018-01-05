//
//  ETSIQCObjectIdentifiers.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"

@interface ETSIQCObjectIdentifiers : NSObject

+ (ASN1ObjectIdentifier *)id_etsi_qcs_QcCompliance;
+ (ASN1ObjectIdentifier *)id_etsi_qcs_LimiteValue;
+ (ASN1ObjectIdentifier *)id_etsi_qcs_RetentionPeriod;
+ (ASN1ObjectIdentifier *)id_etsi_qcs_QcSSCD;

@end
