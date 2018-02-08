//
//  RevokedInfo.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1GeneralizedTime.h"
#import "CRLReason.h"

@interface RevokedInfo : ASN1Object {
@private
    ASN1GeneralizedTime *_revocationTime;
    CRLReason *_revocationReason;
}

+ (RevokedInfo *)getInstance:(id)paramObject;
+ (RevokedInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramCRLReason:(CRLReason *)paramCRLReason;
- (ASN1GeneralizedTime *)getRevocationTime;
- (CRLReason *)getRevocationReason;
- (ASN1Primitive *)toASN1Primitive;

@end
