//
//  SafeBag.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"
#import "ASN1Set.h"

@interface SafeBag : ASN1Object {
@private
    ASN1ObjectIdentifier *_bagId;
    ASN1Encodable *_bagValue;
    ASN1Set *_bagAttributes;
}

+ (SafeBag *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable paramASN1Set:(ASN1Set *)paramASN1Set;
- (ASN1ObjectIdentifier *)getBagId;
- (ASN1Encodable *)getBagValue;
- (ASN1Set *)getBagAttributes;
- (ASN1Primitive *)toASN1Primitive;

@end
