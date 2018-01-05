//
//  Extension.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Extension.h"
#import "DEROctetString.h"
#import "DERSequence.h"

@interface Extension ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *extnId;
@property (nonatomic, assign) BOOL critical;
@property (nonatomic, readwrite, retain) ASN1OctetString *value;

@end

@implementation Extension
@synthesize extnId = _extnId;
@synthesize critical = _critical;
@synthesize value = _value;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_extnId) {
        [_extnId release];
        _extnId = nil;
    }
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
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.9"];
            _subjectDirectoryAttributes = [[obj intern] retain];
#if !__has_feature(objc_arc)
    if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _subjectDirectoryAttributes;
}

+ (ASN1ObjectIdentifier *)subjectKeyIdentifier {
    static ASN1ObjectIdentifier *_subjectKeyIdentifier = nil;
    @synchronized(self) {
        if (!_subjectKeyIdentifier) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.14"];
            _subjectKeyIdentifier = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _subjectKeyIdentifier;
}

+ (ASN1ObjectIdentifier *)keyUsage {
    static ASN1ObjectIdentifier *_keyUsage = nil;
    @synchronized(self) {
        if (!_keyUsage) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.15"];
            _keyUsage = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _keyUsage;
}

+ (ASN1ObjectIdentifier *)privateKeyUsagePeriod {
    static ASN1ObjectIdentifier *_privateKeyUsagePeriod = nil;
    @synchronized(self) {
        if (!_privateKeyUsagePeriod) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.15"];
            _privateKeyUsagePeriod = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _privateKeyUsagePeriod;
}

+ (ASN1ObjectIdentifier *)subjectAlternativeName {
    static ASN1ObjectIdentifier *_subjectAlternativeName = nil;
    @synchronized(self) {
        if (!_subjectAlternativeName) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.17"];
            _subjectAlternativeName = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _subjectAlternativeName;
}

+ (ASN1ObjectIdentifier *)issuerAlternativeName {
    static ASN1ObjectIdentifier *_issuerAlternativeName = nil;
    @synchronized(self) {
        if (!_issuerAlternativeName) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.18"];
            _issuerAlternativeName = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _issuerAlternativeName;
}

+ (ASN1ObjectIdentifier *)basicConstraints {
    static ASN1ObjectIdentifier *_basicConstraints = nil;
    @synchronized(self) {
        if (!_basicConstraints) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.19"];
            _basicConstraints = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _basicConstraints;
}

+ (ASN1ObjectIdentifier *)cRLNumber {
    static ASN1ObjectIdentifier *_cRLNumber = nil;
    @synchronized(self) {
        if (!_cRLNumber) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.20"];
            _cRLNumber = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _cRLNumber;
}

+ (ASN1ObjectIdentifier *)reasonCode {
    static ASN1ObjectIdentifier *_reasonCode = nil;
    @synchronized(self) {
        if (!_reasonCode) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.21"];
            _reasonCode = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _reasonCode;
}

+ (ASN1ObjectIdentifier *)instructionCode {
    static ASN1ObjectIdentifier *_instructionCode = nil;
    @synchronized(self) {
        if (!_instructionCode) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.23"];
            _instructionCode = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _instructionCode;
}

+ (ASN1ObjectIdentifier *)invalidityDate {
    static ASN1ObjectIdentifier *_invalidityDate = nil;
    @synchronized(self) {
        if (!_invalidityDate) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.24"];
            _invalidityDate = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _invalidityDate;
}

+ (ASN1ObjectIdentifier *)deltaCRLIndicator {
    static ASN1ObjectIdentifier *_deltaCRLIndicator = nil;
    @synchronized(self) {
        if (!_deltaCRLIndicator) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.27"];
            _deltaCRLIndicator = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
       }
    }
    return _deltaCRLIndicator;
}

+ (ASN1ObjectIdentifier *)issuingDistributionPoint {
    static ASN1ObjectIdentifier *_issuingDistributionPoint = nil;
    @synchronized(self) {
        if (!_issuingDistributionPoint) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.28"];
            _issuingDistributionPoint = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _issuingDistributionPoint;
}

+ (ASN1ObjectIdentifier *)certificateIssuer {
    static ASN1ObjectIdentifier *_certificateIssuer = nil;
    @synchronized(self) {
        if (!_certificateIssuer) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.29"];
            _certificateIssuer = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _certificateIssuer;
}

+ (ASN1ObjectIdentifier *)nameConstraints {
    static ASN1ObjectIdentifier *_nameConstraints = nil;
    @synchronized(self) {
        if (!_nameConstraints) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.30"];
            _nameConstraints = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
       }
    }
    return _nameConstraints;
}

+ (ASN1ObjectIdentifier *)cRLDistributionPoints {
    static ASN1ObjectIdentifier *_cRLDistributionPoints = nil;
    @synchronized(self) {
        if (!_cRLDistributionPoints) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.31"];
            _cRLDistributionPoints = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _cRLDistributionPoints;
}

+ (ASN1ObjectIdentifier *)certificatePolicies {
    static ASN1ObjectIdentifier *_certificatePolicies = nil;
    @synchronized(self) {
        if (!_certificatePolicies) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.32"];
            _certificatePolicies = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _certificatePolicies;
}

+ (ASN1ObjectIdentifier *)policyMappings {
    static ASN1ObjectIdentifier *_policyMappings = nil;
    @synchronized(self) {
        if (!_policyMappings) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.33"];
            _policyMappings = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _policyMappings;
}

+ (ASN1ObjectIdentifier *)authorityKeyIdentifier {
    static ASN1ObjectIdentifier *_authorityKeyIdentifier = nil;
    @synchronized(self) {
        if (!_authorityKeyIdentifier) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.35"];
            _authorityKeyIdentifier = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _authorityKeyIdentifier;
}

+ (ASN1ObjectIdentifier *)policyConstraints {
    static ASN1ObjectIdentifier *_policyConstraints = nil;
    @synchronized(self) {
        if (!_policyConstraints) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.36"];
            _policyConstraints = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _policyConstraints;
}

+ (ASN1ObjectIdentifier *)extendedKeyUsage {
    static ASN1ObjectIdentifier *_extendedKeyUsage = nil;
    @synchronized(self) {
        if (!_extendedKeyUsage) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.37"];
            _extendedKeyUsage = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _extendedKeyUsage;
}

+ (ASN1ObjectIdentifier *)freshestCRL {
    static ASN1ObjectIdentifier *_freshestCRL = nil;
    @synchronized(self) {
        if (!_freshestCRL) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.46"];
            _freshestCRL = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _freshestCRL;
}

+ (ASN1ObjectIdentifier *)inhibitAnyPolicy {
    static ASN1ObjectIdentifier *_inhibitAnyPolicy = nil;
    @synchronized(self) {
        if (!_inhibitAnyPolicy) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.54"];
            _inhibitAnyPolicy = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _inhibitAnyPolicy;
}

+ (ASN1ObjectIdentifier *)authorityInfoAccess {
    static ASN1ObjectIdentifier *_authorityInfoAccess = nil;
    @synchronized(self) {
        if (!_authorityInfoAccess) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.1"];
            _authorityInfoAccess = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _authorityInfoAccess;
}

+ (ASN1ObjectIdentifier *)subjectInfoAccess {
    static ASN1ObjectIdentifier *_subjectInfoAccess = nil;
    @synchronized(self) {
        if (!_subjectInfoAccess) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.11"];
            _subjectInfoAccess = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _subjectInfoAccess;
}

+ (ASN1ObjectIdentifier *)logoType {
    static ASN1ObjectIdentifier *_logoType = nil;
    @synchronized(self) {
        if (!_logoType) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.12"];
            _logoType = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _logoType;
}

+ (ASN1ObjectIdentifier *)biometricInfo {
    static ASN1ObjectIdentifier *_biometricInfo = nil;
    @synchronized(self) {
        if (!_biometricInfo) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.2"];
            _biometricInfo = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _biometricInfo;
}

+ (ASN1ObjectIdentifier *)qCStatements {
    static ASN1ObjectIdentifier *_qCStatements = nil;
    @synchronized(self) {
        if (!_qCStatements) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.3"];
            _qCStatements = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _qCStatements;
}

+ (ASN1ObjectIdentifier *)auditIdentity {
    static ASN1ObjectIdentifier *_auditIdentity = nil;
    @synchronized(self) {
        if (!_auditIdentity) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.4"];
            _auditIdentity = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _auditIdentity;
}

+ (ASN1ObjectIdentifier *)noRevAvail {
    static ASN1ObjectIdentifier *_noRevAvail = nil;
    @synchronized(self) {
        if (!_noRevAvail) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.56"];
            _noRevAvail = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _noRevAvail;
}

+ (ASN1ObjectIdentifier *)targetInformation {
    static ASN1ObjectIdentifier *_targetInformation = nil;
    @synchronized(self) {
        if (!_targetInformation) {
            ASN1ObjectIdentifier *obj = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.55"];
            _targetInformation = [[obj intern] retain];
#if !__has_feature(objc_arc)
            if (obj) [obj release]; obj = nil;
#endif
        }
    }
    return _targetInformation;
}

+ (Extension *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Extension class]]) {
        return (Extension *)paramObject;
    }
    if (paramObject) {
        return [[[Extension alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Boolean:(ASN1Boolean *)paramASN1Boolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        [self initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramBoolean:[paramASN1Boolean isTrue] paramASN1OctetString:paramASN1OctetString];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        [self initParamASN1ObjectIdentifier:paramASN1ObjectIdentifier paramBoolean:paramBoolean paramASN1OctetString:octetString];
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.extnId = paramASN1ObjectIdentifier;
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

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] == 2) {
            self.extnId = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
            self.critical = NO;
            self.value = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:1]];
        }else if ([paramASN1Sequence size] == 3) {
            self.extnId = [ASN1ObjectIdentifier getInstance:[paramASN1Sequence getObjectAt:0]];
            self.critical = [[ASN1Boolean getInstanceObject:[paramASN1Sequence getObjectAt:1]] isTrue];
            self.value = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:2]];
        }else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getExtnId {
    return self.extnId;
}

- (BOOL)isCritical {
    return self.critical;
}

- (ASN1OctetString *)getExtnValue {
    return self.value;
}

- (ASN1Encodable *)getParsedValue {
    return [Extension convertValueToObject:self];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Extension class]]) {
        return NO;
    }
    Extension *localExtension = (Extension *)object;
    return ([[localExtension getExtnId] isEqual:[self getExtnId]] && [[localExtension getExtnValue] isEqual:[self getExtnValue]] && [localExtension isCritical] == [self isCritical]);
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.extnId];
    if (self.critical) {
        [localASN1EncodableVector add:[ASN1Boolean getInstanceBoolean:TRUE]];
    }
    [localASN1EncodableVector add:self.value];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

+ (ASN1Primitive *)convertValueToObject:(Extension *)paramExtension {
    @try {
        return [ASN1Primitive fromByteArray:[[paramExtension getExtnValue] getOctets]];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"can't convert extension: %@", exception.description] userInfo:nil];
    }
}

- (NSUInteger)hash {
    if ([self isCritical]) {
        return [self.getExtnValue hash] ^ [self.getExtnId hash];
    }
    return ~([self.getExtnValue hash] ^ [self.getExtnId hash]);
}

@end
