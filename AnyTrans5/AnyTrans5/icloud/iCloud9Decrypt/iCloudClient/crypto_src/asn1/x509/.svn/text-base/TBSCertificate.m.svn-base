//
//  TBSCertificate.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "TBSCertificate.h"
#import "DERTaggedObject.h"

@implementation TBSCertificate
@synthesize seq = _seq;
@synthesize version = _version;
@synthesize serialNumber = _serialNumber;
@synthesize signature = _signature;
@synthesize issuer = _issuer;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize subject = _subject;
@synthesize subjectPublicKeyInfo = _subjectPublicKeyInfo;
@synthesize issuerUniqueId = _issuerUniqueId;
@synthesize subjectUniqueId = _subjectUniqueId;
@synthesize extensions = _extensions;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_serialNumber) {
        [_serialNumber release];
        _serialNumber = nil;
    }
    if (_signature) {
        [_signature release];
        _signature = nil;
    }
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_startDate) {
        [_startDate release];
        _startDate = nil;
    }
    if (_endDate) {
        [_endDate release];
        _endDate = nil;
    }
    if (_subject) {
        [_subject release];
        _subject = nil;
    }
    if (_subjectPublicKeyInfo) {
        [_subjectPublicKeyInfo release];
        _subjectPublicKeyInfo = nil;
    }
    if (_issuerUniqueId) {
        [_issuerUniqueId release];
        _issuerUniqueId = nil;
    }
    if (_subjectUniqueId) {
        [_subjectUniqueId release];
        _subjectUniqueId = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
    [super dealloc];
#endif
}

+ (TBSCertificate *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[TBSCertificate class]]) {
        return (TBSCertificate *)paramObject;
    }
    if (paramObject) {
        return [[[TBSCertificate alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (TBSCertificate *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [TBSCertificate getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        self.seq = paramASN1Sequence;
        if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[DERTaggedObject class]]) {
            self.version = [ASN1Integer getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:0] paramBoolean:YES];
        }else {
            i = -1;
            ASN1Integer *integer = [[ASN1Integer alloc] initLong:0];
            self.version = integer;
#if !__has_feature(objc_arc)
    if (integer) [integer release]; integer = nil;
#endif
        }
        self.serialNumber = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:i + 1]];
        self.signature = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:i + 2]];
        self.issuer = [X500Name getInstance:[paramASN1Sequence getObjectAt:i + 3]];
        ASN1Sequence *localASN1Sequence = (ASN1Sequence *)[paramASN1Sequence getObjectAt:i + 4];
        self.startDate = [Time getInstance:[localASN1Sequence getObjectAt:0]];
        self.endDate = [Time getInstance:[localASN1Sequence getObjectAt:1]];
        self.subject = [X500Name getInstance:[paramASN1Sequence getObjectAt:i + 5]];
        self.subjectPublicKeyInfo = [SubjectPublicKeyInfo getInstance:[paramASN1Sequence getObjectAt:i + 6]];
        for (int j = ((int)[paramASN1Sequence size] - (i + 6) - 1); j > 0; j--) {
            DERTaggedObject *localDERTaggedObject = (DERTaggedObject *)[paramASN1Sequence getObjectAt:(i + 6 + j)];
            switch ([localDERTaggedObject getTagNo]) {
                case 1:
                    self.issuerUniqueId = [DERBitString getInstance:localDERTaggedObject paramBoolean:NO];
                    break;
                case 2:
                    self.subjectUniqueId = [DERBitString getInstance:localDERTaggedObject paramBoolean:NO];
                    break;
                case 3:
                    self.extensions = [Extensions getInstance:[ASN1Sequence getInstance:localDERTaggedObject paramBoolean:YES]];
                default:
                    break;
            }
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getVersionNumber {
    return [[self.version getValue] intValue] + 1;
}

- (ASN1Integer *)getVersion {
    return self.version;
}

- (ASN1Integer *)getSerialNumber {
    return self.serialNumber;
}

- (AlgorithmIdentifier *)getSignature {
    return self.signature;
}

- (X500Name *)getIssuer {
    return self.issuer;
}

- (Time *)getStartDate {
    return self.startDate;
}

- (Time *)getEndDate {
    return self.endDate;
}

- (X500Name *)getSubject {
    return self.subject;
}

- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo {
    return self.subjectPublicKeyInfo;
}

- (DERBitString *)getIssuerUniqueId {
    return self.issuerUniqueId;
}

- (DERBitString *)getSubjectUniqueId {
    return self.subjectUniqueId;
}

- (Extensions *)getExtensions {
    return self.extensions;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

@end
