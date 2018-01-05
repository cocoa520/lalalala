//
//  ContentHints.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERUTF8String.h"
#import "ASN1ObjectIdentifier.h"

@interface ContentHints : ASN1Object {
@private
    DERUTF8String *_contentDescription;
    ASN1ObjectIdentifier *_contentType;
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramDERUTF8String:(DERUTF8String *)paramDERUTF8String;
- (ASN1ObjectIdentifier *)getContentType;
- (DERUTF8String *)getContentDescription;
- (ASN1Primitive *)toASN1Primitive;

@end
