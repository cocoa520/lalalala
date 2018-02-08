//
//  EncryptedPrivateKeyInfo.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"

@interface EncryptedPrivateKeyInfo : ASN1Object {
@private
    AlgorithmIdentifier *_algId;
    ASN1OctetString *_data;
}

+ (EncryptedPrivateKeyInfo *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (AlgorithmIdentifier *)getEncryptionAlgorithm;
- (NSMutableData *)getEncrypteData;
- (ASN1Primitive *)toASN1Primitive;

@end
