//
//  ProofOfPossession.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1Encodable.h"
#import "POPOSigningKey.h"
#import "POPOPrivKey.h"

@interface ProofOfPossession : ASN1Choice {
@private
    int _tagNo;
    ASN1Encodable *_obj;
}

+ (int)TYPE_RA_VERIFIED;
+ (int)TYPE_SIGNING_KEY;
+ (int)TYPE_KEY_ENCIPHERMENT;
+ (int)TYPE_KEY_AGREEMENT;
+ (ProofOfPossession *)getInstance:(id)paramObject;
- (instancetype)init;
- (instancetype)initParamPOPOSigningKey:(POPOSigningKey *)paramPOPOSigningKey;
- (instancetype)initParamInt:(int)paramInt paramPOPOPrivKey:(POPOPrivKey *)paramPOPOPrivKey;
- (int)getType;
- (ASN1Encodable *)getObject;
- (ASN1Primitive *)toASN1Primitive;

@end
