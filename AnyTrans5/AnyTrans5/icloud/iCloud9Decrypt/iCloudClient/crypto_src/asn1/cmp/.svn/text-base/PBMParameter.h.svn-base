//
//  PBMParameter.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "AlgorithmIdentifier.h"
#import "ASN1Integer.h"
#import "AlgorithmIdentifier.h"

@interface PBMParameter : ASN1Object {
@private
    ASN1OctetString *_salt;
    AlgorithmIdentifier *_owf;
    ASN1Integer *_iterationCount;
    AlgorithmIdentifier *_mac;
}

+ (PBMParameter *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramInt:(int)paramInt paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString paramAlgorithmIdentifier1:(AlgorithmIdentifier *)paramAlgorithmIdentifier1 paramASN1Integer:(ASN1Integer *)paramASN1Integer paramAlgorithmIdentifier2:(AlgorithmIdentifier *)paramAlgorithmIdentifier2;
- (ASN1OctetString *)getSalt;
- (AlgorithmIdentifier *)getOwf;
- (ASN1Integer *)getIterationCount;
- (AlgorithmIdentifier *)getMac;
- (ASN1Primitive *)toASN1Primitive;

@end
