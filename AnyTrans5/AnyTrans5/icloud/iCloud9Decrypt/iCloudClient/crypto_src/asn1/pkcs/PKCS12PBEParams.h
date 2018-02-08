//
//  PKCS12PBEParams.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1OctetString.h"

@interface PKCS12PBEParams : ASN1Object {
    ASN1Integer *_iterations;
    ASN1OctetString *_iv;
}

@property (nonatomic, readwrite, retain) ASN1Integer *iterations;
@property (nonatomic, readwrite, retain) ASN1OctetString *iv;

+ (PKCS12PBEParams *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (BigInteger *)getIterations;
- (NSMutableData *)getIV;
- (ASN1Primitive *)toASN1Primitive;

@end
