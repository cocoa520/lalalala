//
//  CertHash.h
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"

@interface CertHash : ASN1Object {
@private
    AlgorithmIdentifier *_hashAlgorithm;
    NSMutableData *_certificateHash;
}

+ (CertHash *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (NSMutableData *)getCertificateHash;
- (ASN1Primitive *)toASN1Primitive;

@end