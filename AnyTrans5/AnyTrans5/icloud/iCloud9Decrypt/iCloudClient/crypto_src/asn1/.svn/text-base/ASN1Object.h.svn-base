//
//  ASN1Object.h
//  crypto
//
//  Created by JGehry on 5/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Encodable.h"
@class ASN1Primitive;

@interface ASN1Object : ASN1Encodable

+ (BOOL)hasEncodedTagValue:(id)paramObject paramInt:(int)paramInt;
- (NSMutableData *)getEncoded;
- (NSMutableData *)getEncoded:(NSString *)paramString;
- (ASN1Primitive *)toASN1Object;
- (ASN1Primitive *)toASN1Primitive;

@end
