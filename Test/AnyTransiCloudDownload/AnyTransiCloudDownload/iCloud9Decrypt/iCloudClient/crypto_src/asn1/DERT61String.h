//
//  DERT61String.h
//  crypto
//
//  Created by JGehry on 6/3/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1String.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface DERT61String : ASN1String {
@private
    NSMutableData *_string;
}

+ (DERT61String *)getInstance:(id)paramObject;
+ (DERT61String *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamString:(NSString *)paramString;
- (NSString *)getString;
- (NSString *)toString;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;
- (NSMutableData *)getOctets;
- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive;
@end
