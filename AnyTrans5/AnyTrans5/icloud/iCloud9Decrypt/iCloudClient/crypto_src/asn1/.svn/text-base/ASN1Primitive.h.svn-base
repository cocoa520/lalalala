//
//  ASN1Primitive.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"

@class ASN1OutputStream;

@interface ASN1Primitive : ASN1Object

- (ASN1Primitive *)toDERObject;
- (ASN1Primitive *)toDLObject;
+ (ASN1Primitive *)fromByteArray:(NSMutableData *)paramArrayOfByte;
- (ASN1Primitive *)toASN1Primitive;

- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;

@end
