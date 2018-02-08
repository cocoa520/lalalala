//
//  X509Extension.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509Extension.h"

@implementation X509Extension
@synthesize critical = _critical;
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)subjectDirectoryAttributes {
    static ASN1ObjectIdentifier *_subjectDirectoryAttributes = nil;
    @synchronized(self) {
        if (!_subjectDirectoryAttributes) {
            _subjectDirectoryAttributes = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.9"];
        }
    }
    return _subjectDirectoryAttributes;
}

+ (ASN1ObjectIdentifier *)subjectKeyIdentifier {
    static ASN1ObjectIdentifier *_subjectKeyIdentifier = nil;
    @synchronized(self) {
        if (!_subjectKeyIdentifier) {
            _subjectKeyIdentifier = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.14"];
        }
    }
    return _subjectKeyIdentifier;
}

+ (ASN1ObjectIdentifier *)keyUsage {
    static ASN1ObjectIdentifier *_keyUsage = nil;
    @synchronized(self) {
        if (!_keyUsage) {
            _keyUsage = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.15"];
        }
    }
    return _keyUsage;
}

+ (ASN1ObjectIdentifier *)privateKeyUsagePeriod {
    static ASN1ObjectIdentifier *_privateKeyUsagePeriod = nil;
    @synchronized(self) {
        if (!_privateKeyUsagePeriod) {
            _privateKeyUsagePeriod = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.16"];
        }
    }
    return _privateKeyUsagePeriod;
}

+ (ASN1ObjectIdentifier *)subjectAlternativeName {
    static ASN1ObjectIdentifier *_subjectAlternativeName = nil;
    @synchronized(self) {
        if (!_subjectAlternativeName) {
            _subjectAlternativeName = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.17"];
        }
    }
    return _subjectAlternativeName;
}

+ (ASN1ObjectIdentifier *)issuerAlternativeName {
    static ASN1ObjectIdentifier *_issuerAlternativeName = nil;
    @synchronized(self) {
        if (!_issuerAlternativeName) {
            _issuerAlternativeName = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.18"];
        }
    }
    return _issuerAlternativeName;
}

+ (ASN1ObjectIdentifier *)basicConstraints {
    static ASN1ObjectIdentifier *_basicConstraints = nil;
    @synchronized(self) {
        if (!_basicConstraints) {
            _basicConstraints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.19"];
        }
    }
    return _basicConstraints;
}

+ (ASN1ObjectIdentifier *)cRLNumber {
    static ASN1ObjectIdentifier *_cRLNumber = nil;
    @synchronized(self) {
        if (!_cRLNumber) {
            _cRLNumber = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.20"];
        }
    }
    return _cRLNumber;
}

+ (ASN1ObjectIdentifier *)reasonCode {
    static ASN1ObjectIdentifier *_reasonCode = nil;
    @synchronized(self) {
        if (!_reasonCode) {
            _reasonCode = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.21"];
        }
    }
    return _reasonCode;
}

+ (ASN1ObjectIdentifier *)instructionCode {
    static ASN1ObjectIdentifier *_instructionCode = nil;
    @synchronized(self) {
        if (!_instructionCode) {
            _instructionCode = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.23"];
        }
    }
    return _instructionCode;
}

+ (ASN1ObjectIdentifier *)invalidityDate {
    static ASN1ObjectIdentifier *_invalidityDate = nil;
    @synchronized(self) {
        if (!_invalidityDate) {
            _invalidityDate = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.24"];
        }
    }
    return _invalidityDate;
}

+ (ASN1ObjectIdentifier *)deltaCRLIndicator {
    static ASN1ObjectIdentifier *_deltaCRLIndicator = nil;
    @synchronized(self) {
        if (!_deltaCRLIndicator) {
            _deltaCRLIndicator = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.27"];
        }
    }
    return _deltaCRLIndicator;
}

+ (ASN1ObjectIdentifier *)issuingDistributionPoint {
    static ASN1ObjectIdentifier *_issuingDistributionPoint = nil;
    @synchronized(self) {
        if (!_issuingDistributionPoint) {
            _issuingDistributionPoint = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.28"];
        }
    }
    return _issuingDistributionPoint;
}

+ (ASN1ObjectIdentifier *)certificateIssuer {
    static ASN1ObjectIdentifier *_certificateIssuer = nil;
    @synchronized(self) {
        if (!_certificateIssuer) {
            _certificateIssuer = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.29"];
        }
    }
    return _certificateIssuer;
}

+ (ASN1ObjectIdentifier *)nameConstraints {
    static ASN1ObjectIdentifier *_nameConstraints = nil;
    @synchronized(self) {
        if (!_nameConstraints) {
            _nameConstraints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.30"];
        }
    }
    return _nameConstraints;
}

+ (ASN1ObjectIdentifier *)cRLDistributionPoints {
    static ASN1ObjectIdentifier *_cRLDistributionPoints = nil;
    @synchronized(self) {
        if (!_cRLDistributionPoints) {
            _cRLDistributionPoints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.31"];
        }
    }
    return _cRLDistributionPoints;
}

+ (ASN1ObjectIdentifier *)certificatePolicies {
    static ASN1ObjectIdentifier *_certificatePolicies = nil;
    @synchronized(self) {
        if (!_certificatePolicies) {
            _certificatePolicies = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.32"];
        }
    }
    return _certificatePolicies;
}

+ (ASN1ObjectIdentifier *)policyMappings {
    static ASN1ObjectIdentifier *_policyMappings = nil;
    @synchronized(self) {
        if (!_policyMappings) {
            _policyMappings = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.33"];
        }
    }
    return _policyMappings;
}

+ (ASN1ObjectIdentifier *)authorityKeyIdentifier {
    static ASN1ObjectIdentifier *_authorityKeyIdentifier = nil;
    @synchronized(self) {
        if (!_authorityKeyIdentifier) {
            _authorityKeyIdentifier = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.35"];
        }
    }
    return _authorityKeyIdentifier;
}

+ (ASN1ObjectIdentifier *)policyConstraints {
    static ASN1ObjectIdentifier *_policyConstraints = nil;
    @synchronized(self) {
        if (!_policyConstraints) {
            _policyConstraints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.36"];
        }
    }
    return _policyConstraints;
}

+ (ASN1ObjectIdentifier *)extendedKeyUsage {
    static ASN1ObjectIdentifier *_extendedKeyUsage = nil;
    @synchronized(self) {
        if (!_extendedKeyUsage) {
            _extendedKeyUsage = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.37"];
        }
    }
    return _extendedKeyUsage;
}

+ (ASN1ObjectIdentifier *)freshestCRL {
    static ASN1ObjectIdentifier *_freshestCRL = nil;
    @synchronized(self) {
        if (!_freshestCRL) {
            _freshestCRL = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.46"];
        }
    }
    return _freshestCRL;
}

+ (ASN1ObjectIdentifier *)inhibitAnyPolicy {
    static ASN1ObjectIdentifier *_inhibitAnyPolicy = nil;
    @synchronized(self) {
        if (!_inhibitAnyPolicy) {
            _inhibitAnyPolicy = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.54"];
        }
    }
    return _inhibitAnyPolicy;
}

+ (ASN1ObjectIdentifier *)authorityInfoAccess {
    static ASN1ObjectIdentifier *_authorityInfoAccess = nil;
    @synchronized(self) {
        if (!_authorityInfoAccess) {
            _authorityInfoAccess = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.1"];
        }
    }
    return _authorityInfoAccess;
}

+ (ASN1ObjectIdentifier *)subjectInfoAccess {
    static ASN1ObjectIdentifier *_subjectInfoAccess = nil;
    @synchronized(self) {
        if (!_subjectInfoAccess) {
            _subjectInfoAccess = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.11"];
        }
    }
    return _subjectInfoAccess;
}

+ (ASN1ObjectIdentifier *)logoType {
    static ASN1ObjectIdentifier *_logoType = nil;
    @synchronized(self) {
        if (!_logoType) {
            _logoType = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.12"];
        }
    }
    return _logoType;
}

+ (ASN1ObjectIdentifier *)biometricInfo {
    static ASN1ObjectIdentifier *_biometricInfo = nil;
    @synchronized(self) {
        if (!_biometricInfo) {
            _biometricInfo = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.2"];
        }
    }
    return _biometricInfo;
}

+ (ASN1ObjectIdentifier *)qCStatements {
    static ASN1ObjectIdentifier *_qCStatements = nil;
    @synchronized(self) {
        if (!_qCStatements) {
            _qCStatements = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.3"];
        }
    }
    return _qCStatements;
}

+ (ASN1ObjectIdentifier *)auditIdentity {
    static ASN1ObjectIdentifier *_auditIdentity = nil;
    @synchronized(self) {
        if (!_auditIdentity) {
            _auditIdentity = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.4"];
        }
    }
    return _auditIdentity;
}

+ (ASN1ObjectIdentifier *)noRevAvail {
    static ASN1ObjectIdentifier *_noRevAvail = nil;
    @synchronized(self) {
        if (!_noRevAvail) {
            _noRevAvail = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.56"];
        }
    }
    return _noRevAvail;
}

+ (ASN1ObjectIdentifier *)targetInformation {
    static ASN1ObjectIdentifier *_targetInformation = nil;
    @synchronized(self) {
        if (!_targetInformation) {
            _targetInformation = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.55"];
        }
    }
    return _targetInformation;
}

- (instancetype)initParamASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.critical = [paramASN1Boolean isTrue];
        self.value = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.critical = paramBoolean;
        self.value = paramASN1OctetString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (BOOL)isCritical {
    return self.critical;
}

- (ASN1OctetString *)getValue {
    return self.value;
}

- (ASN1Encodable *)getParsedValue {
    return [X509Extension convertValueToObject:self];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[X509Extension class]]) {
        return NO;
    }
    X509Extension *localX509Extension = (X509Extension *)object;
    return ([[localX509Extension getValue] isEqual:[self getValue]] && ([localX509Extension isCritical] == [self isCritical]));
}

+ (ASN1Primitive *)convertValueToObject:(X509Extension *)paramX509Extension {
    @try {
        return [ASN1Primitive fromByteArray:[[paramX509Extension getValue] getOctets]];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"can't convert extension: %@", exception.description] userInfo:nil];
    }
}

- (NSUInteger)hash {
    if (self.isCritical) {
        return [self.getValue hash];
    }
    return ~[self.getValue hash];
}

@end
