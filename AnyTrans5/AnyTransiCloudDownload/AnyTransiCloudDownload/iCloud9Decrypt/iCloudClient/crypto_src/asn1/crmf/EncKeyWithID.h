//
//  EncKeyWithID.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PrivateKeyInfo.h"
#import "ASN1Encodable.h"
#import "DERUTF8String.h"
#import "GeneralName.h"

@interface EncKeyWithID : ASN1Object {
@private
    PrivateKeyInfo *_privKeyInfo;
    ASN1Encodable *_identifier;
}

+ (EncKeyWithID *)getInstance:(id)paramObject;
- (instancetype)initParamPrivateKeyInfo:(PrivateKeyInfo *)paramPrivateKeyInfo;
- (instancetype)initParamPrivateKeyInfo:(PrivateKeyInfo *)paramPrivateKeyInfo paramDERUTF8String:(DERUTF8String *)paramDERUTF8String;
- (instancetype)initParamPrivateKeyInfo:(PrivateKeyInfo *)paramPrivateKeyInfo paramGeneralName:(GeneralName *)paramGeneralName;
- (PrivateKeyInfo *)getPrivatekey;
- (BOOL)hasIdentifier;
- (BOOL)isIdentifierUTF8String;
- (ASN1Encodable *)getIdentifier;
- (ASN1Primitive *)toASN1Primitive;

@end
