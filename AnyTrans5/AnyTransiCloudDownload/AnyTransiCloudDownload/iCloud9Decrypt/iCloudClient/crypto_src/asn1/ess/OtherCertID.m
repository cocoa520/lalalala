//
//  OtherCertID.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "OtherCertID.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "ASN1OctetString.h"
#import "DigestInfo.h"
#import "OIWObjectIdentifier.h"

@interface OtherCertID ()

@property (nonatomic, readwrite, retain) ASN1Encodable *otherCertHash;
@property (nonatomic, readwrite, retain) IssuerSerial *issuerSerial;

@end

@implementation OtherCertID
@synthesize otherCertHash = _otherCertHash;
@synthesize issuerSerial = _issuerSerial;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_otherCertHash) {
        [_otherCertHash release];
        _otherCertHash = nil;
    }
    if (_issuerSerial) {
        [_issuerSerial release];
        _issuerSerial = nil;
    }
    [super dealloc];
#endif
}

+ (OtherCertID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[OtherCertID class]]) {
        return (OtherCertID *)paramObject;
    }
    if (paramObject) {
        return [[[OtherCertID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        if ([[[paramASN1Sequence getObjectAt:0] toASN1Primitive] isKindOfClass:[ASN1OctetString class]]) {
            self.otherCertHash = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:0]];
        }else {
            self.otherCertHash = [DigestInfo getInstance:[paramASN1Sequence getObjectAt:0]];
        }
        if ([paramASN1Sequence size] > 1) {
            self.issuerSerial = [IssuerSerial getInstance:[paramASN1Sequence getObjectAt:1]];
        }
    }
    return self;
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    self = [super init];
    if (self) {
        ASN1Encodable *encodable = [[DigestInfo alloc] initParamAlgorithmIdentifier:paramAlgorithmIdentifier paramArrayOfByte:paramArrayOfByte];
        self.otherCertHash = encodable;
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    }
    return self;
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfByte:(NSMutableData *)paramArrayOfByte paramIssuerSerial:(IssuerSerial *)paramIssuerSerial
{
    if (self = [super init]) {
        ASN1Encodable *codable = [[DigestInfo alloc] initParamAlgorithmIdentifier:paramAlgorithmIdentifier paramArrayOfByte:paramArrayOfByte];
        self.otherCertHash = codable;
        self.issuerSerial = paramIssuerSerial;
#if !__has_feature(objc_arc)
    if (codable) [codable release]; codable = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (AlgorithmIdentifier *)getAlgorithmHash {
    if ([[self.otherCertHash toASN1Primitive] isKindOfClass:[ASN1OctetString class]]) {
        return [[[AlgorithmIdentifier alloc] initParamASN1ObjectIdentifier:[OIWObjectIdentifier idSHA1]] autorelease];
    }
    return [[DigestInfo getInstance:self.otherCertHash] getAlgorithmId];
}

- (NSMutableData *)getCertHash {
    if ([[self.otherCertHash toASN1Primitive] isKindOfClass:[ASN1OctetString class]]) {
        return [((ASN1OctetString *)[self.otherCertHash toASN1Primitive]) getOctets];
    }
    return [[DigestInfo getInstance:self.otherCertHash] getDigest];
}

- (IssuerSerial *)getIssuerSerial {
    return self.issuerSerial;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.otherCertHash];
    if (self.issuerSerial) {
        [localASN1EncodableVector add:self.issuerSerial];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
