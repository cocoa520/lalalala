//
//  ASN1Enumerated.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "BigInteger.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface ASN1Enumerated : ASN1Primitive {
@private
    NSMutableData *_bytes;
}

+ (ASN1Enumerated *)getInstance:(id)paramObject;
+ (ASN1Enumerated *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (ASN1Enumerated *)fromOctetString:(NSMutableData *)paramArrayOfByte;

- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (BigInteger *)getValue;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;

@end
