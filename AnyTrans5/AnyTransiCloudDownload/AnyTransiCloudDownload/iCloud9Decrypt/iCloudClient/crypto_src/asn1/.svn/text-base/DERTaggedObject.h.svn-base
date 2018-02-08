//
//  DERTaggedObject.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface DERTaggedObject : ASN1TaggedObject

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
