//
//  DERUTF8String.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1String.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface DERUTF8String : ASN1String {
@private
    NSMutableData *_string;
}

+ (DERUTF8String *)getInstance:(id)paramObject;
+ (DERUTF8String *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamString:(NSString *)paramString;
- (NSString *)getString;
- (NSString *)toString;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
