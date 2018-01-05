//
//  LDSSecurityObject.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "LDSSecurityObject.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DataGroupHash.h"

@interface LDSSecurityObject ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) AlgorithmIdentifier *digestAlgorithmIdentifier;
@property (nonatomic, readwrite, retain) NSMutableArray *datagroupHash;
@property (nonatomic, readwrite, retain) LDSVersionInfo *versionInfo;

@end

@implementation LDSSecurityObject
@synthesize version = _version;
@synthesize digestAlgorithmIdentifier = _digestAlgorithmIdentifier;
@synthesize datagroupHash = _datagroupHash;
@synthesize versionInfo = _versionInfo;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_digestAlgorithmIdentifier) {
        [_digestAlgorithmIdentifier release];
        _digestAlgorithmIdentifier = nil;
    }
    if (_datagroupHash) {
        [_datagroupHash release];
        _datagroupHash = nil;
    }
    if (_versionInfo) {
        [_versionInfo release];
        _versionInfo = nil;
    }
    [super dealloc];
#endif
}

+ (LDSSecurityObject *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[LDSSecurityObject class]]) {
        return (LDSSecurityObject *)paramObject;
    }
    if (paramObject) {
        return [[[LDSSecurityObject alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (!paramASN1Sequence || ([paramASN1Sequence size] == 0)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"null or empty sequence passed." userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.version = [ASN1Integer getInstance:[localEnumeration nextObject]];
        self.digestAlgorithmIdentifier = [AlgorithmIdentifier getInstance:[localEnumeration nextObject]];
        ASN1Sequence *localASN1Sequence = [ASN1Sequence getInstance:[localEnumeration nextObject]];
        if ([[self.version getValue] intValue] == 1) {
            self.versionInfo = [LDSVersionInfo getInstance:[localEnumeration nextObject]];
        }
        [self checkDatagroupHashSeqSize:(int)[localASN1Sequence size]];
        self.datagroupHash = [[[NSMutableArray alloc] initWithSize:(int)[localASN1Sequence size]] autorelease];
        for (int i = 0; i < [localASN1Sequence size]; i++) {
            self.datagroupHash[i] = [DataGroupHash getInstance:[localASN1Sequence getObjectAt:i]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfDataGroupHash:(NSMutableArray *)paramArrayOfDataGroupHash
{
    if (self = [super init]) {
        ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:0];
        self.version = versionInteger;
        self.digestAlgorithmIdentifier = paramAlgorithmIdentifier;
        self.datagroupHash = paramArrayOfDataGroupHash;
        [self checkDatagroupHashSeqSize:(int)paramArrayOfDataGroupHash.count];
#if !__has_feature(objc_arc)
        if (versionInteger) [versionInteger release]; versionInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamAlgorithmIdentifier:(AlgorithmIdentifier *)paramAlgorithmIdentifier paramArrayOfDataGroupHash:(NSMutableArray *)paramArrayOfDataGroupHash paramLDSVersionInfo:(LDSVersionInfo *)paramLDSVersionInfo
{
    if (self = [super init]) {
        ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:0];
        self.version = versionInteger;
        self.digestAlgorithmIdentifier = paramAlgorithmIdentifier;
        self.datagroupHash = paramArrayOfDataGroupHash;
        self.versionInfo = paramLDSVersionInfo;
        [self checkDatagroupHashSeqSize:(int)paramArrayOfDataGroupHash.count];
#if !__has_feature(objc_arc)
        if (versionInteger) [versionInteger release]; versionInteger = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)checkDatagroupHashSeqSize:(int)paramInt {
    if ((paramInt < 2) || (paramInt > 16)) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"wrong size in DataGroupHashValues : not in (2..16)" userInfo:nil];
    }
}

- (int)getVersion {
    return [[self.version getValue] intValue];
}

- (AlgorithmIdentifier *)getDigestAlgorithmIdentifier {
    return self.digestAlgorithmIdentifier;
}

- (NSMutableArray *)getDatagroupHash {
    return self.datagroupHash;
}

- (LDSVersionInfo *)getVersionInfo {
    return self.versionInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector1 add:self.version];
    [localASN1EncodableVector1 add:self.digestAlgorithmIdentifier];
    ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
    for (int i = 0; i < [self.datagroupHash count]; i++) {
        [localASN1EncodableVector2 add:self.datagroupHash[i]];
    }
    ASN1Encodable *encodable = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
    [localASN1EncodableVector1 add:encodable];
    if (self.versionInfo) {
        [localASN1EncodableVector1 add:self.versionInfo];
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
