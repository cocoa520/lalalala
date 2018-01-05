//
//  POPOSigningKey.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "POPOSigningKeyInput.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1TaggedObject.h"

@interface POPOSigningKey : ASN1Object {
@private
    POPOSigningKeyInput *_poposkInput;
    AlgorithmIdentifier *_algorithmIdentifier;
    DERBitString *_signature;
}

+ (POPOSigningKey *)getInstance:(id)paramObject;
+ (POPOSigningKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamPOPOSigningKeyInput:(POPOSigningKeyInput *)paramPOPOSigningKeyInput paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString;
- (POPOSigningKeyInput *)getPoposkInput;
- (AlgorithmIdentifier *)getAlgorithmIdentifier;
- (DERBitString *)getSignature;
- (ASN1Primitive *)toASN1Primitive;

@end
