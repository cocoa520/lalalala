//
//  SMIMECapabilities.m
//  crypto
//
//  Created by JGehry on 6/21/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SMIMECapabilities.h"
#import "Attribute.h"
#import "PKCSObjectIdentifiers.h"
#import "NISTObjectIdentifiers.h"
#import "SMIMECapability.h"

@interface SMIMECapabilities ()

@property (nonatomic, readwrite, retain) ASN1Sequence *capabilities;

@end

@implementation SMIMECapabilities
@synthesize capabilities = _capabilities;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_capabilities) {
        [_capabilities release];
        _capabilities = nil;
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

+ (ASN1ObjectIdentifier *)sMIMECapabilitesVersions {
    static ASN1ObjectIdentifier *_sMIMECapabilitesVersions = nil;
    @synchronized(self) {
        if (!_sMIMECapabilitesVersions) {
            _sMIMECapabilitesVersions = [[PKCSObjectIdentifiers sMIMECapabilitiesVersions] retain];
        }
    }
    return _sMIMECapabilitesVersions;
}

+ (ASN1ObjectIdentifier *)aes256_CBC {
    static ASN1ObjectIdentifier *_aes256_CBC = nil;
    @synchronized(self) {
        if (!_aes256_CBC) {
            _aes256_CBC = [[NISTObjectIdentifiers id_aes256_CBC] retain];
        }
    }
    return _aes256_CBC;
}

+ (ASN1ObjectIdentifier *)aes192_CBC {
    static ASN1ObjectIdentifier *_aes192_CBC = nil;
    @synchronized(self) {
        if (!_aes192_CBC) {
            _aes192_CBC = [[NISTObjectIdentifiers id_aes192_CBC] retain];
        }
    }
    return _aes192_CBC;
}

+ (ASN1ObjectIdentifier *)aes128_CBC {
    static ASN1ObjectIdentifier *_aes128_CBC = nil;
    @synchronized(self) {
        if (!_aes128_CBC) {
            _aes128_CBC = [[NISTObjectIdentifiers id_aes128_CBC] retain];
        }
    }
    return _aes128_CBC;
}

+ (ASN1ObjectIdentifier *)idea_CBC {
    static ASN1ObjectIdentifier *_idea_CBC = nil;
    @synchronized(self) {
        if (!_idea_CBC) {
            _idea_CBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.188.7.1.1.2"];
        }
    }
    return _idea_CBC;
}

+ (ASN1ObjectIdentifier *)cast5_CBC {
    static ASN1ObjectIdentifier *_cast5_CBC = nil;
    @synchronized(self) {
        if (!_cast5_CBC) {
            _cast5_CBC = [[ASN1ObjectIdentifier alloc] initParamString:@"1.3.6.1.4.1.188.7.1.1.2"];
        }
    }
    return _cast5_CBC;
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

+ (SMIMECapabilities *)getInstance:(id)paramObject {
    if (paramObject || [paramObject isKindOfClass:[SMIMECapabilities class]]) {
        return (SMIMECapabilities *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[SMIMECapabilities alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    if ([paramObject isKindOfClass:[Attribute class]]) {
        return [[[SMIMECapabilities alloc] initParamASN1Sequence:(ASN1Sequence *)[[((Attribute *)paramObject) getAttrValues] getObjectAt:0]] autorelease];
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown object in factory: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.capabilities = paramASN1Sequence;
    }
    return self;
}

- (NSMutableArray *)getCapabilities:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    NSEnumerator *localEnumeration = [self.capabilities getObjects];
    NSMutableArray *localVector = [[[NSMutableArray alloc] init] autorelease];
    SMIMECapability *localSMIMECapability;
    if (!paramASN1ObjectIdentifier) {
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            localSMIMECapability = [SMIMECapability getInstance:localObject];
            [localVector addObject:localSMIMECapability];
        }
    }
    id localObject = nil;
    while (localObject = [localEnumeration nextObject]) {
        localSMIMECapability = [SMIMECapability getInstance:localObject];
        if ([paramASN1ObjectIdentifier isEqual:[localSMIMECapability getCapabilityID]]) {
            [localVector addObject:localSMIMECapability];
        }
    }
    return localVector;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.capabilities;
}

@end
