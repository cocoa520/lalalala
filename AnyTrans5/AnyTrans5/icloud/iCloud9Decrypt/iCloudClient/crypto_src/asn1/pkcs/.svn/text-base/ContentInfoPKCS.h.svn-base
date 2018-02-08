//
//  ContentInfo.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKCSObjectIdentifiers.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Encodable.h"

@interface ContentInfoPKCS : PKCSObjectIdentifiers {
@private
    ASN1ObjectIdentifier *_contentType;
    ASN1Encodable *_content;
    BOOL _isBer;
}

+ (ContentInfoPKCS *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getContentType;
- (ASN1Encodable *)getContent;
- (ASN1Primitive *)toASN1Primitive;

@end
