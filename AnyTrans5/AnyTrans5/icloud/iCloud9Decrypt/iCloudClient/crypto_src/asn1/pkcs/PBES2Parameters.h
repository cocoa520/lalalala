//
//  PBES2Parameters.h
//  crypto
//
//  Created by JGehry on 6/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKCSObjectIdentifiers.h"
#import "KeyDerivationFunc.h"
#import "EncryptionScheme.h"

@interface PBES2Parameters : PKCSObjectIdentifiers {
@private
    KeyDerivationFunc *_func;
    EncryptionScheme *_scheme;
}

+ (PBES2Parameters *)getInstance:(id)paramObject;
- (instancetype)initParamKeyDerivationFunc:(KeyDerivationFunc *)paramKeyDerivationFunc paramEncryptionScheme:(EncryptionScheme *)paramEncryptionScheme;
- (KeyDerivationFunc *)getKeyDerivationFunc;
- (EncryptionScheme *)getEncryptionScheme;
- (ASN1Primitive *)toASN1Primitive;

@end
