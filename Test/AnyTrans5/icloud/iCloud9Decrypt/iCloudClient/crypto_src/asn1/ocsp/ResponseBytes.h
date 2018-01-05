//
//  ResponseBytes.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1OctetString.h"

@interface ResponseBytes : ASN1Object {
    ASN1ObjectIdentifier *_responseType;
    ASN1OctetString *_response;
}

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *responseType;
@property (nonatomic, readwrite, retain) ASN1OctetString *response;

+ (ResponseBytes *)getInstance:(id)paramObject;
+ (ResponseBytes *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1ObjectIdentifier *)getResponseType;
- (ASN1OctetString *)getResponse;
- (ASN1Primitive *)toASN1Primitive;

@end
