//
//  OtherRevVals.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface OtherRevVals : ASN1Object {
@private
    ASN1ObjectIdentifier *_otherRevValType;
    ASN1Encodable *_otherRevVals;
}

+ (OtherRevVals *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getOtherRevValType;
- (ASN1Encodable *)getOtherRevVals;
- (ASN1Primitive *)toASN1Primitive;

@end
