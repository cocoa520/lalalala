//
//  CertIdCRMF.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "GeneralName.h"
#import "ASN1Integer.h"

@interface CertIdCRMF : ASN1Object {
@private
    GeneralName *_issuer;
    ASN1Integer *_serialNumber;
}

+ (CertIdCRMF *)getInstance:(id)paramObject;
+ (CertIdCRMF *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName paramASN1Integer:(ASN1Integer *)paramASN1Integer;
- (GeneralName *)getIssuer;
- (ASN1Integer *)getSerialNumber;
- (ASN1Primitive *)toASN1Primitive;

@end
