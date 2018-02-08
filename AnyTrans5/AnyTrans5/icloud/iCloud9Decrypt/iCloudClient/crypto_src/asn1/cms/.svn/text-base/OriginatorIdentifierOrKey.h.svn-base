//
//  OriginatorIdentifierOrKey.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "ASN1TaggedObject.h"
#import "IssuerAndSerialNumber.h"
#import "ASN1OctetString.h"
#import "SubjectKeyIdentifier.h"
#import "OriginatorPublicKey.h"

@interface OriginatorIdentifierOrKey : ASN1Choice {
@private
    ASN1Encodable *_iD;
}

+ (OriginatorIdentifierOrKey *)getInstance:(id)paramObject;
+ (OriginatorIdentifierOrKey *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamIssuerAndSerialNumber:(IssuerAndSerialNumber *)paramIssuerAndSerialNumber;
- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamSubjectKeyIdentifier:(SubjectKeyIdentifier *)paramSubjectKeyIdentifier;
- (instancetype)initParamOriginatorPublicKey:(OriginatorPublicKey *)paramOriginatorPublicKey;
- (instancetype)initParamASN1Primitive:(ASN1Primitive *)paramASN1Primitive;
- (ASN1Encodable *)getId;
- (IssuerAndSerialNumber *)getIssuerAndSerialNumber;
- (SubjectKeyIdentifier *)getSubjectKeyIdentifier;
- (OriginatorPublicKey *)getOriginatorKey;
- (ASN1Primitive *)toASN1Primitive;

@end
