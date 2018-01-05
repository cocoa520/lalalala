//
//  X509Extensions.m
//  crypto
//
//  Created by JGehry on 6/27/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509Extensions.h"
#import "Extensions.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface X509Extensions ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *extensions;
@property (nonatomic, readwrite, retain) NSMutableArray *ordering;

@end

@implementation X509Extensions
@synthesize extensions = _extensions;
@synthesize ordering = _ordering;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    if (_ordering) {
        [_ordering release];
        _ordering = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)SubjectDirectoryAttributes {
    static ASN1ObjectIdentifier *_SubjectDirectoryAttributes = nil;
    @synchronized(self) {
        if (!_SubjectDirectoryAttributes) {
            _SubjectDirectoryAttributes = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.9"];
        }
    }
    return _SubjectDirectoryAttributes;
}

+ (ASN1ObjectIdentifier *)SubjectKeyIdentifier {
    static ASN1ObjectIdentifier *_SubjectKeyIdentifier = nil;
    @synchronized(self) {
        if (!_SubjectKeyIdentifier) {
            _SubjectKeyIdentifier = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.14"];
        }
    }
    return _SubjectKeyIdentifier;
}

+ (ASN1ObjectIdentifier *)KeyUsage {
    static ASN1ObjectIdentifier *_KeyUsage = nil;
    @synchronized(self) {
        if (!_KeyUsage) {
            _KeyUsage = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.15"];
        }
    }
    return _KeyUsage;
}

+ (ASN1ObjectIdentifier *)PrivateKeyUsagePeriod {
    static ASN1ObjectIdentifier *_PrivateKeyUsagePeriod = nil;
    @synchronized(self) {
        if (!_PrivateKeyUsagePeriod) {
            _PrivateKeyUsagePeriod = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.16"];
        }
    }
    return _PrivateKeyUsagePeriod;
}

+ (ASN1ObjectIdentifier *)SubjectAlternativeName {
    static ASN1ObjectIdentifier *_SubjectAlternativeName = nil;
    @synchronized(self) {
        if (!_SubjectAlternativeName) {
            _SubjectAlternativeName = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.17"];
        }
    }
    return _SubjectAlternativeName;
}

+ (ASN1ObjectIdentifier *)IssuerAlternativeName {
    static ASN1ObjectIdentifier *_IssuerAlternativeName = nil;
    @synchronized(self) {
        if (!_IssuerAlternativeName) {
            _IssuerAlternativeName = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.18"];
        }
    }
    return _IssuerAlternativeName;
}

+ (ASN1ObjectIdentifier *)BasicConstraints {
    static ASN1ObjectIdentifier *_BasicConstraints = nil;
    @synchronized(self) {
        if (!_BasicConstraints) {
            _BasicConstraints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.19"];
        }
    }
    return _BasicConstraints;
}

+ (ASN1ObjectIdentifier *)CRLNumber {
    static ASN1ObjectIdentifier *_CRLNumber = nil;
    @synchronized(self) {
        if (!_CRLNumber) {
            _CRLNumber = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.20"];
        }
    }
    return _CRLNumber;
}

+ (ASN1ObjectIdentifier *)ReasonCode {
    static ASN1ObjectIdentifier *_ReasonCode = nil;
    @synchronized(self) {
        if (!_ReasonCode) {
            _ReasonCode = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.21"];
        }
    }
    return _ReasonCode;
}

+ (ASN1ObjectIdentifier *)InstructionCode {
    static ASN1ObjectIdentifier *_InstructionCode = nil;
    @synchronized(self) {
        if (!_InstructionCode) {
            _InstructionCode = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.23"];
        }
    }
    return _InstructionCode;
}

+ (ASN1ObjectIdentifier *)InvalidityDate {
    static ASN1ObjectIdentifier *_InvalidityDate = nil;
    @synchronized(self) {
        if (!_InvalidityDate) {
            _InvalidityDate = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.24"];
        }
    }
    return _InvalidityDate;
}

+ (ASN1ObjectIdentifier *)DeltaCRLIndicator {
    static ASN1ObjectIdentifier *_DeltaCRLIndicator = nil;
    @synchronized(self) {
        if (!_DeltaCRLIndicator) {
            _DeltaCRLIndicator = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.27"];
        }
    }
    return _DeltaCRLIndicator;
}

+ (ASN1ObjectIdentifier *)IssuingDistributionPoint {
    static ASN1ObjectIdentifier *_IssuingDistributionPoint = nil;
    @synchronized(self) {
        if (!_IssuingDistributionPoint) {
            _IssuingDistributionPoint = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.28"];
        }
    }
    return _IssuingDistributionPoint;
}

+ (ASN1ObjectIdentifier *)CertificateIssuer {
    static ASN1ObjectIdentifier *_CertificateIssuer = nil;
    @synchronized(self) {
        if (!_CertificateIssuer) {
            _CertificateIssuer = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.29"];
        }
    }
    return _CertificateIssuer;
}

+ (ASN1ObjectIdentifier *)NameConstraints {
    static ASN1ObjectIdentifier *_NameConstraints = nil;
    @synchronized(self) {
        if (!_NameConstraints) {
            _NameConstraints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.30"];
        }
    }
    return _NameConstraints;
}

+ (ASN1ObjectIdentifier *)CRLDistributionPoints {
    static ASN1ObjectIdentifier *_CRLDistributionPoints = nil;
    @synchronized(self) {
        if (!_CRLDistributionPoints) {
            _CRLDistributionPoints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.31"];
        }
    }
    return _CRLDistributionPoints;
}

+ (ASN1ObjectIdentifier *)CertificatePolicies {
    static ASN1ObjectIdentifier *_CertificatePolicies = nil;
    @synchronized(self) {
        if (!_CertificatePolicies) {
            _CertificatePolicies = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.32"];
        }
    }
    return _CertificatePolicies;
}

+ (ASN1ObjectIdentifier *)PolicyMappings {
    static ASN1ObjectIdentifier *_PolicyMappings = nil;
    @synchronized(self) {
        if (!_PolicyMappings) {
            _PolicyMappings = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.33"];
        }
    }
    return _PolicyMappings;
}

+ (ASN1ObjectIdentifier *)AuthorityKeyIdentifier {
    static ASN1ObjectIdentifier *_AuthorityKeyIdentifier = nil;
    @synchronized(self) {
        if (!_AuthorityKeyIdentifier) {
            _AuthorityKeyIdentifier = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.35"];
        }
    }
    return _AuthorityKeyIdentifier;
}

+ (ASN1ObjectIdentifier *)PolicyConstraints {
    static ASN1ObjectIdentifier *_PolicyConstraints = nil;
    @synchronized(self) {
        if (!_PolicyConstraints) {
            _PolicyConstraints = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.36"];
        }
    }
    return _PolicyConstraints;
}

+ (ASN1ObjectIdentifier *)ExtendedKeyUsage {
    static ASN1ObjectIdentifier *_ExtendedKeyUsage = nil;
    @synchronized(self) {
        if (!_ExtendedKeyUsage) {
            _ExtendedKeyUsage = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.37"];
        }
    }
    return _ExtendedKeyUsage;
}

+ (ASN1ObjectIdentifier *)FreshestCRL {
    static ASN1ObjectIdentifier *_FreshestCRL = nil;
    @synchronized(self) {
        if (!_FreshestCRL) {
            _FreshestCRL = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.46"];
        }
    }
    return _FreshestCRL;
}

+ (ASN1ObjectIdentifier *)InhibitAnyPolicy {
    static ASN1ObjectIdentifier *_InhibitAnyPolicy = nil;
    @synchronized(self) {
        if (!_InhibitAnyPolicy) {
            _InhibitAnyPolicy = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.54"];
        }
    }
    return _InhibitAnyPolicy;
}

+ (ASN1ObjectIdentifier *)AuthorityInfoAccess {
    static ASN1ObjectIdentifier *_AuthorityInfoAccess = nil;
    @synchronized(self) {
        if (!_AuthorityInfoAccess) {
            _AuthorityInfoAccess = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.1"];
        }
    }
    return _AuthorityInfoAccess;
}

+ (ASN1ObjectIdentifier *)SubjectInfoAccess {
    static ASN1ObjectIdentifier *_SubjectInfoAccess = nil;
    @synchronized(self) {
        if (!_SubjectInfoAccess) {
            _SubjectInfoAccess = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.11"];
        }
    }
    return _SubjectInfoAccess;
}

+ (ASN1ObjectIdentifier *)LogoType {
    static ASN1ObjectIdentifier *_LogoType = nil;
    @synchronized(self) {
        if (!_LogoType) {
            _LogoType = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.12"];
        }
    }
    return _LogoType;
}

+ (ASN1ObjectIdentifier *)BiometricInfo {
    static ASN1ObjectIdentifier *_BiometricInfo = nil;
    @synchronized(self) {
        if (!_BiometricInfo) {
            _BiometricInfo = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.2"];
        }
    }
    return _BiometricInfo;
}

+ (ASN1ObjectIdentifier *)QCStatements {
    static ASN1ObjectIdentifier *_QCStatements = nil;
    @synchronized(self) {
        if (!_QCStatements) {
            _QCStatements = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.3"];
        }
    }
    return _QCStatements;
}

+ (ASN1ObjectIdentifier *)AuditIdentity {
    static ASN1ObjectIdentifier *_AuditIdentity = nil;
    @synchronized(self) {
        if (!_AuditIdentity) {
            _AuditIdentity = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.5.5.7.1.4"];
        }
    }
    return _AuditIdentity;
}

+ (ASN1ObjectIdentifier *)NoRevAvail {
    static ASN1ObjectIdentifier *_NoRevAvail = nil;
    @synchronized(self) {
        if (!_NoRevAvail) {
            _NoRevAvail = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.56"];
        }
    }
    return _NoRevAvail;
}

+ (ASN1ObjectIdentifier *)TargetInformation {
    static ASN1ObjectIdentifier *_TargetInformation = nil;
    @synchronized(self) {
        if (!_TargetInformation) {
            _TargetInformation = [[ASN1ObjectIdentifier alloc] initParamString:@"2.5.29.55"];
        }
    }
    return _TargetInformation;
}

+ (X509Extensions *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[X509Extensions class]]) {
        return (X509Extensions *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[X509Extensions alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[Extensions class]]) {
        return [[[X509Extensions alloc] initParamASN1Sequence:((ASN1Sequence *)([((Extensions *)paramObject) toASN1Primitive]))] autorelease];
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return [X509Extensions getInstance:[((ASN1TaggedObject *)paramObject) getObject]];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (X509Extensions *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [X509Extensions getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:localObject];
            if ([localASN1Sequence size] == 3) {
                X509Extension *extension = [[X509Extension alloc] initParamASN1Boolean:[ASN1Boolean getInstanceObject:[localASN1Sequence getObjectAt:1]] paramASN1OctetString:[ASN1OctetString getInstance:[localASN1Sequence getObjectAt:2]]];
                [self.extensions setObject:extension forKey:[localASN1Sequence getObjectAt:0]];
#if !__has_feature(objc_arc)
    if (extension) [extension release]; extension = nil;
#endif
            }else if ([localASN1Sequence size] == 2) {
                X509Extension *extension = [[X509Extension alloc] initParamBoolean:NO paramASN1OctetString:[ASN1OctetString getInstance:[localASN1Sequence getObjectAt:1]]];
                [self.extensions setObject:extension forKey:[localASN1Sequence getObjectAt:0]];
#if !__has_feature(objc_arc)
                if (extension) [extension release]; extension = nil;
#endif
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [localASN1Sequence size]] userInfo:nil];
            }
            [self.ordering addObject:[localASN1Sequence getObjectAt:0]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamHashtable:(NSMutableDictionary *)paramHashtable
{
    if (self = [super init]) {
        [self initParamVector:nil paramHashtable:paramHashtable];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamVector:(NSMutableArray *)paramVector paramHashtable:(NSMutableDictionary *)paramHashtable
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = nil;
        if (!paramVector) {
            localEnumeration = [paramHashtable keyEnumerator];
        }else {
            localEnumeration = [paramHashtable objectEnumerator];
        }
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            [self.ordering addObject:[ASN1ObjectIdentifier getInstance:localObject]];
        }
        localEnumeration = [self.ordering objectEnumerator];
        id localObject1 = nil;
        while (localObject1 = [localEnumeration nextObject]) {
            ASN1ObjectIdentifier *localASN1ObjectIdentifier = [ASN1ObjectIdentifier getInstance:localObject1];
            X509Extension *localX509Extension = (X509Extension *)[paramHashtable objectForKey:localASN1ObjectIdentifier];
            [self.extensions setObject:localX509Extension forKey:localASN1ObjectIdentifier];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamVector1:(NSMutableArray *)paramVector1 paramVector2:(NSMutableArray *)paramVector2
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramVector1 objectEnumerator];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            [self.ordering addObject:localObject];
        }
        int i = 0;
        localEnumeration = [self.ordering objectEnumerator];
        ASN1ObjectIdentifier *localASN1ObjectIdentifier = nil;
        while (localASN1ObjectIdentifier = [localEnumeration nextObject]) {
            X509Extension *localX509Extension = (X509Extension *)[paramVector2 objectAtIndex:i];
            [self.extensions setObject:localX509Extension forKey:localASN1ObjectIdentifier];
            i++;
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSEnumerator *)oids {
    return [self.ordering objectEnumerator];
}

- (X509Extension *)getExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return (X509Extension *)[self.extensions objectForKey:paramASN1ObjectIdentifier];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    NSEnumerator *localEnumeration = [self.ordering objectEnumerator];
    ASN1ObjectIdentifier *localASN1ObjectIdentifier = nil;
    while (localASN1ObjectIdentifier = [localEnumeration nextObject]) {
        X509Extension *localX509Extension = (X509Extension *)[self.extensions objectForKey:localASN1ObjectIdentifier];
        ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
        [localASN1EncodableVector2 add:localASN1ObjectIdentifier];
        if ([localX509Extension isCritical]) {
            [localASN1EncodableVector2 add:[ASN1Boolean TRUEALLOC]];
        }
        [localASN1EncodableVector2 add:[localX509Extension getValue]];
        ASN1Encodable *sequenceEncodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
        [localASN1EncodableVector1 add:sequenceEncodable];
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
        if (sequenceEncodable) [sequenceEncodable release]; sequenceEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
#endif
    return primitive;
}

- (BOOL)equivalent:(X509Extensions *)paramX509Extensions {
    if ([self.extensions count] != [[paramX509Extensions extensions] count]) {
        return NO;
    }
    NSEnumerator *localEnumeration = [self.extensions keyEnumerator];
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        if (![[self.extensions objectForKey:localObject] isEqual:[[paramX509Extensions extensions] objectForKey:localObject]]) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)getExtensionOIDs {
    return [self toOidArray:self.ordering];
}

- (NSMutableArray *)getNonCriticalExtensionOIDs {
    return [self getExtensionOIDs:false];
}

- (NSMutableArray *)getCriticalExtensionOIDs {
    return [self getExtensionOIDs:TRUE];
}

- (NSMutableArray *)getExtensionOIDs:(BOOL)paramBoolean {
    NSMutableArray *localVector = [[NSMutableArray alloc] init];
    for (int i = 0; i != [self.ordering count]; i++) {
        id localObject = [self.ordering objectAtIndex:i];
        if ([((X509Extension *)[self.extensions objectForKey:localObject]) isCritical] == paramBoolean) {
            [localVector addObject:localObject];
        }
    }
    NSMutableArray *returnAry = [self toOidArray:localVector];
#if !__has_feature(objc_arc)
    if (localVector) [localVector release]; localVector = nil;
#endif
    return returnAry;
}

- (NSMutableArray *)toOidArray:(NSMutableArray *)paramVector {
    NSMutableArray *arrayOfASN1ObjectIdentifier = [[[NSMutableArray alloc] initWithSize:(int)[paramVector count]] autorelease];
    for (int i = 0; i != [arrayOfASN1ObjectIdentifier count]; i++) {
        arrayOfASN1ObjectIdentifier[i] = (ASN1ObjectIdentifier *)[paramVector objectAtIndex:i];
    }
    return arrayOfASN1ObjectIdentifier;
}

@end
