//
//  PKIArchiveOptions.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"
#import "EncryptedKey.h"
#import "ASN1OctetString.h"

@interface PKIArchiveOptions : ASN1Choice {
@private
    ASN1Encodable *_value;
}

+ (int)encryptedPrivKey;
+ (int)keyGenParameters;
+ (int)archiveRemGenPrivKey;
+ (PKIArchiveOptions *)getInstance:(id)paramObject;
- (instancetype)initParamEncryptedKey:(EncryptedKey *)paramEncryptedKey;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamBoolean:(BOOL)paramBoolean;
- (int)getType;
- (ASN1Encodable *)getValue;
- (ASN1Primitive *)toASN1Primitive;

@end
