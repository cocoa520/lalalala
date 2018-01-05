//
//  OtherHash.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1OctetString.h"
#import "OtherHashAlgAndValue.h"
#import "AlgorithmIdentifier.h"

@interface OtherHash : ASN1Choice {
@private
    ASN1OctetString *_sha1Hash;
    OtherHashAlgAndValue *_otherHash;
}

+ (OtherHash *)getInstance:(id)paramObject;
- (instancetype)initParamOtherHashAlgAndValue:(OtherHashAlgAndValue *)paramOtherHashAlgAndValue;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (NSMutableData *)getHashValue;
- (ASN1Primitive *)toASN1Primitive;

@end
