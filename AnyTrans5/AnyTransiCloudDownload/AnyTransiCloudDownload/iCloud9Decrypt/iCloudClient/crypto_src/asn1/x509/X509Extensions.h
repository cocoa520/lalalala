//
//  X509Extensions.h
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1OctetString.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1TaggedObject.h"
#import "ASN1Sequence.h"
#import "X509Extension.h"

@interface X509Extensions : ASN1Object {
@private
    NSMutableDictionary *_extensions;
    NSMutableArray *_ordering;
}

+ (ASN1ObjectIdentifier *)SubjectDirectoryAttributes;
+ (ASN1ObjectIdentifier *)SubjectKeyIdentifier;
+ (ASN1ObjectIdentifier *)KeyUsage;
+ (ASN1ObjectIdentifier *)PrivateKeyUsagePeriod;
+ (ASN1ObjectIdentifier *)SubjectAlternativeName;
+ (ASN1ObjectIdentifier *)IssuerAlternativeName;
+ (ASN1ObjectIdentifier *)BasicConstraints;
+ (ASN1ObjectIdentifier *)CRLNumber;
+ (ASN1ObjectIdentifier *)ReasonCode;
+ (ASN1ObjectIdentifier *)InstructionCode;
+ (ASN1ObjectIdentifier *)InvalidityDate;
+ (ASN1ObjectIdentifier *)DeltaCRLIndicator;
+ (ASN1ObjectIdentifier *)IssuingDistributionPoint;
+ (ASN1ObjectIdentifier *)CertificateIssuer;
+ (ASN1ObjectIdentifier *)NameConstraints;
+ (ASN1ObjectIdentifier *)CRLDistributionPoints;
+ (ASN1ObjectIdentifier *)CertificatePolicies;
+ (ASN1ObjectIdentifier *)PolicyMappings;
+ (ASN1ObjectIdentifier *)AuthorityKeyIdentifier;
+ (ASN1ObjectIdentifier *)PolicyConstraints;
+ (ASN1ObjectIdentifier *)ExtendedKeyUsage;
+ (ASN1ObjectIdentifier *)FreshestCRL;
+ (ASN1ObjectIdentifier *)InhibitAnyPolicy;
+ (ASN1ObjectIdentifier *)AuthorityInfoAccess;
+ (ASN1ObjectIdentifier *)SubjectInfoAccess;
+ (ASN1ObjectIdentifier *)LogoType;
+ (ASN1ObjectIdentifier *)BiometricInfo;
+ (ASN1ObjectIdentifier *)QCStatements;
+ (ASN1ObjectIdentifier *)AuditIdentity;
+ (ASN1ObjectIdentifier *)NoRevAvail;
+ (ASN1ObjectIdentifier *)TargetInformation;
+ (X509Extensions *)getInstance:(id)paramObject;
+ (X509Extensions *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (instancetype)initParamHashtable:(NSMutableDictionary *)paramHashtable;
- (instancetype)initParamVector:(NSMutableArray *)paramVector paramHashtable:(NSMutableDictionary *)paramHashtable;
- (instancetype)initParamVector1:(NSMutableArray *)paramVector1 paramVector2:(NSMutableArray *)paramVector2;
- (NSEnumerator *)oids;
- (X509Extension *)getExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1Primitive *)toASN1Primitive;
- (BOOL)equivalent:(X509Extensions *)paramX509Extensions;
- (NSMutableArray *)getExtensionOIDs;
- (NSMutableArray *)getNonCriticalExtensionOIDs;
- (NSMutableArray *)getCriticalExtensionOIDs;
- (NSMutableArray *)getExtensionOIDs:(BOOL)paramBoolean;
- (NSMutableArray *)toOidArray:(NSMutableArray *)paramVector;

@end
