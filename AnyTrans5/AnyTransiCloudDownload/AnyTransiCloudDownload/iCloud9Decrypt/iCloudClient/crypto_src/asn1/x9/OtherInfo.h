//
//  OtherInfo.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "KeySpecificInfo.h"

@interface OtherInfo : ASN1Object {
@private
    KeySpecificInfo *_keyInfo;
    ASN1OctetString *_partyAInfo;
    ASN1OctetString *_suppPubInfo;
}

+ (OtherInfo *)getInstance:(id)paramObject;
- (instancetype)initParamKeySpecificInfo:(KeySpecificInfo *)paramKeySpecificInfo paramASN1OctetString1:(ASN1OctetString *)paramASN1OctetString1 paramASN1OctetString2:(ASN1OctetString *)paramASN1OctetString2;
- (KeySpecificInfo *)getKeyInfo;
- (ASN1OctetString *)getPartyAInfo;
- (ASN1OctetString *)getSuppPubInfo;
- (ASN1Primitive *)toASN1Primitive;

@end
