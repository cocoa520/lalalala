//
//  ESSCertID.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ESSCertID.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DEROctetString.h"

@interface ESSCertID ()

@property (nonatomic, readwrite, retain) ASN1OctetString *certHash;
@property (nonatomic, readwrite, retain) IssuerSerial *issuerSerial;

@end

@implementation ESSCertID
@synthesize certHash = _certHash;
@synthesize issuerSerial = _issuerSerial;

- (void)dealloc
{
#if !__has_feature(objc_arc)
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

+ (ESSCertID *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[ESSCertID class]]) {
        return (ESSCertID *)paramObject;
    }
    if (paramObject) {
        return [[[ESSCertID alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] < 1) || ([paramASN1Sequence size] > 2)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.certHash = [ASN1OctetString getInstance:[paramASN1Sequence getObjectAt:0]];
        if ([paramASN1Sequence size] > 1) {
            self.issuerSerial = [IssuerSerial getInstance:[paramASN1Sequence getObjectAt:1]];
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
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.certHash = octetString;
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

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramIssuerSerial:(IssuerSerial *)paramIssuerSerial
{
    if (self = [super init]) {
        ASN1OctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        self.certHash = octetString;
        self.issuerSerial = paramIssuerSerial;
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

- (NSMutableData *)getCertHash {
    return [self.certHash getOctets];
}

- (IssuerSerial *)getIssuerSerial {
    return self.issuerSerial;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certHash];
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
