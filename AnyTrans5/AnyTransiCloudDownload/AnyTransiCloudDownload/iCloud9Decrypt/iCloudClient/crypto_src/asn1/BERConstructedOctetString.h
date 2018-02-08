//
//  BERConstructedOctetString.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "BEROctetString.h"

@interface BERConstructedOctetString : BEROctetString {
@private
    NSMutableArray *_octsChild;
}

+ (BEROctetString *)fromSequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamVector:(NSMutableArray *)paramVector;
- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive;
- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (NSMutableData *)getOctets;
- (NSEnumerator *)getObjects;

@end
