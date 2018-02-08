//
//  PBEParameter.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1OctetString.h"

@interface PBEParameter : ASN1Object {
    ASN1Integer *_iterations;
    ASN1OctetString *_salt;
}

@property (nonatomic, readwrite, retain) ASN1Integer *iterations;
@property (nonatomic, readwrite, retain) ASN1OctetString *salt;

+ (PBEParameter *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (BigInteger *)getIterationCount;
- (NSMutableData *)getSalt;
- (ASN1Primitive *)toASN1Primitive;

@end
