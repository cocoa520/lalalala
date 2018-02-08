//
//  GOST28147Parameters.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Sequence.h"

@interface GOST28147Parameters : ASN1Object {
@private
    ASN1OctetString *_iv;
    ASN1ObjectIdentifier *_paramSet;
}

+ (GOST28147Parameters *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (GOST28147Parameters *)getInstance:(id)paramObject;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (ASN1Primitive *)toASN1Primitive;
- (ASN1ObjectIdentifier *)getEncryptionParamSet;
- (NSMutableData *)getIV;

@end
