//
//  IssuerAndSerialNumber.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "X500Name.h"
#import "X509Name.h"
#import "ASN1Integer.h"

@interface IssuerAndSerialNumber : ASN1Object {
    X500Name *_name;
    ASN1Integer *_certSerialNumber;
}

@property (nonatomic, readwrite, retain) X500Name *name;
@property (nonatomic, readwrite, retain) ASN1Integer *certSerialNumber;

+ (IssuerAndSerialNumber *)getInstance:(id)paramObject;
- (instancetype)initParamX509Name:(X509Name *)paramX509Name paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamX509Name:(X509Name *)paramX509Name paramASN1Integer:(ASN1Integer *)paramASN1Integer;
- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramBigInteger:(BigInteger *)paramBigInteger;
- (X500Name *)getName;
- (ASN1Integer *)getCertificateSerialNumber;
- (ASN1Primitive *)toASN1Primitive;

@end
