//
//  DERUniversalString.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1String.h"
#import "ASN1TaggedObject.h"

@interface DERUniversalString : ASN1String {
@private
    NSMutableData *_string;
}

+ (DERUniversalString *)getInstance:(id)paramObject;
+ (DERUniversalString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (NSString *)getString;
- (NSString *)toString;
- (NSMutableData *)getOctets;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;

@end
