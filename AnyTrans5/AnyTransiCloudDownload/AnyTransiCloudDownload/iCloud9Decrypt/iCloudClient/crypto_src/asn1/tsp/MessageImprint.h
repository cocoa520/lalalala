//
//  MessageImprint.h
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"

@interface MessageImprint : ASN1Object {
    AlgorithmIdentifier *_hashAlgorithm;
    NSMutableData *_hashedMessage;
}

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) NSMutableData *hashedMessage;

+ (MessageImprint *)getInstance:(id)paramObject;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (AlgorithmIdentifier *)getHashAlgorithm;
- (NSMutableData *)getHashedMessage;
- (ASN1Primitive *)toASN1Primitive;

@end
