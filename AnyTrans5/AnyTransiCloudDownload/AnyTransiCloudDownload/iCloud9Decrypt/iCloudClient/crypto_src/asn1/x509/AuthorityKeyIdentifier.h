//
//  AuthorityKeyIdentifier.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "GeneralNames.h"
#import "ASN1Integer.h"
#import "ASN1TaggedObject.h"
#import "Extensions.h"
#import "ASN1Sequence.h"
#import "SubjectPublicKeyInfo.h"

@interface AuthorityKeyIdentifier : ASN1Object {
    ASN1OctetString *_keyidentifier;
    GeneralNames *_certissuer;
    ASN1Integer *_certserno;
}

@property (nonatomic, readwrite, retain) ASN1OctetString *keyidentifier;
@property (nonatomic, readwrite, retain) GeneralNames *certissuer;
@property (nonatomic, readwrite, retain) ASN1Integer *certserno;

+ (AuthorityKeyIdentifier *)getInstance:(id)paramObject;
+ (AuthorityKeyIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (AuthorityKeyIdentifier *)fromExtensions:(Extensions *)paramExtensions;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo;
- (instancetype)initParamSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo paramGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger;
- (NSMutableData *)getKeyIdentifier;
- (GeneralNames *)getAuthorityCertIssuer;
- (BigInteger *)getAuthorityCertSerialNumber;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
