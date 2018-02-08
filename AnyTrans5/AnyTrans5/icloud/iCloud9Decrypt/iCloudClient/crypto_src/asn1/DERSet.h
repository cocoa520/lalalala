//
//  DERSet.h
//  crypto
//
//  Created by JGehry on 6/2/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Set.h"
#import "ASN1OutputStream.h"

@interface DERSet : ASN1Set {
@private
    int _bodyLength;
}

- (instancetype)init;
- (instancetype)initDERParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initDERParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (instancetype)initDERParamArrayOfASN1Encodable:(NSMutableArray *)paramArrayOfASN1Encodable;
- (instancetype)initDERParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector paramBoolean:(BOOL)paramBoolean;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
