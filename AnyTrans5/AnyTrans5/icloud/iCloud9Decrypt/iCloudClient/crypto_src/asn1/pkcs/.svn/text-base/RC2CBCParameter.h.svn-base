//
//  RC2CBCParameter.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Integer.h"
#import "ASN1OctetString.h"

@interface RC2CBCParameter : ASN1Object {
    ASN1Integer *_version;
    ASN1OctetString *_iv;
}

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) ASN1OctetString *iv;

+ (RC2CBCParameter *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (BigInteger *)getRC2ParameterVersion;
- (NSMutableData *)getIV;
- (ASN1Primitive *)toASN1Primitive;

@end
