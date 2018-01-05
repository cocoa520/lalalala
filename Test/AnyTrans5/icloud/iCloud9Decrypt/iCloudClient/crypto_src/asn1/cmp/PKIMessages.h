//
//  PKIMessages.h
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface PKIMessages : ASN1Object {
@private
    ASN1Sequence *_content;
}

+ (PKIMessages *)getInstance:(id)paramObject;
- (instancetype)initParamPKIMessage:(PKIMessages *)paramPKIMessage;
- (instancetype)initParamArrayOfPKIMessage:(NSMutableArray *)paramArrayOfPKIMessage;
- (NSMutableArray *)toPKIMessageArray;
- (ASN1Primitive *)toASN1Primitive;

@end
