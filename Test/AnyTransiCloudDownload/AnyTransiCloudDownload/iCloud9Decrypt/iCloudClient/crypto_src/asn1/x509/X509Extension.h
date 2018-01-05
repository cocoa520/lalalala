//
//  X509Extension.h
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1Primitive.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1OctetString.h"
#import "ASN1Boolean.h"

@interface X509Extension : NSObject {
    BOOL _critical;
    ASN1OctetString *_value;
}

@property (nonatomic, assign) BOOL critical;
@property (nonatomic, readwrite, retain) ASN1OctetString *value;

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
- (instancetype)initParamASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (instancetype)initParamBoolean:(BOOL)paramBoolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString;
- (BOOL)isCritical;
- (ASN1OctetString *)getValue;
- (ASN1Encodable *)getParsedValue;
+ (ASN1Primitive *)convertValueToObject:(X509Extension *)paramX509Extension;

@end
