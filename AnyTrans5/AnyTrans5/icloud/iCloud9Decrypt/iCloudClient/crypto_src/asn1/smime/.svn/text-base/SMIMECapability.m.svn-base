//
//  SMIMECapability.m
//  crypto
//
//  Created by JGehry on 6/29/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SMIMECapability.h"
#import "PKCSObjectIdentifiers.h"
#import "NISTObjectIdentifiers.h"
#import "ASN1EncodableVector.h"
#import "DERSequence.h"

@interface SMIMECapability ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *capabilityID;
@property (nonatomic, readwrite, retain) ASN1Encodable *parameters;

@end

@implementation SMIMECapability
@synthesize capabilityID = _capabilityID;
@synthesize parameters = _parameters;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_capabilityID) {
        [_capabilityID release];
        _capabilityID = nil;
    }
    if (_parameters) {
        [_parameters release];
        _parameters = nil;
    }
    [super dealloc];
#endif
}

+ (ASN1ObjectIdentifier *)preferSignedData {
    static ASN1ObjectIdentifier *_preferSignedData = nil;
    @synchronized(self) {
        if (!_preferSignedData) {
            _preferSignedData = [[PKCSObjectIdentifiers preferSignedData] retain];
        }
    }
    return _preferSignedData;
}

+ (ASN1ObjectIdentifier *)canNotDecryptAny {
    static ASN1ObjectIdentifier *_canNotDecryptAny = nil;
    @synchronized(self) {
        if (!_canNotDecryptAny) {
            _canNotDecryptAny = [[PKCSObjectIdentifiers canNotDecryptAny] retain];
        }
    }
    return _canNotDecryptAny;
}

+ (ASN1ObjectIdentifier *)sMIMECapabilitiesVersions {
    static ASN1ObjectIdentifier *_sMIMECapabilitiesVersions = nil;
    @synchronized(self) {
        if (!_sMIMECapabilitiesVersions) {
            _sMIMECapabilitiesVersions = [[PKCSObjectIdentifiers sMIMECapabilitiesVersions] retain];
        }
    }
    return _sMIMECapabilitiesVersions;
}

+ (ASN1ObjectIdentifier *)dES_CBC {
    static ASN1ObjectIdentifier *_dES_CBC = nil;
    @synchronized(self) {
        if (!_dES_CBC) {
            _dES_CBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.14.3.2.7"];
        }
    }
    return _dES_CBC;
}

+ (ASN1ObjectIdentifier *)dES_EDE3_CBC {
    static ASN1ObjectIdentifier *_dES_EDE3_CBC = nil;
    @synchronized(self) {
        if (!_dES_EDE3_CBC) {
            _dES_EDE3_CBC = [[PKCSObjectIdentifiers des_EDE3_CBC] retain];
        }
    }
    return _dES_EDE3_CBC;
}

+ (ASN1ObjectIdentifier *)rC2_CBC {
    static ASN1ObjectIdentifier *_rC2_CBC = nil;
    @synchronized(self) {
        if (!_rC2_CBC) {
            _rC2_CBC = [[PKCSObjectIdentifiers RC2_CBC] retain];
        }
    }
    return _rC2_CBC;
}

+ (ASN1ObjectIdentifier *)aES128_CBC {
    static ASN1ObjectIdentifier *_aES128_CBC = nil;
    @synchronized(self) {
        if (!_aES128_CBC) {
            _aES128_CBC = [[NISTObjectIdentifiers id_aes128_CBC] retain];
        }
    }
    return _aES128_CBC;
}

+ (ASN1ObjectIdentifier *)aES192_CBC {
    static ASN1ObjectIdentifier *_aES192_CBC = nil;
    @synchronized(self) {
        if (!_aES192_CBC) {
            _aES192_CBC = [[NISTObjectIdentifiers id_aes192_CBC] retain];
        }
    }
    return _aES192_CBC;
}

+ (ASN1ObjectIdentifier *)aES256_CBC {
    static ASN1ObjectIdentifier *_aES256_CBC = nil;
    @synchronized(self) {
        if (!_aES256_CBC) {
            _aES256_CBC = [[NISTObjectIdentifiers id_aes256_CBC] retain];
        }
    }
    return _aES256_CBC;
}

+ (SMIMECapability *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[SMIMECapability class]]) {
        return (SMIMECapability *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[SMIMECapability alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"Invalid SMIMECapability" userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.capabilityID = (ASN1ObjectIdentifier *)[paramASN1Sequence getObjectAt:0];
        if ([paramASN1Sequence size] > 1) {
            self.parameters = (ASN1Primitive *)[paramASN1Sequence getObjectAt:1];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.capabilityID = paramASN1ObjectIdentifier;
        self.parameters = paramASN1Encodable;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getCapabilityID {
    return self.capabilityID;
}

- (ASN1Encodable *)getParameters {
    return self.parameters;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.capabilityID];
    if (self.parameters) {
        [localASN1EncodableVector add:self.parameters];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
