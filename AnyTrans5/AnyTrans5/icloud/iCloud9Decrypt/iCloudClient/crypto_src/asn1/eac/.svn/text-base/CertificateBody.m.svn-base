//
//  CertificateBody.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificateBody.h"
#import "EACTags.h"
#import "DEROctetString.h"

@interface CertificateBody ()

@property (nonatomic, readwrite, retain) DERApplicationSpecific *certificateProfileIdentifier;
@property (nonatomic, readwrite, retain) DERApplicationSpecific *certificationAuthorityReference;
@property (nonatomic, readwrite, retain) PublicKeyDataObject *publicKey;
@property (nonatomic, readwrite, retain) DERApplicationSpecific *certificateHolderReference;
@property (nonatomic, readwrite, retain) CertificateHolderAuthorization *certificateHolderAuthorization;
@property (nonatomic, readwrite, retain) DERApplicationSpecific *certificateEffectiveDate;
@property (nonatomic, readwrite, retain) DERApplicationSpecific *certificateExpirationDate;
@property (nonatomic, assign) int certificateType;

@end

@implementation CertificateBody
@synthesize seq = _seq;
@synthesize certificateProfileIdentifier = _certificateProfileIdentifier;
@synthesize certificationAuthorityReference = _certificationAuthorityReference;
@synthesize publicKey = _publicKey;
@synthesize certificateHolderReference = _certificateHolderReference;
@synthesize certificateHolderAuthorization = _certificateHolderAuthorization;
@synthesize certificateEffectiveDate = _certificateEffectiveDate;
@synthesize certificateExpirationDate = _certificateExpirationDate;
@synthesize certificateType = _certificateType;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_seq) {
        [_seq release];
        _seq = nil;
    }
    if (_certificateProfileIdentifier) {
        [_certificateProfileIdentifier release];
        _certificateProfileIdentifier = nil;
    }
    if (_certificationAuthorityReference) {
        [_certificationAuthorityReference release];
        _certificationAuthorityReference = nil;
    }
    if (_publicKey) {
        [_publicKey release];
        _publicKey = nil;
    }
    if (_certificateHolderReference) {
        [_certificateHolderReference release];
        _certificateHolderReference = nil;
    }
    if (_certificateHolderAuthorization) {
        [_certificateHolderAuthorization release];
        _certificateHolderAuthorization = nil;
    }
    if (_certificateEffectiveDate) {
        [_certificateEffectiveDate release];
        _certificateEffectiveDate = nil;
    }
    if (_certificateExpirationDate) {
        [_certificateExpirationDate release];
        _certificateExpirationDate = nil;
    }
    [super dealloc];
#endif
}

+ (int)CPI {
    static int _CPI = 0;
    @synchronized(self) {
        if (!_CPI) {
            _CPI = 1;
        }
    }
    return _CPI;
}

+ (int)CAR {
    static int _CAR = 0;
    @synchronized(self) {
        if (!_CAR) {
            _CAR = 2;
        }
    }
    return _CAR;
}

+ (int)PK {
    static int _PK = 0;
    @synchronized(self) {
        if (!_PK) {
            _PK = 4;
        }
    }
    return _PK;
}

+ (int)CHR {
    static int _CHR = 0;
    @synchronized(self) {
        if (!_CHR) {
            _CHR = 8;
        }
    }
    return _CHR;
}

+ (int)CHA {
    static int _CHA = 0;
    @synchronized(self) {
        if (!_CHA) {
            _CHA = 16;
        }
    }
    return _CHA;
}

+ (int)CEfD {
    static int _CEfD = 0;
    @synchronized(self) {
        if (!_CEfD) {
            _CEfD = 32;
        }
    }
    return _CEfD;
}

+ (int)CExD {
    static int _CExD = 0;
    @synchronized(self) {
        if (!_CExD) {
            _CExD = 64;
        }
    }
    return _CExD;
}

+ (int)profileType {
    static int _profileType = 0;
    @synchronized(self) {
        if (!_profileType) {
            _profileType = 127;
        }
    }
    return _profileType;
}

+ (int)requestType {
    static int _requestType = 0;
    @synchronized(self) {
        if (!_requestType) {
            _requestType = 13;
        }
    }
    return _requestType;
}

+ (CertificateBody *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertificateBody class]]) {
        return (CertificateBody *)paramObject;
    }
    if (paramObject) {
        return [[[CertificateBody alloc] initParamASN1ApplicationSpecific:[ASN1ApplicationSpecific getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (void)setIso7816CertificateBody:(ASN1ApplicationSpecific *)paramASN1ApplicationSpecific {
    NSMutableData *arrayOfByte;
    if ([paramASN1ApplicationSpecific getApplicationTag] == 78) {
        arrayOfByte = [paramASN1ApplicationSpecific getContents];
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Bad tag : not an iso7816 CERTIFICATE_CONTENT_TEMPLATE" userInfo:nil];
    }
    ASN1InputStream *localASN1InputStream = [[ASN1InputStream alloc] initParamArrayOfByte:arrayOfByte];
    ASN1Primitive *localASN1Primitive;
    while ((localASN1Primitive = [localASN1InputStream readObject])) {
        DERApplicationSpecific *localDERApplicationSpecific;
        if ([localASN1Primitive isKindOfClass:[DERApplicationSpecific class]]) {
            localDERApplicationSpecific = (DERApplicationSpecific *)localASN1Primitive;
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Not a valid iso7816 content : not a DERApplicationSpecific Object :%d%s", [EACTags encodeTag:paramASN1ApplicationSpecific], object_getClassName(localASN1Primitive)] userInfo:nil];
        }
        switch ([localDERApplicationSpecific getApplicationTag]) {
            case 41:
                [self setCertificateProfileIdentifier:localDERApplicationSpecific];
                break;
            case 2:
                [self setCertificationAuthorityReference:localDERApplicationSpecific];
                break;
            case 73:
                [self setPublicKey:[PublicKeyDataObject getInstance:[localDERApplicationSpecific getObject:16]]];
                break;
            case 32:
                [self setCertificateHolderReference:localDERApplicationSpecific];
                break;
            case 76: {
                CertificateHolderAuthorization *authorization = [[CertificateHolderAuthorization alloc] initParamDERApplicationSpecific:localDERApplicationSpecific];
                [self setCertificateHolderAuthorization:authorization];
#if !__has_feature(objc_arc)
    if (authorization) [authorization release]; authorization = nil;
#endif
            }
                break;
            case 37:
                [self setCertificateEffectiveDate:localDERApplicationSpecific];
                break;
            case 36:
                [self setCertificateExpirationDate:localDERApplicationSpecific];
                break;
            default:
                self.certificateType = 0;
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Not a valid iso7816 DERApplicationSpecific tag %d", [localDERApplicationSpecific getApplicationTag]] userInfo:nil];
                break;
        }
    }
#if !__has_feature(objc_arc)
    if (localASN1InputStream) [localASN1InputStream release]; localASN1InputStream = nil;
#endif
}

- (instancetype)initParamDERApplicationSpecific:(DERApplicationSpecific *)paramDERApplicationSpecific paramCertificationAuthorityReference:(CertificationAuthorityReference *)paramCertificationAuthorityReference paramPublicKeyDataObject:(PublicKeyDataObject *)paramPublicKeyDataObject paramCertificateHolderReference:(CertificateHolderReference *)paramCertificateHolderReference paramCertificateHolderAuthorization:(CertificateHolderAuthorization *)paramCertificateHolderAuthorization paramPackedDate1:(PackedDate *)paramPackedDate1 paramPackedDate2:(PackedDate *)paramPackedDate2
{
    if (self = [super init]) {
        [self setCertificateProfileIdentifier:paramDERApplicationSpecific];
        DERApplicationSpecific *application1 = [[DERApplicationSpecific alloc] initParamInt:2 paramArrayOfByte:[paramCertificationAuthorityReference getEncoded]];
        [self setCertificationAuthorityReference:application1];
        [self setPublicKey:paramPublicKeyDataObject];
        DERApplicationSpecific *application2 = [[DERApplicationSpecific alloc] initParamInt:32 paramArrayOfByte:[paramCertificateHolderReference getEncoded]];
        [self setCertificateHolderReference:application2];
        [self setCertificateHolderAuthorization:paramCertificateHolderAuthorization];
        @try {
            ASN1Encodable *octetString1 = [[DEROctetString alloc] initDEROctetString:[paramPackedDate1 getEncoding]];
            DERApplicationSpecific *application3 = [[DERApplicationSpecific alloc] initParamBoolean:false paramInt:37 paramASN1Encodable:octetString1];
            [self setCertificateEffectiveDate:application3];
            ASN1OctetString *octetString2 = [[DEROctetString alloc] initDEROctetString:[paramPackedDate2 getEncoding]];
            DERApplicationSpecific *application4 = [[DERApplicationSpecific alloc] initParamBoolean:false paramInt:36 paramASN1Encodable:octetString2];
            [self setCertificateExpirationDate:application4];
#if !__has_feature(objc_arc)
    if (octetString1) [octetString1 release]; octetString1 = nil;
    if (application3) [application3 release]; application3 = nil;
    if (octetString2) [octetString2 release]; octetString2 = nil;
    if (application4) [application4 release]; application4 = nil;
#endif
            
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unable to encode dates: %@", exception.description] userInfo:nil];
        }
#if !__has_feature(objc_arc)
    if (application1) [application1 release]; application1 = nil;
    if (application2) [application2 release]; application2 = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1ApplicationSpecific:(ASN1ApplicationSpecific *)paramASN1ApplicationSpecific
{
    if (self = [super init]) {
        [self setIso7816CertificateBody:paramASN1ApplicationSpecific];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1Primitive *)profileToASN1Object {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certificateProfileIdentifier];
    [localASN1EncodableVector add:self.certificationAuthorityReference];
    ASN1Encodable *applicationEncodable = [[DERApplicationSpecific alloc] initParamBoolean:false paramInt:73 paramASN1Encodable:self.publicKey];
    [localASN1EncodableVector add:applicationEncodable];
    [localASN1EncodableVector add:self.certificateHolderReference];
    [localASN1EncodableVector add:self.certificateHolderAuthorization];
    [localASN1EncodableVector add:self.certificateEffectiveDate];
    [localASN1EncodableVector add:self.certificateExpirationDate];
    ASN1Primitive *primitive = [[[DERApplicationSpecific alloc] initParamInt:78 paramASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
    if (applicationEncodable) [applicationEncodable release]; applicationEncodable = nil;
#endif
    return primitive;
}

- (void)setCertificateProfileIdentifier:(DERApplicationSpecific *)certificateProfileIdentifier {
    if ([certificateProfileIdentifier getApplicationTag] == 41) {
        self.certificateProfileIdentifier = certificateProfileIdentifier;
        self.certificateType |= 0x1;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Not an Iso7816Tags.INTERCHANGE_PROFILE tag :%d", [EACTags encodeTag:certificateProfileIdentifier]] userInfo:nil];
    }
}

- (void)setCertificateHolderReference:(DERApplicationSpecific *)certificateHolderReference {
    if ([certificateHolderReference getApplicationTag] == 32) {
        self.certificateHolderReference = certificateHolderReference;
        self.certificateType |= 0x8;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Not an Iso7816Tags.CARDHOLDER_NAME tag" userInfo:nil];
    }
}

- (void)setCertificationAuthorityReference:(DERApplicationSpecific *)certificationAuthorityReference {
    if ([certificationAuthorityReference getApplicationTag] == 2) {
        self.certificationAuthorityReference = certificationAuthorityReference;
        self.certificateType |= 0x2;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Not an Iso7816Tags.ISSUER_IDENTIFICATION_NUMBER tag" userInfo:nil];
    }
}

- (void)setPublicKey:(PublicKeyDataObject *)publicKey {
    self.publicKey = [PublicKeyDataObject getInstance:publicKey];
    self.certificateType |= 0x4;
}

- (ASN1Primitive *)requestToASN1Object {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certificateProfileIdentifier];
    ASN1Encodable *applicationEncodable = [[DERApplicationSpecific alloc] initParamBoolean:false paramInt:73 paramASN1Encodable:self.publicKey];
    [localASN1EncodableVector add:applicationEncodable];
    [localASN1EncodableVector add:self.certificateHolderReference];
    ASN1Primitive *primitive = [[[DERApplicationSpecific alloc] initParamInt:78 paramASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (applicationEncodable) [applicationEncodable release]; applicationEncodable = nil;
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (ASN1Primitive *)toASN1Primitive {
    @try {
        if (self.certificateType == 127) {
            return [self profileToASN1Object];
        }
        if (self.certificateType == 13) {
            return [self requestToASN1Object];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}

- (int)getCertificateType {
    return self.certificateType;
}

- (PackedDate *)getCertificateEffectiveDate {
    if ((self.certificateType & 0x20) == 32) {
        return [[[PackedDate alloc] initParamArrayOfByte:[self.certificateEffectiveDate getContents]] autorelease];
    }
    return nil;
}

- (PackedDate *)getCertificateExpirationDate {
    if ((self.certificateType & 0x40) == 64) {
        return [[[PackedDate alloc] initParamArrayOfByte:[self.certificateExpirationDate getContents]] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"certificate Expiration Date not set" userInfo:nil];
}

- (void)setCertificateEffectiveDate:(DERApplicationSpecific *)certificateEffectiveDate {
    if ([certificateEffectiveDate getApplicationTag] == 37) {
        self.certificateEffectiveDate = certificateEffectiveDate;
        self.certificateType |= 0x20;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Not an Iso7816Tags.APPLICATION_EFFECTIVE_DATE tag :%d", [EACTags encodeTag:certificateEffectiveDate]] userInfo:nil];
    }
}

- (void)setCertificateExpirationDate:(DERApplicationSpecific *)certificateExpirationDate {
    if ([certificateExpirationDate getApplicationTag] == 36) {
        self.certificateExpirationDate = certificateExpirationDate;
        self.certificateType |= 0x40;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Not an Iso7816Tags.APPLICATION_EXPIRATION_DATE tag" userInfo:nil];
    }
}

- (CertificateHolderAuthorization *)getCertificateHolderAuthorization {
    if ((self.certificateType & 0x10) == 16) {
        return self.certificateHolderAuthorization;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"Certificate Holder Authorisation not set" userInfo:nil];
}

- (void)setCertificateHolderAuthorization:(CertificateHolderAuthorization *)certificateHolderAuthorization {
    self.certificateHolderAuthorization = certificateHolderAuthorization;
    self.certificateType |= 0x10;
}

- (CertificateHolderReference *)getCertificateHolderReference {
    return [[[CertificateHolderReference alloc] initParamArrayOfByte:[self.certificateHolderReference getContents]] autorelease];
}

- (DERApplicationSpecific *)getCertificateProfileIdentifier {
    return self.certificateProfileIdentifier;
}

- (CertificationAuthorityReference *)getCertificationAuthorityReference {
    if ((self.certificateType & 0x2) == 2) {
        return [[[CertificationAuthorityReference alloc] initParamArrayOfByte:[self.certificationAuthorityReference getContents]] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"Certification authority reference not set" userInfo:nil];
}

- (PublicKeyDataObject *)getPublicKey {
    return self.publicKey;
}

@end
