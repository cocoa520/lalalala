//
//  DERExternal.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1Integer.h"
#import "ASN1EncodableVector.h"
#import "DERTaggedObject.h"

@interface DERExternal : ASN1Primitive {
@private
    ASN1ObjectIdentifier *_directReference;
    ASN1Integer *_indirectReference;
    ASN1Primitive *_dataValueDescriptor;
    int _encoding;
    ASN1Primitive *_externalContent;
}

- (instancetype)initParamASN1EncodableVector:(ASN1EncodableVector *)paramASN1EncodableVecotr;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Primitive:(ASN1Primitive *)paramASN1Primitive paramDERTaggedObject:(DERTaggedObject *)paramDERTaggedObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Integer:(ASN1Integer *)paramASN1Integer paramASN1Primitive:(ASN1Primitive *)paramASN1Primitive1 paramInt:(int)paramInt paramDERTaggedObject:(ASN1Primitive *)paramASN1Primitive2;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (ASN1ObjectIdentifier *)getDirectReference;
- (ASN1Integer *)getIndirectReference;
- (ASN1Primitive *)getDataValueDescriptor;
- (int)getEncoding;
- (ASN1Primitive *)getExternalContent;

@end
