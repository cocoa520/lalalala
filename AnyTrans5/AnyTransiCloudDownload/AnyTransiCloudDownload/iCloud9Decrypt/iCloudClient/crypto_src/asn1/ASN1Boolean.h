//
//  ASN1Boolean.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface ASN1Boolean : ASN1Primitive {
@private
    NSMutableData *_value;
}

+ (ASN1Boolean *)FALSEALLOC;
+ (ASN1Boolean *)TRUEALLOC;
+ (ASN1Boolean *)getInstanceObject:(id)paramObject;
+ (ASN1Boolean *)getInstanceBoolean:(BOOL)paramBoolean;
+ (ASN1Boolean *)getInstanceInt:(int)paramInt;
+ (ASN1Boolean *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (ASN1Boolean *)fromOctetString:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamBoolean:(BOOL)paramBoolean;
- (BOOL)isTrue;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (NSString *)toString;

@end
