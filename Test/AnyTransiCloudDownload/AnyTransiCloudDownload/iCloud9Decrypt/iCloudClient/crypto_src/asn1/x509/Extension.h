//
//  Extension.h
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1OctetString.h"
#import "ASN1Boolean.h"
#import "ASN1Sequence.h"

@interface Extension : ASN1Object {
@private
    ASN1ObjectIdentifier *_extnId;
    BOOL _critical;
    ASN1OctetString *_value;
}

+ (ASN1ObjectIdentifier *)subjectDirectoryAttributes;
+ (ASN1ObjectIdentifier *)subjectKeyIdentifier;
+ (ASN1ObjectIdentifier *)keyUsage;
+ (ASN1ObjectIdentifier *)privateKeyUsagePeriod;
+ (ASN1ObjectIdentifier *)subjectAlternativeName;
+ (ASN1ObjectIdentifier *)issuerAlternativeName;
+ (ASN1ObjectIdentifier *)basicConstraints;
+ (ASN1ObjectIdentifier *)cRLNumber;
+ (ASN1ObjectIdentifier *)reasonCode;
+ (ASN1ObjectIdentifier *)instructionCode;
+ (ASN1ObjectIdentifier *)invalidityDate;
+ (ASN1ObjectIdentifier *)deltaCRLIndicator;
+ (ASN1ObjectIdentifier *)issuingDistributionPoint;
+ (ASN1ObjectIdentifier *)certificateIssuer;
+ (ASN1ObjectIdentifier *)nameConstraints;
+ (ASN1ObjectIdentifier *)cRLDistributionPoints;
+ (ASN1ObjectIdentifier *)certificatePolicies;
+ (ASN1ObjectIdentifier *)policyMappings;
+ (ASN1ObjectIdentifier *)authorityKeyIdentifier;
+ (ASN1ObjectIdentifier *)policyConstraints;
+ (ASN1ObjectIdentifier *)extendedKeyUsage;
+ (ASN1ObjectIdentifier *)freshestCRL;
+ (ASN1ObjectIdentifier *)inhibitAnyPolicy;
+ (ASN1ObjectIdentifier *)authorityInfoAccess;
+ (ASN1ObjectIdentifier *)subjectInfoAccess;
+ (ASN1ObjectIdentifier *)logoType;
+ (ASN1ObjectIdentifier *)biometricInfo;
+ (ASN1ObjectIdentifier *)qCStatements;
+ (ASN1ObjectIdentifier *)auditIdentity;
+ (ASN1ObjectIdentifier *)noRevAvail;
+ (ASN1ObjectIdentifier *)targetInformation;

+ (Extension *)getInstance:(id)paramObject;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (ASN1ObjectIdentifier *)getExtnId;
- (BOOL)isCritical;
- (ASN1OctetString *)getExtnValue;
- (ASN1Encodable *)getParsedValue;
- (ASN1Primitive *)toASN1Primitive;

@end
