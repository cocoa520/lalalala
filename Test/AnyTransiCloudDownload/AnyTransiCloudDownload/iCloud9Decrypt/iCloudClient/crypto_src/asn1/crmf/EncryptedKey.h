//
//  EncryptedKey.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "EnvelopedData.h"
#import "EncryptedValue.h"

@interface EncryptedKey : ASN1Choice {
@private
    EnvelopedData *_envelopedData;
    EncryptedValue *_encryptedValue;
}

+ (EncryptedKey *)getInstance:(id)paramObject;
- (instancetype)initParamEnvelopedData:(EnvelopedData *)paramEnvelopedData;
- (instancetype)initParamEncryptedValue:(EncryptedValue *)paramEncryptedValue;
- (BOOL)isEncryptedValue;
- (ASN1Encodable *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
