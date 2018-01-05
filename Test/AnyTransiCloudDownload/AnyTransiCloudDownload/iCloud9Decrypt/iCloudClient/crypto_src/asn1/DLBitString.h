//
//  DLBitString.h
//  crypto
//
//  Created by JGehry on 5/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1BitString.h"
#import "ASN1TaggedObject.h"
#import "ASN1Encodable.h"
#import "ASN1OutputStream.h"

@interface DLBitString : ASN1BitString

+ (ASN1BitString *)getInstance:(id)paramObject;
+ (ASN1BitString *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (DLBitString *)fromOctetString:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamByte:(Byte)paramByte paramInt:(int)paramInt;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (BOOL)isConstructed;
- (int)encodedLength;
- (void)encode:(ASN1OutputStream *)paramASN1OutputStream;

@end
