//
//  ESSCertIDv2.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ESSCertIDv2.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "NISTObjectIdentifiers.h"
#import "DEROctetString.h"

@interface ESSCertIDv2 ()

@property (nonatomic, readwrite, retain) AlgorithmIdentifier *hashAlgorithm;
@property (nonatomic, readwrite, retain) NSMutableData *certHash;
@property (nonatomic, readwrite, retain) IssuerSerial *issuerSerial;

@end

@implementation ESSCertIDv2
@synthesize hashAlgorithm = _hashAlgorithm;
@synthesize certHash = _certHash;
@synthesize issuerSerial = _issuerSerial;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_hashAlgorithm) {
        [_hashAlgorithm release];
        _hashAlgorithm = nil;
    }
    if (_certHash) {
        [_certHash release];
        _certHash = nil;
    }
    if (_issuerSerial) {
        [_issuerSerial release];
        _issuerSerial = nil;
    }
    [super dealloc];
#endif
}

+ (AlgorithmIdentifier *)DEFAULT_ALG_ID {
    static AlgorithmIdentifier *_DEFAULT_ALG_ID = nil;
    @synchronized(self) {
        if (!_DEFAULT_ALG_ID) {
            _DEFAULT_ALG_ID = [[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[NISTObjectIdentifiers id_sha256]];
        }
    }
    return _DEFAULT_ALG_ID;
}

+ (ESSCertIDv2 *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ESSCertIDv2 class]]) {
        return (ESSCertIDv2 *)paramObject;
    }
    if (paramObject) {
        return [[[ESSCertIDv2 alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] > 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        int i = 0;
        if ([[paramASN1Sequence getObjectAt:0] isKindOfClass:[ASN1OctetString class]]) {
            self.hashAlgorithm = [ESSCertIDv2 DEFAULT_ALG_ID];
        }else {
            self.hashAlgorithm = [AlgorithmIdentifier getInstance:[[paramASN1Sequence getObjectAt:i++] toASN1Primitive]];
        }
        self.certHash = [[ASN1OctetString getInstance:[[paramASN1Sequence getObjectAt:i++] toASN1Primitive]] getOctets];
        if ([paramASN1Sequence size] > i) {
            self.issuerSerial = [IssuerSerial getInstance:[paramASN1Sequence getObjectAt:i]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        [self initParamAlgorithmIdentifier:nil paramArrayOfByte:paramArrayOfByte paramIssuerSerial:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        [self initParamAlgorithmIdentifier:paramAlgorithmIdentifier paramArrayOfByte:paramArrayOfByte paramIssuerSerial:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte paramIssuerSerial:(IssuerSerial *)paramIssuerSerial
{
    if (self = [super init]) {
        if (!paramAlgorithmIdentifier) {
            self.hashAlgorithm = [ESSCertIDv2 DEFAULT_ALG_ID];
        }else {
            self.hashAlgorithm = paramAlgorithmIdentifier;
        }
        self.certHash = paramArrayOfByte;
        self.issuerSerial = paramIssuerSerial;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getHashAlgorithm {
    return self.hashAlgorithm;
}

- (NSMutableData *)getCertHash {
    return self.certHash;
}

- (IssuerSerial *)getIssuerSerial {
    return self.issuerSerial;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (![self.hashAlgorithm isEqual:[ESSCertIDv2 DEFAULT_ALG_ID]]) {
        [localASN1EncodableVector add:self.hashAlgorithm];
    }
    DEROctetString *octetString = [[DEROctetString alloc] initDEROctetString:self.certHash];
    [localASN1EncodableVector add:[octetString toASN1Primitive]];
    if (self.issuerSerial) {
        [localASN1EncodableVector add:self.issuerSerial];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (octetString) [octetString release]; octetString = nil;
#endif
    return primitive;
}

@end
