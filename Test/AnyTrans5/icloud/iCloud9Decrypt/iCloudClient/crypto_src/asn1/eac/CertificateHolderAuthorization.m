//
//  CertificateHolderAuthorization.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificateHolderAuthorization.h"
#import "EACObjectIdentifiers.h"
#import "ASN1InputStream.h"
#import "EACTags.h"
#import "BigInteger.h"

@implementation CertificateHolderAuthorization
@synthesize oid = _oid;
@synthesize accessRights = _accessRights;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_oid) {
        [_oid release];
        _oid = nil;
    }
    if (_accessRights) {
        [_accessRights release];
        _accessRights = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)id_role_EAC {
    static ASN1ObjectIdentifier *_id_role_EAC = nil;
    @synchronized(self) {
        if (!_id_role_EAC) {
            ASN1ObjectIdentifier *branchObj = nil;
            @autoreleasepool {
                branchObj = [[[EACObjectIdentifiers bsi_de] branch:@"3.1.2.1"] retain];
            }
            _id_role_EAC = [branchObj retain];
        }
    }
    return _id_role_EAC;
}

+ (int)CVCA {
    static int _CVCA = 0;
    @synchronized(self) {
        if (!_CVCA) {
            _CVCA = 192;
        }
    }
    return _CVCA;
}

+ (int)DV_DOMESTIC {
    static int _DV_DOMESTIC = 0;
    @synchronized(self) {
        if (!_DV_DOMESTIC) {
            _DV_DOMESTIC = 128;
        }
    }
    return _DV_DOMESTIC;
}

+ (int)DV_FOREIGN {
    static int _DV_FOREIGN = 0;
    @synchronized(self) {
        if (!_DV_FOREIGN) {
            _DV_FOREIGN = 64;
        }
    }
    return _DV_FOREIGN;
}

+ (int)IS {
    static int _IS = 0;
    @synchronized(self) {
        if (!_IS) {
            _IS = 0;
        }
    }
    return _IS;
}

+ (int)RADG4 {
    static int _RADG4 = 0;
    @synchronized(self) {
        if (!_RADG4) {
            _RADG4 = 2;
        }
    }
    return _RADG4;
}

+ (int)RADG3 {
    static int _RADG3 = 0;
    @synchronized(self) {
        if (!_RADG3) {
            _RADG3 = 1;
        }
    }
    return _RADG3;
}

+ (NSMutableDictionary *)RightsDecodeMap {
    static NSMutableDictionary *_RightsDecodeMap = nil;
    @synchronized(self) {
        if (!_RightsDecodeMap) {
            _RightsDecodeMap = [[NSMutableDictionary alloc] init];
        }
    }
    return _RightsDecodeMap;
}

+ (BidirectionalMap *)AuthorizationRole {
    static BidirectionalMap *_AuthorizationRole = nil;
    @synchronized(self) {
        if (!_AuthorizationRole) {
            _AuthorizationRole = [[BidirectionalMap alloc] init];
        }
    }
    return _AuthorizationRole;
}

+ (NSMutableDictionary *)ReverseMap {
    static NSMutableDictionary *_ReverseMap = nil;
    @synchronized(self) {
        if (!_ReverseMap) {
            _ReverseMap = [[NSMutableDictionary alloc] init];
        }
    }
    return _ReverseMap;
}

+ (NSString *)getRoleDescription:(int)paramInt {
    return [[CertificateHolderAuthorization AuthorizationRole] objectForKey:[BigInteger valueOf:paramInt]];
}

+ (int)getFlag:(NSString *)paramString {
    BigInteger *localInteger = (BigInteger *)[[CertificateHolderAuthorization AuthorizationRole] getReverse:(NSString *)paramString];
    if (!localInteger) {
        @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Unknown value %@", paramString] userInfo:nil];
    }
    return [localInteger intValue];
}

- (void)setPrivateData:(ASN1InputStream *)paramASN1InputStream {
    ASN1Primitive *localASN1Primitive = [paramASN1InputStream readObject];
    if ([localASN1Primitive isKindOfClass:[ASN1ObjectIdentifier class]]) {
        self.oid = (ASN1ObjectIdentifier *)localASN1Primitive;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"no Oid in CerticateHolderAuthorization" userInfo:nil];
    }
    localASN1Primitive = [paramASN1InputStream readObject];
    if ([localASN1Primitive isKindOfClass:[DERApplicationSpecific class]]) {
        self.accessRights = (DERApplicationSpecific *)localASN1Primitive;
    }else {
        @throw [NSException exceptionWithName:NSGenericException reason:@"No access rights in CerticateHolderAuthorization" userInfo:nil];
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramInt:(int)paramInt
{
    if (self = [super init]) {
        [self setOid:paramASN1ObjectIdentifier];
        [self setIsAccessRights:(Byte)paramInt];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamDERApplicationSpecific:(DERApplicationSpecific *)paramDERApplicationSpecific
{
    if (self = [super init]) {
        if ([paramDERApplicationSpecific getApplicationTag] == 76) {
            ASN1InputStream *inputStream = [[ASN1InputStream alloc] initParamArrayOfByte:[paramDERApplicationSpecific getContents]];
            [self setPrivateData:inputStream];
#if !__has_feature(objc_arc)
    if (inputStream) [inputStream release]; inputStream = nil;
#endif
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getAccessRights {
    return (((Byte *)[self.accessRights getContents])[0] & 0xFF);
}

- (void)setIsAccessRights:(Byte)paramByte {
    NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:1];
    ((Byte *)[arrayOfByte bytes])[0] = paramByte;
    DERApplicationSpecific *application = [[DERApplicationSpecific alloc] initParamInt:[EACTags getTag:33] paramArrayOfByte:arrayOfByte];
    self.accessRights = application;
#if !__has_feature(objc_arc)
    if (application) [application release]; application = nil;
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
#endif
}

- (ASN1ObjectIdentifier *)getOid {
    return self.oid;
}

- (void)setOid:(ASN1ObjectIdentifier *)oid {
    self.oid = oid;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.oid];
    [localASN1EncodableVector add:self.accessRights];
    ASN1Primitive *primitive = [[[DERApplicationSpecific alloc] initParamInt:76 paramASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

+ (void)load {
    [[CertificateHolderAuthorization RightsDecodeMap] setObject:@"RADG4" forKey:[BigInteger Two]];
    [[CertificateHolderAuthorization RightsDecodeMap] setObject:@"RADG3" forKey:[BigInteger One]];
    [[CertificateHolderAuthorization RightsDecodeMap] setObject:@"CVCA" forKey:[BigInteger valueOf:192]];
    [[CertificateHolderAuthorization RightsDecodeMap] setObject:@"DV_DOMESTIC" forKey:[BigInteger valueOf:128]];
    [[CertificateHolderAuthorization RightsDecodeMap] setObject:@"DV_FOREIGN" forKey:[BigInteger valueOf:64]];
    [[CertificateHolderAuthorization RightsDecodeMap] setObject:@"IS" forKey:[BigInteger Zero]];
}

@end
