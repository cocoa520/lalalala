//
//  DERApplicationSpecific.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1ApplicationSpecific.h"
#import "ASN1EncodableVector.h"

@interface DERApplicationSpecific : ASN1ApplicationSpecific

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamInt:(int)paramInt paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamInt:(int)paramInt paramASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVector;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
