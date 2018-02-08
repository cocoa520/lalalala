//
//  DLSequence.h
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Sequence.h"
#import "ASN1Encodable.h"
#import "ASN1EncodableVector.h"
#import "ASN1OutputStream.h"

@interface DLSequence : ASN1Sequence {
@private
    int _bodyLength;
}

- (instancetype)init;
- (instancetype)initDLParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initDLParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (instancetype)initDLParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
