//
//  CscaMasterList.m
//  crypto
//
//  Created by JGehry on 6/23/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CscaMasterList.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "DERSet.h"
#import "Certificate.h"

@interface CscaMasterList ()

@property (nonatomic, readwrite, retain) ASN1Integer *version;
@property (nonatomic, readwrite, retain) NSMutableArray *certList;

@end

@implementation CscaMasterList
@synthesize version = _version;
@synthesize certList = _certList;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_version) {
        [_version release];
        _version = nil;
    }
    if (_certList) {
        [_certList release];
        _certList = nil;
    }
    [super dealloc];
#endif
}

+ (CscaMasterList *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CscaMasterList class]]) {
        return (CscaMasterList *)paramObject;
    }
    if (paramObject) {
        return [[[CscaMasterList alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (!paramASN1Sequence || ([paramASN1Sequence size] == 0)) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"null or empty sequence passed." userInfo:nil];
        }
        if ([paramASN1Sequence size] != 2) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Incorrect sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        self.version = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]];
        ASN1Set *localASN1Set = [ASN1Set getInstance:[paramASN1Sequence getObjectAt:1]];
        NSMutableArray *certListAry = [[NSMutableArray alloc] initWithSize:(int)[localASN1Set size]];
        self.certList = certListAry;
        for (int i = 0; i < [self.certList count]; i++) {
            self.certList[i] = [Certificate getInstance:[localASN1Set getObjectAt:i]];
        }
#if !__has_feature(objc_arc)
    if (certListAry) [certListAry release]; certListAry = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfCertificate:(NSMutableArray *)paramArrayOfCertificate
{
    if (self = [super init]) {
        self.certList = [self copyCertList:paramArrayOfCertificate];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getVersion {
    return [[self.version getValue] intValue];
}

- (NSMutableArray *)getCertStructs {
    return [self copyCertList:self.certList];
}

- (NSMutableArray *)copyCertList:(NSMutableArray *)paramArrayOfCertificate {
    NSMutableArray *arrayOfCertificate = [[[NSMutableArray alloc] initWithSize:(int)[paramArrayOfCertificate count]] autorelease];
    for (int i = 0; i != [arrayOfCertificate count]; i++) {
        arrayOfCertificate[i] = paramArrayOfCertificate[i];
    }
    return arrayOfCertificate;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector1 = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector1 add:self.version];
    ASN1EncodableVector *localASN1EncodableVector2 = [[ASN1EncodableVector alloc] init];
    for (int i = 0; i < [self.certList count]; i++) {
        [localASN1EncodableVector2 add:self.certList[i]];
    }
    ASN1Encodable *encodable = [[DERSet alloc] initDERParamASN1EncodableVector:localASN1EncodableVector2];
    [localASN1EncodableVector1 add:encodable];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector1] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector1) [localASN1EncodableVector1 release]; localASN1EncodableVector1 = nil;
    if (localASN1EncodableVector2) [localASN1EncodableVector2 release]; localASN1EncodableVector2 = nil;
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
