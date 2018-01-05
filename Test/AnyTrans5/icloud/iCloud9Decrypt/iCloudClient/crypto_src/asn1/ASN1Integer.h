//
//  ASN1Integer.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "BigInteger.h"
#import "ASN1OutputStream.h"
#import "ASN1TaggedObject.h"

@interface ASN1Integer : ASN1Primitive {
    NSMutableData *_bytes;
}

@property (nonatomic, readwrite, retain) NSMutableData *bytes;

+ (ASN1Integer *)getInstance:(id)paramObject;
+ (ASN1Integer *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;

- (instancetype)initLong:(long)paramLong;
- (instancetype)initBI:(BigInteger *)paramBigInteger;
- (instancetype)initAOB:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfByte:(NSMutableData *)bytes paramBoolean:(Boolean)paramBoolean;
- (BigInteger *)getValue;
- (BigInteger *)getPositiveValue;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (NSString *)toString;

@end
