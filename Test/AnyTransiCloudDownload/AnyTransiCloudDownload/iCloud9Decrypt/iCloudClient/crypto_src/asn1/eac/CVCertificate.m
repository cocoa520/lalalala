//
//  CVCertificate.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CVCertificate.h"
#import "ASN1ApplicationSpecific.h"
#import "DERApplicationSpecific.h"
#import "Arrays.h"
#import "ASN1EncodableVector.h"
#import "DEROctetString.h"
#import "CertificateHolderAuthorization.h"

@interface CVCertificate ()

@property (nonatomic, readwrite, retain) CertificateBody *certificateBody;
@property (nonatomic, readwrite, retain) NSMutableData *signature;
@property (nonatomic, assign) int valid;

@end

@implementation CVCertificate
@synthesize certificateBody = _certificateBody;
@synthesize signature = _signature;
@synthesize valid = _valid;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certificateBody) {
        [_certificateBody release];
        _certificateBody = nil;
    }
    if (_signature) {
        [_signature release];
        _signature = nil;
    }
   [super dealloc];
#endif
}

+ (int)bodyValid {
    static int _bodyValid = 0;
    @synchronized(self) {
        if (!_bodyValid) {
            _bodyValid = 1;
        }
    }
    return _bodyValid;
}

+ (int)signValid {
    static int _signValid = 0;
    @synchronized(self) {
        if (!_signValid) {
            _signValid = 2;
        }
    }
    return _signValid;
}

+ (CVCertificate *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CVCertificate class]]) {
        return (CVCertificate *)paramObject;
    }
    if (paramObject) {
        @try {
            return [[[CVCertificate alloc] initParamASN1ApplicationSpecific:[DERApplicationSpecific getInstance:paramObject]] autorelease];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unable to parse data: %@", exception.description] userInfo:nil];
        }
    }
}

- (void)setPrivateData:(ASN1ApplicationSpecific *)paramASN1ApplicationSpecific {
    self.valid = 0;
    if ([paramASN1ApplicationSpecific getApplicationTag] == 33) {
        ASN1InputStream *localASN1InputStream = [[ASN1InputStream alloc] initParamArrayOfByte:[paramASN1ApplicationSpecific getContents]];
        ASN1Primitive *localASN1Primitive;
        while ((localASN1Primitive = [localASN1InputStream readObject])) {
            if ([localASN1Primitive isKindOfClass:[DERApplicationSpecific class]]) {
                DERApplicationSpecific *localDERApplicationSpecific = (DERApplicationSpecific *)localASN1Primitive;
                switch ([localDERApplicationSpecific getApplicationTag]) {
                    case 78:
                        self.certificateBody = [CertificateBody getInstance:localDERApplicationSpecific];
                        self.valid |= [CVCertificate bodyValid];
                        break;
                    case 55:
                        self.signature = [localDERApplicationSpecific getContents];
                        self.valid |= [CVCertificate signValid];
                        break;
                    default:
                        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid tag, not an Iso7816CertificateStructure :%d", [localDERApplicationSpecific getApplicationTag]] userInfo:nil];
                        break;
                }
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:@"Invalid Object, not an Iso7816CertificateStructure" userInfo:nil];
            }
        }
#if !__has_feature(objc_arc)
    if (localASN1InputStream) [localASN1InputStream release]; localASN1InputStream = nil;
#endif
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"not a CARDHOLDER_CERTIFICATE :%d", [paramASN1ApplicationSpecific getApplicationTag]] userInfo:nil];
    }
    if (self.valid != ([CVCertificate bodyValid] | [CVCertificate signValid])) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"invalid CARDHOLDER_CERTIFICATE :%d", [paramASN1ApplicationSpecific getApplicationTag]] userInfo:nil];
    }
}

- (instancetype)initParamASN1InputStream:(ASN1InputStream *)paramASN1InputStream
{
    self = [super init];
    if (self) {
        [self initFrom:paramASN1InputStream];
    }
    return self;
}

- (void)initFrom:(ASN1InputStream *)paramASN1InputStream {
    ASN1Primitive *localASN1Primitive;
    while ((localASN1Primitive = [paramASN1InputStream readObject])) {
        if ([localASN1Primitive isKindOfClass:[DERApplicationSpecific class]]) {
            [self setPrivateData:(DERApplicationSpecific *)localASN1Primitive];
        }else {
            @throw [NSException exceptionWithName:NSGenericException reason:@"Invalid Input Stream for creating an Iso7816CertificateStructure" userInfo:nil];
        }
    }
}

- (instancetype)initParamASN1ApplicationSpecific:(ASN1ApplicationSpecific *)paramASN1ApplicationSpecific
{
    if (self = [super init]) {
        [self setPrivateData:paramASN1ApplicationSpecific];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertificateBody:(CertificateBody *)paramCertificateBody paramArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.certificateBody = paramCertificateBody;
        self.signature = paramArrayOfByte;
        self.valid |= [CVCertificate bodyValid];
        self.valid |= [CVCertificate signValid];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData *)getSignature {
    return [[Arrays cloneWithByteArray:self.signature] autorelease];
}

- (CertificateBody *)getBody {
    return self.certificateBody;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certificateBody];
    @try {
        ASN1Encodable *derOctetString = [[DEROctetString alloc] initDEROctetString:self.signature];
        ASN1Encodable *vectorEncodable = [[DERApplicationSpecific alloc] initParamBoolean:false paramInt:55 paramASN1Encodable:derOctetString];
        [localASN1EncodableVector add:vectorEncodable];
#if !__has_feature(objc_arc)
    if (derOctetString) [derOctetString release]; derOctetString = nil;
    if (vectorEncodable) [vectorEncodable release]; vectorEncodable = nil;
#endif
        
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"unable to convert signature!" userInfo:nil];
    }
    ASN1Primitive *primitive = [[[DERApplicationSpecific alloc] initParamInt:33 paramASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (ASN1ObjectIdentifier *)getHolderAuthorization {
    CertificateHolderAuthorization *localCertificateHolderAuthorization = [self.certificateBody getCertificateHolderAuthorization];
    return [localCertificateHolderAuthorization getOid];
}

- (PackedDate *)getEffectiveDate {
    return [self.certificateBody getCertificateEffectiveDate];
}

- (int)getCertificateType {
    return [self.certificateBody getCertificateType];
}

- (PackedDate *)getExpirationDate {
    return [self.certificateBody getCertificateExpirationDate];
}

- (int)getRole {
    CertificateHolderAuthorization *localCertificateHolderAuthorization = [self.certificateBody getCertificateHolderAuthorization];
    return [localCertificateHolderAuthorization getAccessRights];
}

- (CertificationAuthorityReference *)getAuthorityReference {
    return [self.certificateBody getCertificationAuthorityReference];
}

- (CertificateHolderReference *)getHolderReference {
    return [self.certificateBody getCertificateHolderReference];
}

- (int)getHolderAuthorizationRole {
    int i = [[self.certificateBody getCertificateHolderAuthorization] getAccessRights];
    return i & 0xC0;
}

- (Flags *)getHolderAuthorizationRights {
    return [[[Flags alloc] initParamInt:[[self.certificateBody getCertificateHolderAuthorization] getAccessRights] & 0x1F] autorelease];
}

@end
