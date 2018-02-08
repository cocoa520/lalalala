//
//  ETSIQCObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ETSIQCObjectIdentifiers.h"

@implementation ETSIQCObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_etsi_qcs_QcCompliance {
    static ASN1ObjectIdentifier *_id_etsi_qcs_QcCompliance = nil;
    @synchronized(self) {
        if (!_id_etsi_qcs_QcCompliance) {
            _id_etsi_qcs_QcCompliance = [[ASN1ObjectIdentifier alloc] initParamString:@"0.4.0.1862.1.1"];
        }
    }
    return _id_etsi_qcs_QcCompliance;
}

+ (ASN1ObjectIdentifier *)id_etsi_qcs_LimiteValue {
    static ASN1ObjectIdentifier *_id_etsi_qcs_LimiteValue = nil;
    @synchronized(self) {
        if (!_id_etsi_qcs_LimiteValue) {
            _id_etsi_qcs_LimiteValue = [[ASN1ObjectIdentifier alloc] initParamString:@"0.4.0.1862.1.2"];
        }
    }
    return _id_etsi_qcs_LimiteValue;
}

+ (ASN1ObjectIdentifier *)id_etsi_qcs_RetentionPeriod {
    static ASN1ObjectIdentifier *_id_etsi_qcs_RetentionPeriod = nil;
    @synchronized(self) {
        if (!_id_etsi_qcs_RetentionPeriod) {
            _id_etsi_qcs_RetentionPeriod = [[ASN1ObjectIdentifier alloc] initParamString:@"0.4.0.1862.1.3"];
        }
    }
    return _id_etsi_qcs_RetentionPeriod;
}

+ (ASN1ObjectIdentifier *)id_etsi_qcs_QcSSCD {
    static ASN1ObjectIdentifier *_id_etsi_qcs_QcSSCD = nil;
    @synchronized(self) {
        if (!_id_etsi_qcs_QcSSCD) {
            _id_etsi_qcs_QcSSCD = [[ASN1ObjectIdentifier alloc] initParamString:@"0.4.0.1862.1.4"];
        }
    }
    return _id_etsi_qcs_QcSSCD;
}

@end
