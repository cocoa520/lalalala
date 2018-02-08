//
//  OriginatorInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Set.h"

@interface OriginatorInfo : ASN1Object {
@private
    ASN1Set *_certs;
    ASN1Set *_crls;
}

+ (OriginatorInfo *)getInstance:(id)paramObject;
+ (OriginatorInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Set1:(ASN1Set *)paramASN1Set1 paramASN1Set2:(ASN1Set *)paramASN1Set2;
- (ASN1Set *)getCertificates;
- (ASN1Set *)getCRLs;
- (ASN1Primitive *)toASN1Primitive;

@end
