//
//  OtherRecipientInfo.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface OtherRecipientInfo : ASN1Object {
@private
    ASN1ObjectIdentifier *_oriType;
    ASN1Encodable *_oriValue;
}

+ (OtherRecipientInfo *)getInstance:(id)paramObject;
+ (OtherRecipientInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getType;
- (ASN1Encodable *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
