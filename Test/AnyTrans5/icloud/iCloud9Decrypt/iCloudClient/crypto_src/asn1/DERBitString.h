//
//  DERBitString.h
//  crypto
//
//  Created by JGehry on 5/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1BitString.h"
#import "ASN1TaggedObject.h"
#import "ASN1OutputStream.h"

@interface DERBitString : ASN1BitString

+ (DERBitString *)getInstance:(id)paramObject;
+ (DERBitString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (DERBitString *)fromOctetString:(NSMutableData *)paramArrayOfByte;
- (instancetype)initDERBitString:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
