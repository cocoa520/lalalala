//
//  ASN1ObjectIdentifier.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Primitive.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface ASN1ObjectIdentifier : ASN1Primitive {
@private
    NSString *_identifier;
    NSMutableData *_body;
}

+ (ASN1ObjectIdentifier *)getInstance:(id)paramObject;
+ (ASN1ObjectIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (ASN1ObjectIdentifier *)fromOctetString:(NSMutableData *)paramArrayOfByte;

- (instancetype)initParamOfByte:(NSMutableData *)paramOfByte;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString;
- (NSString *)getId;
- (ASN1ObjectIdentifier *)branch:(NSString *)paramString;
- (BOOL)on:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (NSString *)toString;
- (ASN1ObjectIdentifier *)intern;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (NSString *)identifier;

@end

@interface OidHandle : ASN1Object {
@private
    int _key;
    NSMutableData *_enc;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (int)hashCode;

@end
