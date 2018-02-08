//
//  ContentInfo.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CMSObjectIdentifiers.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"

@interface ContentInfo : CMSObjectIdentifiers {
@private
    ASN1ObjectIdentifier *_contentType;
    ASN1Encodable *_content;
}

+ (ContentInfo *)getInstance:(id)paramObject;
+ (ContentInfo *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getContentType;
- (ASN1Encodable *)getContent;
- (ASN1Primitive *)toASN1Primitive;

@end
