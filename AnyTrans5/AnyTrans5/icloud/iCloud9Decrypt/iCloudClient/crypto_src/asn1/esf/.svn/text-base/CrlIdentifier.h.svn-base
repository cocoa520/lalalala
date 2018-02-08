//
//  CrlIdentifier.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "X500Name.h"
#import "ASN1UTCTime.h"
#import "ASN1Integer.h"

@interface CrlIdentifier : ASN1Object {
@private
    X500Name *_crlIssuer;
    ASN1UTCTime *_crlIssuedTime;
    ASN1Integer *_crlNumber;
}

+ (CrlIdentifier *)getInstance:(id)paramObject;
- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime;
- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramASN1UTCTime:(ASN1UTCTime *)paramASN1UTCTime paramBigInteger:(BigInteger *)paramBigInteger;
- (X500Name *)getCrlIssuer;
- (ASN1UTCTime *)getCrlIssuedTime;
- (BigInteger *)getCrlNumber;
- (ASN1Primitive *)toASN1Primitive;

@end
