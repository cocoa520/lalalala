//
//  DERVisibleString.h
//  crypto
//
//  Created by JGehry on 6/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1String.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface DERVisibleString : ASN1String {
@private
    NSMutableData *_string;
}

+ (DERVisibleString *)getInstance:(id)paramObject;
+ (DERVisibleString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamString:(NSString *)paramString;
- (NSString *)getString;
- (NSString *)toString;
- (NSMutableData *)getOctets;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;

@end
