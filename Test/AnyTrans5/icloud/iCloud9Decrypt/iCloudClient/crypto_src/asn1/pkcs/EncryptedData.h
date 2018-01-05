//
//  EncryptedData.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Primitive.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"

@interface EncryptedData : ASN1Object {
    ASN1Sequence *_data;
    ASN1ObjectIdentifier *_bagId;
    ASN1Primitive *_bagValue;
}

@property (nonatomic, readwrite, retain) ASN1Sequence *data;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *bagId;
@property (nonatomic, readwrite, retain) ASN1Primitive *bagValue;

+ (EncryptedData *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (ASN1ObjectIdentifier *)getContentType;
- (AlgorithmIdentifier *)getEncryptionAlgorithm;
- (ASN1OctetString *)getContent;
- (ASN1Primitive *)toASN1Primitive;

@end
