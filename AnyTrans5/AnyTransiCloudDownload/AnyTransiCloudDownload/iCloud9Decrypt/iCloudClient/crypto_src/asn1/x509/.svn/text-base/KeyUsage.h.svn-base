//
//  KeyUsage.h
//  crypto
//
//  Created by JGehry on 7/11/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERBitString.h"
#import "Extensions.h"

@interface KeyUsage : ASN1Object {
@private
    DERBitString *_bitString;
}

+ (int)digitalSignature;
+ (int)nonRepudiation;
+ (int)keyEncipherment;
+ (int)dataEncipherment;
+ (int)keyAgreement;
+ (int)keyCertSign;
+ (int)cRLSign;
+ (int)encipherOnly;
+ (int)decipherOnly;
+ (KeyUsage *)getInstance:(id)paramObject;
+ (KeyUsage *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString;
- (BOOL)hasUsages:(int)paramInt;
- (NSMutableData *)getBytes;
- (int)getPadBits;
- (NSString *)toString;
- (ASN1Primitive *)toASN1Primitive;

@end
