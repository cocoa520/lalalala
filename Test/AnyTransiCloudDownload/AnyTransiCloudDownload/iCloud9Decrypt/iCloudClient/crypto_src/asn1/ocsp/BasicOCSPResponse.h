//
//  BasicOCSPResponse.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ResponseData.h"
#import "AlgorithmIdentifier.h"
#import "DERBitString.h"
#import "ASN1Sequence.h"
#import "ASN1TaggedObject.h"

@interface BasicOCSPResponse : ASN1Object {
@private
    ResponseData *_tbsResponseData;
    AlgorithmIdentifier *_signatureAlgorithm;
    DERBitString *_signature;
    ASN1Sequence *_certs;
}

+ (BasicOCSPResponse *)getInstance:(id)paramObject;
+ (BasicOCSPResponse *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamResponseData:(ResponseData *)paramResponseData paramAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramDERBitString:(DERBitString *)paramDERBitString paramASN1Sequence:(ASN1Sequence  *)paramASN1Sequence;
- (ResponseData *)getTbsResponseData;
- (AlgorithmIdentifier *)getSignatureAlgorithm;
- (DERBitString *)getSignature;

@end
