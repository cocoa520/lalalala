//
//  RevRepContentBuilder.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RevRepContentBuilder.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"

@implementation RevRepContentBuilder
@synthesize status = _status;
@synthesize revCerts = _revCerts;
@synthesize crls = _crls;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_status) {
        [_status release];
        _status = nil;
    }
    if (_revCerts) {
        [_revCerts release];
        _revCerts = nil;
    }
    if (_crls) {
        [_crls release];
        _crls = nil;
    }
    [super dealloc];
#endif
}

- (void)setStatus:(ASN1EncodableVector *)status {
    if (_status != status) {
        _status = [[[ASN1EncodableVector alloc] init] autorelease];
    }
}

- (void)setRevCerts:(ASN1EncodableVector *)revCerts {
    if (_revCerts != revCerts) {
        _revCerts = [[[ASN1EncodableVector alloc] init] autorelease];
    }
}

- (void)setCrls:(ASN1EncodableVector *)crls {
    if (_crls != crls) {
        _crls = [[[ASN1EncodableVector alloc] init] autorelease];
    }
}

- (RevRepContentBuilder *)add:(PKIStatusInfo *)paramPKIStatusInfo {
    [self.status add:paramPKIStatusInfo];
    return self;
}

- (RevRepContentBuilder *)add:(PKIStatusInfo *)paramPKIStatusInfo paramCertId:(CertIdCRMF *)paramCertId {
    if ([self.status size] != [self.revCerts size]) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"status and revCerts sequence must be in common order" userInfo:nil];
    }
    [self.status add:paramPKIStatusInfo];
    [self.revCerts add:paramCertId];
    return self;
}

- (RevRepContentBuilder *)addCrl:(CertificateList *)paramCertificateList {
    [self.crls add:paramCertificateList];
    return self;
}

- (RevRepContent *)build {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:self.status];
    [localASN1EncodableVector add:encodable];
    if ([self.revCerts size] != 0) {
        ASN1Encodable  *derSequenceEncodable = [[DERSequence alloc] initDERParamASN1EncodableVector:self.revCerts];
        ASN1Encodable *derTaggedEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:0 paramASN1Encodable:derSequenceEncodable];
        [localASN1EncodableVector add:derTaggedEncodable];
#if !__has_feature(objc_arc)
        if (derSequenceEncodable) [derSequenceEncodable release]; derSequenceEncodable = nil;
        if (derTaggedEncodable) [derTaggedEncodable release]; derTaggedEncodable = nil;
#endif
    }
    if ([self.crls size] != 0) {
        ASN1Encodable *derSequenceEncodable = [[DERSequence alloc] initDERParamASN1EncodableVector:self.crls];
        ASN1Encodable *derTaggedEncodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:derSequenceEncodable];
        [localASN1EncodableVector add:derTaggedEncodable];
#if !__has_feature(objc_arc)
        if (derSequenceEncodable) [derSequenceEncodable release]; derSequenceEncodable = nil;
        if (derTaggedEncodable) [derTaggedEncodable release]; derTaggedEncodable = nil;
#endif
    }
    DERSequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
    RevRepContent *content = [RevRepContent getInstance:sequence];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (encodable) [encodable release]; encodable = nil;
    if (sequence) [sequence release]; sequence = nil;
#endif
    
    return content;
}

@end
