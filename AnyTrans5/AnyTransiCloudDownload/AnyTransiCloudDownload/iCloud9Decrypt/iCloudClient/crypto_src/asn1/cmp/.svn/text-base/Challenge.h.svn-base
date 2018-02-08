//
//  Challenge.h
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "AlgorithmIdentifier.h"
#import "ASN1OctetString.h"

@interface Challenge : ASN1Object {
@private
    AlgorithmIdentifier *_owf;
    ASN1OctetString *_witness;
    ASN1OctetString *_challenge;
}

+ (Challenge *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte1:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2;
- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte1:(NSMutableData *)paramArrayOfByte1 paramArrayOfByte2:(NSMutableData *)paramArrayOfByte2;
- (AlgorithmIdentifier *)getOwf;
- (NSMutableData *)getWitness;
- (NSMutableData *)getChallenge;
- (ASN1Primitive *)toASN1Primitive;

@end
