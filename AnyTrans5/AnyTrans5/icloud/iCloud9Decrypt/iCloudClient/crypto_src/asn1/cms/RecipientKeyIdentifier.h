//
//  RecipientKeyIdentifier.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1OctetString.h"
#import "ASN1GeneralizedTime.h"
#import "OtherKeyAttribute.h"
#import "ASN1Sequence.h"

@interface RecipientKeyIdentifier : ASN1Object {
@private
    ASN1OctetString *_subjectKeyIdentifier;
    ASN1GeneralizedTime *_date;
    OtherKeyAttribute *_other;
}

+ (RecipientKeyIdentifier *)getInstance:(id)paramObject;
+ (RecipientKeyIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramOtherKeyAttribute:(OtherKeyAttribute *)paramOtherKeyAttribute;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramOtherKeyAttribute:(OtherKeyAttribute *)paramOtherKeyAttribute;
- (ASN1OctetString *)getSubjectKeyIdentifier;
- (ASN1GeneralizedTime *)getDate;
- (OtherKeyAttribute *)getOtherKeyAttribute;
- (ASN1Primitive *)toASN1Primitive;

@end
