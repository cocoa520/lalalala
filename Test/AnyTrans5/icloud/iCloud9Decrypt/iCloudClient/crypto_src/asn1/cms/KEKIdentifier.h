//
//  KEKIdentifier.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1OctetString.h"
#import "ASN1GeneralizedTime.h"
#import "OtherKeyAttribute.h"

@interface KEKIdentifier : ASN1Object {
@private
    ASN1OctetString *_keyIdentifier;
    ASN1GeneralizedTime *_date;
    OtherKeyAttribute *_other;
}

+ (KEKIdentifier *)getInstance:(id)paramObject;
+ (KEKIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramASN1GeneralizedTime:(ASN1GeneralizedTime *)paramASN1GeneralizedTime paramOtherKeyAttribute:(OtherKeyAttribute *)paramOtherKeyAttribute;
- (ASN1OctetString *)getKeyIdentifier;
- (ASN1GeneralizedTime *)getDate;
- (OtherKeyAttribute *)getOther;
- (ASN1Primitive *)toASN1Primitive;

@end
