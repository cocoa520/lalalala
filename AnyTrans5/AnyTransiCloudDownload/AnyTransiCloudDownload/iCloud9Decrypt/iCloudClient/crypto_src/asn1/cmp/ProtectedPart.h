//
//  ProtectedPart.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "PKIHeader.h"
#import "PKIBody.h"

@interface ProtectedPart : ASN1Object {
@private
    PKIHeader *_header;
    PKIBody *_body;
}

+ (ProtectedPart *)getInstance:(id)paramObject;
- (instancetype)initParamPKIHeader:(PKIHeader *)paramPKIHeader paramPKIBody:(PKIBody *)paramPKIBody;
- (PKIHeader *)getHeader;
- (PKIBody *)getBody;
- (ASN1Primitive *)toASN1Primitive;

@end
