//
//  DERSequence.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Sequence.h"
#import "ASN1EncodableVector.h"
#import "ASN1OutputStream.h"

@interface DERSequence : ASN1Sequence {
@private
    int                                                 _bodyLength;
}

- (instancetype)initDERParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initDERParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (instancetype)initDERparamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
