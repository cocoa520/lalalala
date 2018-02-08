//
//  IssuerSerial.h
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1TaggedObject.h"
#import "GeneralNames.h"
#import "ASN1Integer.h"
#import "DERBitString.h"
#import "X500Name.h"

@interface IssuerSerial : ASN1Object {
    GeneralNames *_issuer;
    ASN1Integer *_serial;
    DERBitString *_issuerUID;
}

@property (nonatomic, readwrite, retain) GeneralNames *issuer;
@property (nonatomic, readwrite, retain) ASN1Integer *serial;
@property (nonatomic, readwrite, retain) DERBitString *issuerUID;

+ (IssuerSerial *)getInstance:(id)paramObject;
+ (IssuerSerial *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamX500Name:(X500Name *)paramX500Name paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramASN1Integer:(ASN1Integer *)paramASN1Integer;
- (GeneralNames *)getIssuer;
- (ASN1Integer *)getSerial;
- (DERBitString *)getIssuerUID;
- (ASN1Primitive *)toASN1Primitive;

@end
