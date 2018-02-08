//
//  CertificateList.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificateList.h"
#import "DERSequence.h"

@implementation CertificateList
@synthesize tbsCertList = _tbsCertList;
@synthesize sigAlgId = _sigAlgId;
@synthesize sig = _sig;
@synthesize isHashCodeSet = _isHashCodeSet;
@synthesize hashCodeValue = _hashCodeValue;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_tbsCertList) {
        [_tbsCertList release];
        _tbsCertList = nil;
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

+ (CertificateList *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertificateList class]]) {
        return (CertificateList *)paramObject;
    }
    if (paramObject) {
        return [[[CertificateList alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (CertificateList *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [CertificateList getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] == 3) {
            self.tbsCertList = [TBSCertList getInstance:[paramASN1Sequence getObjectAt:0]];
            self.sigAlgId = [AlgorithmIdentifier getInstance:[paramASN1Sequence getObjectAt:1]];
            self.sig = [DERBitString getInstance:[paramASN1Sequence getObjectAt:2]];
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:@"sequence wrong size for CertificateList" userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (TBSCertList *)getTBSCertList {
    return self.tbsCertList;
}

- (NSMutableArray *)getRevokedCertificates {
    return [self.tbsCertList getRevokedCertificates];
}

- (NSEnumerator *)getRevokedCertificateEnumeration {
    return [self.tbsCertList getRevokedCertificateEnumeration];
}

- (AlgorithmIdentifier *)getSignatureAlgorithm {
    return self.sigAlgId;
}

- (DERBitString *)getSignature {
    return self.sig;
}

- (int)getVersionNumber {
    return [self.tbsCertList getVersionNumber];
}

- (X500Name *)getIssuer {
    return [self.tbsCertList getIssuer];
}

- (Time *)getThisUpdate {
    return [self.tbsCertList getThisUpdate];
}

- (Time *)getNextUpdate {
    return [self.tbsCertList getNextUpdate];
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.tbsCertList];
    [localASN1EncodableVector add:self.sigAlgId];
    [localASN1EncodableVector add:self.sig];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSUInteger)hash {
    if (!self.isHashCodeSet) {
        self.hashCodeValue = [super hash];
        self.isHashCodeSet = YES;
    }
    return self.hashCodeValue;
}

@end
