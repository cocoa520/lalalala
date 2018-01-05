//
//  OCSPResponseStatus.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Enumerated.h"

@interface OCSPResponseStatus : ASN1Object {
@private
    ASN1Enumerated *_value;
}

+ (int)SUCCESSFUL;
+ (int)MALFORMED_REQUEST;
+ (int)INTERNAL_ERROR;
+ (int)TRY_LATER;
+ (int)SIG_REQUIRED;
+ (int)UNAUTHORIZED;
+ (OCSPResponseStatus *)getInstance:(id)paramObject;
- (instancetype)initParamInt:(int)paramInt;
- (BigInteger *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
