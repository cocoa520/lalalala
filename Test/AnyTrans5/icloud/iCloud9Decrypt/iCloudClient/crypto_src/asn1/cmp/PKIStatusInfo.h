//
//  PKIStatusInfo.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "PKIFreeText.h"
#import "DERBitString.h"
#import "ASN1TaggedObject.h"
#import "PKIStatus.h"
#import "PKIFailureInfo.h"

@interface PKIStatusInfo : ASN1Object {
    ASN1Integer *_status;
    PKIFreeText *_statusString;
    DERBitString *_failInfo;
}

@property (nonatomic, readwrite, retain) ASN1Integer *status;
@property (nonatomic, readwrite, retain) PKIFreeText *statusString;
@property (nonatomic, readwrite, retain) DERBitString *failInfo;

+ (PKIStatusInfo *)getInstance:(id)paramObject;
+ (PKIStatusInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamPKIStatus:(PKIStatus *)paramPKIStatus;
- (instancetype)initParamPKIStatus:(PKIStatus *)paramPKIStatus paramPKIFreeText:(PKIFreeText *)paramPKIFreeText;
- (instancetype)initParamPKIStatus:(PKIStatus *)paramPKIStatus paramPKIFreeText:(PKIFreeText *)paramPKIFreeText paramPKIFailureInfo:(PKIFailureInfo *)paramPKIFailureInfo;
- (BigInteger *)getStatus;
- (PKIFreeText *)getStatusString;
- (DERBitString *)getFailInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
