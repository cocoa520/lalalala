//
//  Holder.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "IssuerSerial.h"
#import "GeneralNames.h"
#import "ObjectDigestInfo.h"

@interface Holder : ASN1Object {
@private
    int _version;
@public
    IssuerSerial *_baseCertificateID;
    GeneralNames *_entityName;
    ObjectDigestInfo *_objectDigestInfo;
}

@property (nonatomic, readwrite, retain) IssuerSerial *baseCertificateID;
@property (nonatomic, readwrite, retain) GeneralNames *entityName;
@property (nonatomic, readwrite, retain) ObjectDigestInfo *objectDigestInfo;

+ (int)V1_CERTIFICATE_HOLDER;
+ (int)V2_CERTIFICATE_HOLDER;
+ (Holder *)getInstance:(id)paramObject;
- (instancetype)initParamIssuerSerial:(IssuerSerial *)paramIssuerSerial;
- (instancetype)initParamIssuerSerial:(IssuerSerial *)paramIssuerSerial paramInt:(int)paramInt;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramInt:(int)paramInt;
- (instancetype)initParamObjectDigestInfo:(ObjectDigestInfo *)paramObjectDigestInfo;
- (int)getVersion;
- (IssuerSerial *)getBaseCertificateID;
- (GeneralNames *)getEntityName;
- (ObjectDigestInfo *)getObjectDigestInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
