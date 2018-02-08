//
//  CVCertificateRequest.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CVCertificateRequest.h"
#import "ASN1ApplicationSpecific.h"
#import "DERApplicationSpecific.h"
#import "ASN1Sequence.h"
#import "DEROctetString.h"
#import "ASN1ParsingException.h"

@interface CVCertificateRequest ()

@property (nonatomic, readwrite, retain) CertificateBody *certificateBody;
@property (nonatomic, readwrite, retain) NSMutableData *innerSignature;
@property (nonatomic, readwrite, retain) NSMutableData *outerSignature;
@property (nonatomic, assign) int valid;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *signOid;
@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *keyOid;
@property (nonatomic, readwrite, retain) NSString *strCertificateHolderReference;
@property (nonatomic, readwrite, retain) NSMutableData *encodedAuthorityReference;
@property (nonatomic, assign) int ProfileId;
@property (nonatomic, readwrite, retain) NSMutableData *certificate;
@property (nonatomic, readwrite, retain) NSString *overSignerReference;
@property (nonatomic, readwrite, retain) NSMutableData *encoded;
@property (nonatomic, readwrite, retain) PublicKeyDataObject *iso7816PubKey;

@end

@implementation CVCertificateRequest
@synthesize certificateBody = _certificateBody;
@synthesize innerSignature = _innerSignature;
@synthesize outerSignature = _outerSignature;
@synthesize valid = _valid;
@synthesize signOid = _signOid;
@synthesize keyOid = _keyOid;
@synthesize strCertificateHolderReference = _strCertificateHolderReference;
@synthesize encodedAuthorityReference = _encodedAuthorityReference;
@synthesize ProfileId = _ProfileId;
@synthesize certificate = _certificate;
@synthesize overSignerReference = _overSignerReference;
@synthesize encoded = _encoded;
@synthesize iso7816PubKey = _iso7816PubKey;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_certificateBody) {
        [_certificateBody release];
        _certificateBody = nil;
    }
    if (_innerSignature) {
        [_innerSignature release];
        _innerSignature = nil;
    }
    if (_outerSignature) {
        [_outerSignature release];
        _outerSignature = nil;
    }
    if (_signOid) {
        [_signOid release];
        _signOid = nil;
    }
    if (_keyOid) {
        [_keyOid release];
        _keyOid = nil;
    }
    if (_strCertificateHolderReference) {
        [_strCertificateHolderReference release];
        _strCertificateHolderReference = nil;
    }
    if (_encodedAuthorityReference) {
        [_encodedAuthorityReference release];
        _encodedAuthorityReference = nil;
    }
    if (_certificate) {
        [_certificate release];
        _certificate = nil;
    }
    if (_overSignerReference) {
        [_overSignerReference release];
        _overSignerReference = nil;
    }
    if (_encoded) {
        [_encoded release];
        _encoded = nil;
    }
    if (_iso7816PubKey) {
        [_iso7816PubKey release];
        _iso7816PubKey = nil;
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

+ (NSMutableData *)ZeroArray {
    static NSMutableData *_ZeroArray = 0;
    @synchronized(self) {
        if (!_ZeroArray) {
            _ZeroArray = [[NSMutableData alloc] initWithSize:0];
        }
    }
    return _ZeroArray;
}

+ (CVCertificateRequest *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CVCertificateRequest class]]) {
        return (CVCertificateRequest *)paramObject;
    }
    if (paramObject) {
        @try {
            return [[[CVCertificateRequest alloc] initParamASN1ApplicationSpecific:[ASN1ApplicationSpecific getInstance:paramObject]] autorelease];
        }
        @catch (NSException *exception) {
            @throw [[ASN1ParsingException alloc] initParamString:[NSString stringWithFormat:@"unable to parse data: %@", exception.description] paramThrowable:exception];
        }
    }
    return nil;
}

- (instancetype)initParamASN1ApplicationSpecific:(ASN1ApplicationSpecific *)paramASN1ApplicationSpecific
{
    if (self = [super init]) {
        if ([paramASN1ApplicationSpecific getApplicationTag] == 103) {
            ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[paramASN1ApplicationSpecific getObject:16]];
            [self initCertBody:[ASN1ApplicationSpecific getInstance:[localASN1Sequence getObjectAt:0]]];
            self.outerSignature = [[ASN1ApplicationSpecific getInstance:[localASN1Sequence getObjectAt:(((int)[localASN1Sequence size]) - 1)]] getContents];
        }else {
            [self initCertBody:paramASN1ApplicationSpecific];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)initCertBody:(ASN1ApplicationSpecific *)paramASN1ApplicationSpecific {
    if ([paramASN1ApplicationSpecific getApplicationTag] == 33) {
        ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[paramASN1ApplicationSpecific getObject:16]];
        NSEnumerator *localEnumeration = [localASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1ApplicationSpecific *localASN1ApplicationSpecific = [ASN1ApplicationSpecific getInstance:localObject];
            switch ([localASN1ApplicationSpecific getApplicationTag]) {
                case 78:
                    self.certificateBody = [CertificateBody getInstance:localASN1ApplicationSpecific];
                    self.valid |= [CVCertificateRequest bodyValid];
                    break;
                case 55:
                    self.innerSignature = [localASN1ApplicationSpecific getContents];
                    self.valid |= [CVCertificateRequest signValid];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid tag, not an CV Certificate Request element:%d", [localASN1ApplicationSpecific getApplicationTag]] userInfo:nil];
                    break;
            }
        }
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"not a CARDHOLDER_CERTIFICATE in request:%d", [paramASN1ApplicationSpecific getApplicationTag]] userInfo:nil];
    }
}

- (CertificateBody *)getCertificateBody {
    return self.certificateBody;
}

- (PublicKeyDataObject *)getPublicKey {
    return [self.certificateBody getPublicKey];
}

- (NSMutableData *)getInnerSignature {
    return self.innerSignature;
}

- (NSMutableData *)getOuterSignature {
    return self.outerSignature;
}

- (BOOL)hasOuterSignature {
    return self.outerSignature != nil;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.certificateBody];
    @try {
        ASN1Encodable *derOctetString = [[DEROctetString alloc] initDEROctetString:self.innerSignature];
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

@end
