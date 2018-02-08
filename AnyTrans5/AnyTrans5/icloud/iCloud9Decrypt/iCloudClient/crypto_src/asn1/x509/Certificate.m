//
//  Certificate.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "Certificate.h"

@implementation Certificate
@synthesize seq = _seq;
@synthesize tbsCert = _tbsCert;
@synthesize sigAlgId = _sigAlgId;
@synthesize sig = _sig;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    if (_tbsCert) {
        [_tbsCert release];
        _tbsCert = nil;
    }
    if (_sigAlgId) {
        [_sigAlgId release];
        _sigAlgId = nil;
    }
    if (_sig) {
        [_sig release];
        _sig = nil;
    }
    [super dealloc];
#endif
}

+ (Certificate *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[Certificate class]]) {
        return (Certificate *)paramObject;
    }
    if (paramObject) {
        return [[[Certificate alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (Certificate *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [Certificate getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.seq = paramASN1Sequence;
        if ([paramASN1Sequence size] == 3) {
            self.tbsCert = [TBSCertificate getInstance:[paramASN1Sequence getObjectAt:0]];
            self.sigAlgId = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
            self.sig = [DERBitString getInstance:[paramASN1Sequence getObjectAt:2]];
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:@"sequence wrong size for a certificate" userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (TBSCertificate *)getTBSCertificate {
    return self.tbsCert;
}

- (ASN1Integer *)getVersion {
    return [self.tbsCert getVersion];
}

- (int)getVersionNumber {
    return [self.tbsCert getVersionNumber];
}

- (ASN1Integer *)getSerialNumber {
    return [self.tbsCert getSerialNumber];
}

- (X500Name *)getIssuer {
    return [self.tbsCert getIssuer];
}

- (Time *)getStartDate {
    return [self.tbsCert getStartDate];
}

- (Time *)getEndDate; {
    return [self.tbsCert getEndDate];
}

- (X500Name *)getSubject {
    return [self.tbsCert getSubject];
}

- (SubjectPublicKeyInfo *)getSubjectPublicKeyInfo {
    return [self.tbsCert getSubjectPublicKeyInfo];
}

- (AlgorithmIdentifier *)getSignatureAlgorithm {
    return self.sigAlgId;
}

- (DERBitString *)getSignature {
    return self.sig;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.seq;
}


@end
