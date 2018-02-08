//
//  AuthorityKeyIdentifier.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AuthorityKeyIdentifier.h"
#import "DERSequence.h"
#import "DERTaggedObject.h"
#import "DEROctetString.h"
#import "Extension.h"
#import "Sha1Digest.h"

@implementation AuthorityKeyIdentifier
@synthesize keyidentifier = _keyidentifier;
@synthesize certissuer = _certissuer;
@synthesize certserno = _certserno;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_keyidentifier) {
        [_keyidentifier release];
        _keyidentifier = nil;
    }
    if (_certissuer) {
        [_certissuer release];
        _certissuer = nil;
    }
    if (_certserno) {
        [_certserno release];
        _certserno = nil;
    }
    [super dealloc];
#endif
}

+ (AuthorityKeyIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AuthorityKeyIdentifier class]]) {
        return (AuthorityKeyIdentifier *)paramObject;
    }
    if (paramObject) {
        return [[[AuthorityKeyIdentifier alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (AuthorityKeyIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [AuthorityKeyIdentifier getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (AuthorityKeyIdentifier *)fromExtensions:(Extensions *)paramExtensions {
    return [AuthorityKeyIdentifier getInstance:[paramExtensions getExtensionParsedValue:[Extension authorityKeyIdentifier]]];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [DERTaggedObject getInstance:localObject];
            switch ([localASN1TaggedObject getTagNo]) {
                case 0:
                    self.keyidentifier = [ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                case 1:
                    self.certissuer = [GeneralNames getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                case 2:
                    self.certserno = [ASN1Integer getInstance:localASN1TaggedObject paramBoolean:NO];
                    break;
                default:
                    @throw [NSException exceptionWithName:NSGenericException reason:@"illegal tag" userInfo:nil];
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

- (instancetype)initParamSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo
{
    if (self = [super init]) {
        Sha1Digest *localSHA1Digest = [[Sha1Digest alloc] init];
        NSMutableData *arrayOfByte1 = [[NSMutableData alloc] initWithSize:[localSHA1Digest getDigestSize]];
        NSMutableData *arrayOfByte2 = [[paramSubjectPublicKeyInfo getPublicKeyData] getBytes];
        [localSHA1Digest blockUpdate:arrayOfByte2 withInOff:0 withLength:(int)[arrayOfByte2 length]];
        [localSHA1Digest doFinal:arrayOfByte1 withOutOff:0];
        ASN1OctetString *keyOctetString = [[DEROctetString alloc] initDEROctetString:arrayOfByte1];
        self.keyidentifier = keyOctetString;
#if !__has_feature(objc_arc)
    if (localSHA1Digest) [localSHA1Digest release]; localSHA1Digest = nil;
    if (arrayOfByte1) [arrayOfByte1 release]; arrayOfByte1 = nil;
    if (keyOctetString) [keyOctetString release]; keyOctetString = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamSubjectPublicKeyInfo:(SubjectPublicKeyInfo *)paramSubjectPublicKeyInfo paramGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        Sha1Digest *localSHA1Digest = [[Sha1Digest alloc] init];
        NSMutableData *arrayOfByte1 = [[NSMutableData alloc] initWithSize:[localSHA1Digest getDigestSize]];
        NSMutableData *arrayOfByte2 = [[paramSubjectPublicKeyInfo getPublicKeyData] getBytes];
        [localSHA1Digest blockUpdate:arrayOfByte2 withInOff:0 withLength:(int)[arrayOfByte2 length]];
        [localSHA1Digest doFinal:arrayOfByte1 withOutOff:0];
        ASN1OctetString *keyOctetString = [[DEROctetString alloc] initDEROctetString:arrayOfByte1];
        self.keyidentifier = keyOctetString;
        self.certissuer = [GeneralNames getInstance:[paramGeneralNames toASN1Primitive]];
        ASN1Integer *certsernoInteger = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.certserno = certsernoInteger;
#if !__has_feature(objc_arc)
        if (localSHA1Digest) [localSHA1Digest release]; localSHA1Digest = nil;
        if (arrayOfByte1) [arrayOfByte1 release]; arrayOfByte1 = nil;
        if (keyOctetString) [keyOctetString release]; keyOctetString = nil;
        if (certsernoInteger) [certsernoInteger release]; certsernoInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        [self initParamArrayOfByte:(NSMutableData *)nil paramGeneralNames:paramGeneralNames paramBigInteger:paramBigInteger];
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
        [self initParamArrayOfByte:paramArrayOfByte paramGeneralNames:nil paramBigInteger:nil];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte paramGeneralNames:(GeneralNames *)paramGeneralNames paramBigInteger:(BigInteger *)paramBigInteger
{
    if (self = [super init]) {
        DEROctetString *octetString = [[DEROctetString alloc] initDEROctetString:paramArrayOfByte];
        ASN1Integer *integer = [[ASN1Integer alloc] initBI:paramBigInteger];
        self.keyidentifier = (paramArrayOfByte != nil ? octetString : nil);
        self.certissuer = paramGeneralNames;
        self.certserno = (paramBigInteger != nil ? integer : nil);
#if !__has_feature(objc_arc)
    if (octetString) [octetString release]; octetString = nil;
    if (integer) [integer release]; integer = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableData *)getKeyIdentifier {
    if (self.keyidentifier) {
        return [self.keyidentifier getOctets];
    }
    return nil;
}

- (GeneralNames *)getAuthorityCertIssuer {
    return self.certissuer;
}

- (BigInteger *)getAuthorityCertSerialNumber {
    if (self.certserno) {
        return [self.certserno getValue];
    }
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.keyidentifier) {
        ASN1Encodable *keyidentifierEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:0 paramASN1Encodable:self.keyidentifier];
        [localASN1EncodableVector add:keyidentifierEncodable];
#if !__has_feature(objc_arc)
    if (keyidentifierEncodable) [keyidentifierEncodable release]; keyidentifierEncodable = nil;
#endif
    }
    if (self.certissuer) {
        ASN1Encodable *certissuerEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:1 paramASN1Encodable:self.certissuer];
        [localASN1EncodableVector add:certissuerEncodable];
#if !__has_feature(objc_arc)
        if (certissuerEncodable) [certissuerEncodable release]; certissuerEncodable = nil;
#endif
    }
    if (self.certserno) {
        ASN1Encodable *certsernoEncodable = [[DERTaggedObject alloc] initParamBoolean:NO paramInt:2 paramASN1Encodable:self.certserno];
        [localASN1EncodableVector add:certsernoEncodable];
#if !__has_feature(objc_arc)
        if (certsernoEncodable) [certsernoEncodable release]; certsernoEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"AuthorityKeyIdentifier: KeyID(%@)", [self.keyidentifier getOctets]];
}

@end
