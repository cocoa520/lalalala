//
//  DERNumericString.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1String.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface DERNumericString : ASN1String {
@private
    NSMutableData *_string;
}

+ (DERNumericString *)getInstance:(id)paramObject;
+ (DERNumericString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (BOOL)isNumericString:(NSString *)paramString;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamString:(NSString *)paramString paramBoolean:(BOOL)paramBoolean;
- (NSString *)getString;
- (NSString *)toString;
- (NSMutableData *)getOctets;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;

@end
