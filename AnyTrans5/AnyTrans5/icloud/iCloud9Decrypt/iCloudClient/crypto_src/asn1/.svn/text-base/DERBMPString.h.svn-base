//
//  DERBMPString.h
//  crypto
//
//  Created by JGehry on 6/6/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1String.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface DERBMPString : ASN1String {
@private
    NSMutableArray *_string;
}

+ (DERBMPString *)getInstance:(id)paramObject;
+ (DERBMPString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfChar:(NSMutableArray *)paramArrayOfChar;
- (instancetype)initParamString:(NSString *)paramString;
- (NSString *)getString;
- (NSString *)toString;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;


@end
