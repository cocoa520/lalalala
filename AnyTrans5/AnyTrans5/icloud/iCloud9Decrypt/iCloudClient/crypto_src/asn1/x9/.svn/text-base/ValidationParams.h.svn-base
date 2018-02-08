//
//  ValidationParams.h
//  crypto
//
//  Created by JGehry on 5/31/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "DERBitString.h"
#import "ASN1Integer.h"

@interface ValidationParams : ASN1Object {
@private
    DERBitString *_seed;
    ASN1Integer *_pgenCounter;
}

+ (ValidationParams *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (ValidationParams *)getInstance:(id)paramObject;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramInt:(int)paramInt;
- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString paramASN1Integer:(ASN1Integer *)paramASN1Integer;
- (NSMutableData *)getSeed;
- (BigInteger *)getPgenCounter;
- (ASN1Primitive *)toASN1Primitive;

@end
