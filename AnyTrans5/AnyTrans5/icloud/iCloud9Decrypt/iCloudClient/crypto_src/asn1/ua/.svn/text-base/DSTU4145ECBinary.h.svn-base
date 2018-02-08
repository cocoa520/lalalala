//
//  DSTU4145ECBinary.h
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DSTU4145BinaryField.h"
#import "ASN1Integer.h"
#import "ASN1OctetString.h"

@interface DSTU4145ECBinary : ASN1Object {
    BigInteger *_version;
    DSTU4145BinaryField *_f;
    ASN1Integer *_a;
    ASN1OctetString *_b;
    ASN1Integer *_n;
    ASN1OctetString *_bp;
}

@property (nonatomic, readwrite, retain) BigInteger *version;
@property (nonatomic, readwrite, retain) DSTU4145BinaryField *f;
@property (nonatomic, readwrite, retain) ASN1Integer *a;
@property (nonatomic, readwrite, retain) ASN1OctetString *b;
@property (nonatomic, readwrite, retain) ASN1Integer *n;
@property (nonatomic, readwrite, retain) ASN1OctetString *bp;

- (BigInteger *)version;
+ (DSTU4145ECBinary *)getInstance:(id)paramObject;
- (DSTU4145BinaryField *)getField;
- (BigInteger *)getA;
- (NSMutableData *)getB;
- (BigInteger *)getN;
- (NSMutableData *)getG;
- (ASN1Primitive *)toASN1Primitive;

@end
