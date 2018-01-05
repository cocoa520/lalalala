//
//  CompleteRevocationRefs.h
//  crypto
//
//  Created by JGehry on 7/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1Sequence.h"

@interface CompleteRevocationRefs : ASN1Object {
@private
    ASN1Sequence *_crlOcspRefs;
}

+ (CompleteRevocationRefs *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfCrlOcspRef:(NSMutableArray *)paramArrayOfCrlOcspRef;
- (NSMutableArray *)getCrlOcspRefs;
- (ASN1Primitive *)toASN1Primitive;

@end
