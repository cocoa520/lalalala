//
//  CertTemplate.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertTemplate.h"

@interface CertTemplate ()

@property (nonatomic, readwrite, retain) ASN1Sequence *seq;
@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) ASN1Integer *serialNumber;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *signingAlg;
@property (nonatomic, readwrite, retain) X500Name *issuer;
@property (nonatomic, readwrite, retain) OptionalValidity *validity;
@property (nonatomic, readwrite, retain) X500Name *subject;
@property (nonatomic, readwrite, retain) SubjectPublicKeyInfo *publicKey;
@property (nonatomic, readwrite, retain) DERBitString *issuerUID;
@property (nonatomic, readwrite, retain) DERBitString *subjectUID;
@property (nonatomic, readwrite, retain) Extensions *extensions;

@end

@implementation CertTemplate
@synthesize seq = _seq;
@synthesize version = _version;
@synthesize serialNumber = _serialNumber;
@synthesize signingAlg = _signingAlg;
@synthesize issuer = _issuer;
@synthesize validity = _validity;
@synthesize subject = _subject;
@synthesize publicKey = _publicKey;
@synthesize issuerUID = _issuerUID;
@synthesize subjectUID = _subjectUID;
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
    if (_signingAlg) {
        [_signingAlg release];
        _signingAlg = nil;
    }
    if (_issuer) {
        [_issuer release];
        _issuer = nil;
    }
    if (_validity) {
        [_validity release];
        _validity = nil;
    }
    if (_subject) {
        [_subject release];
        _subject = nil;
    }
    if (_publicKey) {
        [_publicKey release];
        _publicKey = nil;
    }
    if (_issuerUID) {
        [_issuerUID release];
        _issuerUID = nil;
    }
    if (_subjectUID) {
        [_subjectUID release];
        _subjectUID = nil;
    }
    if (_extensions) {
        [_extensions release];
        _extensions = nil;
    }
   [super dealloc];
#endif
}

+ (CertTemplate *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertTemplate class]]) {
        return (CertTemplate *)paramObject;
    }
    if (paramObject) {
        return [[[CertTemplate alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1TaggedObject *localASN1TaggedObject = nil;
        while (localASN1TaggedObject = [localEnumeration nextObject]) {
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.version = [ASN1Integer getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 1:
                    self.serialNumber = [ASN1Integer getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 2:
                    self.signingAlg = [AlgorithmIdentifier getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 3:
                    self.issuer = [X500Name getInstance:localASN1TaggedObject paramBoolean:TRUE];
                    break;
                case 4:
                    self.validity = [OptionalValidity getInstance:[ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:false]];
                    break;
                case 5:
                    self.subject = [X500Name getInstance:localASN1TaggedObject paramBoolean:TRUE];
                    break;
                case 6:
                    self.publicKey = [SubjectPublicKeyInfo getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 7:
                    self.issuerUID = [DERBitString getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 8:
                    self.subjectUID = [DERBitString getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                case 9:
                    self.extensions = [Extensions getInstance:localASN1TaggedObject paramBoolean:false];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown tag: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
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

- (int)getVersion {
    return [[self.version getValue] intValue];
}

- (ASN1Integer *)getSerialNumber {
    return self.serialNumber;
}

- (AlgorithmIdentifier *)getSigningAlg {
    return self.signingAlg;
}

- (X500Name *)getIssuer {
    return self.issuer;
}

- (OptionalValidity *)getValidity {
    return self.validity;
}

- (X500Name *)getSubject {
    return self.subject;
}

- (SubjectPublicKeyInfo *)getPublicKey {
    return self.publicKey;
}

- (DERBitString *)getIssuerUID {
    return self.issuerUID;
}

- (DERBitString *)getSubjectUID {
    return self.subjectUID;
}

- (Extensions *)getExtensions {
    return self.extensions;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}

@end
