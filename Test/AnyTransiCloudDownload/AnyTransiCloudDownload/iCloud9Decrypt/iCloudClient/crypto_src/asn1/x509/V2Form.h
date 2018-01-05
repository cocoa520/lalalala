//
//  V2Form.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "GeneralNames.h"
#import "IssuerSerial.h"
#import "ObjectDigestInfo.h"

@interface V2Form : ASN1Object {
    GeneralNames *_issuerName;
    IssuerSerial *_baseCertificateID;
    ObjectDigestInfo *_objectDigestInfo;
}

@property (nonatomic, readwrite, retain) GeneralNames *issuerName;
@property (nonatomic, readwrite, retain) IssuerSerial *baseCertificateID;
@property (nonatomic, readwrite, retain) ObjectDigestInfo *objectDigestInfo;

+ (V2Form *)getInstance:(id)paramObject;
+ (V2Form *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramIssuerSerial:(IssuerSerial *)paramIssuerSerial;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramObjectDigestInfo:(ObjectDigestInfo *)paramObjectDigestInfo;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramIssuerSerial:(IssuerSerial *)paramIssuerSerial paramObjectDigestInfo:(ObjectDigestInfo *)paramObjectDigestInfo;
- (GeneralNames *)getIssuerName;
- (IssuerSerial *)getBaseCertificateID;
- (ObjectDigestInfo *)getObjectDigestInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
