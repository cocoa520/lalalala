//
//  NamingAuthority.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "NamingAuthority.h"
#import "ASN1Sequence.h"
#import "DERIA5String.h"
#import "ASN1String.h"
#import "DERSequence.h"
#import "ISISMTTObjectIdentifiers.h"

@interface NamingAuthority ()

@property (nonatomic, readwrite, retain) ASN1ObjectIdentifier *namingAuthorityId;
@property (nonatomic, readwrite, retain) NSString *namingAuthorityUrl;
@property (nonatomic, readwrite, retain) DirectoryString *namingAuthorityText;

@end

@implementation NamingAuthority
@synthesize namingAuthorityId = _namingAuthorityId;
@synthesize namingAuthorityUrl = _namingAuthorityUrl;
@synthesize namingAuthorityText = _namingAuthorityText;

+ (ASN1ObjectIdentifier *)id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern {
    static ASN1ObjectIdentifier *_id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern = nil;
    @synchronized(self) {
        if (!_id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern) {
            _id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@.1", [ISISMTTObjectIdentifiers id_isismtt_at_namingAuthorities]]];
        }
    }
    return _id_isismtt_at_namingAuthorities_RechtWirtschaftSteuern;
}

+ (NamingAuthority *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[NamingAuthority class]]) {
        return (NamingAuthority *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[NamingAuthority alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (NamingAuthority *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [NamingAuthority getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

- (void)dealloc
{
    [self setNamingAuthorityId:nil];
    [self setNamingAuthorityUrl:nil];
    [self setNamingAuthorityText:nil];
    [super dealloc];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if ([paramASN1Sequence size] > 3) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        ASN1Encodable *localASN1Encodable = nil;
        if (localASN1Encodable = [localEnumeration nextObject]) {
            if ([localASN1Encodable isKindOfClass:[ASN1ObjectIdentifier class]]) {
                self.namingAuthorityId = (ASN1ObjectIdentifier *)localASN1Encodable;
            }else if ([localASN1Encodable isKindOfClass:[DERIA5String class]]) {
                self.namingAuthorityUrl = [[DERIA5String getInstance:localASN1Encodable] getString];
            }else if ([localASN1Encodable isKindOfClass:[ASN1String class]]) {
                self.namingAuthorityText = [DirectoryString getInstance:localASN1Encodable];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName(paramASN1Sequence)] userInfo:nil];
            }
        }
        if (localASN1Encodable = [localEnumeration nextObject]) {
            if ([localASN1Encodable isKindOfClass:[DERIA5String class]]) {
                self.namingAuthorityUrl = [[DERIA5String getInstance:localASN1Encodable] getString];
            }else if ([localASN1Encodable isKindOfClass:[ASN1String class]]) {
                self.namingAuthorityText = [DirectoryString getInstance:localASN1Encodable];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName(paramASN1Sequence)] userInfo:nil];
            }
        }
        if (localASN1Encodable = [localEnumeration nextObject]) {
            if ([localASN1Encodable isKindOfClass:[ASN1String class]]) {
                self.namingAuthorityText = [DirectoryString getInstance:localASN1Encodable];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad object encountered: %s", object_getClassName(paramASN1Sequence)] userInfo:nil];
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


- (instancetype)initParamASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString paramDirectoryString:(DirectoryString *)paramDirectoryString
{
    if (self = [super init]) {
        self.namingAuthorityId = paramASN1ObjectIdentifier;
        self.namingAuthorityUrl = paramString;
        self.namingAuthorityText = paramDirectoryString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (ASN1ObjectIdentifier *)getNamingAuthorityId {
    return self.namingAuthorityId;
}

- (DirectoryString *)getNamingAuthorityText {
    return self.namingAuthorityText;
}

- (NSString *)getNamingAuthorityUrl {
    return self.namingAuthorityUrl;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.namingAuthorityId) {
        [localASN1EncodableVector add:self.namingAuthorityId];
    }
    if (self.namingAuthorityUrl) {
        ASN1Encodable *encodable = [[DERIA5String alloc] initParamString:self.namingAuthorityUrl paramBoolean:YES];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    if (self.namingAuthorityText) {
        [localASN1EncodableVector add:self.namingAuthorityText];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
