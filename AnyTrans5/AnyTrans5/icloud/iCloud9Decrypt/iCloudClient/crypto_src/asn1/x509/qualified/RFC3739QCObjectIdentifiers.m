//
//  RFC3739QCObjectIdentifiers.m
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RFC3739QCObjectIdentifiers.h"

@implementation RFC3739QCObjectIdentifiers

+ (ASN1ObjectIdentifier *)id_qcs_pkixQCSyntax_v1 {
    static ASN1ObjectIdentifier *_id_qcs_pkixQCSyntax_v1 = nil;
    @synchronized(self) {
        if (!_id_qcs_pkixQCSyntax_v1) {
            _id_qcs_pkixQCSyntax_v1 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.11.1"];
        }
    }
    return _id_qcs_pkixQCSyntax_v1;
}

+ (ASN1ObjectIdentifier *)id_qcs_pkixQCSyntax_v2 {
    static ASN1ObjectIdentifier *_id_qcs_pkixQCSyntax_v2 = nil;
    @synchronized(self) {
        if (!_id_qcs_pkixQCSyntax_v2) {
            _id_qcs_pkixQCSyntax_v2 = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.11.2"];
        }
    }
    return _id_qcs_pkixQCSyntax_v2;
}

@end
