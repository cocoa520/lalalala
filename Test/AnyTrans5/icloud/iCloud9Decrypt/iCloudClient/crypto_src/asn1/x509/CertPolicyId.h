//
//  CertPolicyId.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"

@interface CertPolicyId : ASN1Object {
@private
    ASN1ObjectIdentifier *_id;
}

+ (CertPolicyId *)getInstance:(id)paramObject;
- (NSString *)getId;
- (ASN1Primitive *)toASN1Primitive;

@end
