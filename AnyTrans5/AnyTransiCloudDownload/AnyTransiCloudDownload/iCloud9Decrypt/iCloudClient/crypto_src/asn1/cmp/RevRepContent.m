//
//  RevRepContent.m
//  crypto
//
//  Created by JGehry on 7/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "RevRepContent.h"
#import "PKIStatusInfo.h"
#import "CertIdCRMF.h"
#import "CertificateList.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface RevRepContent ()

@property (nonatomic, readwrite, retain) ASN1Sequence *status;
@property (nonatomic, readwrite, retain) ASN1Sequence *revCerts;
@property (nonatomic, readwrite, retain) ASN1Sequence *crls;

@end

@implementation RevRepContent
@synthesize status = _status;
@synthesize revCerts = _revCerts;
@synthesize crls = _crls;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_status) {
        [_status release];
        _status = nil;
    }
    if (_revCerts) {
        [_revCerts release];
        _revCerts = nil;
    }
    if (_crls) {
        [_crls release];
        _crls = nil;
    }
    [super dealloc];
#endif
}

+ (RevRepContent *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[RevRepContent class]]) {
        return (RevRepContent *)paramObject;
    }
    if (paramObject) {
        return [[[RevRepContent alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        self.status = [ASN1Sequence getInstance:[localEnumeration nextObject]];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localObject];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.revCerts = [ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }else {
                self.crls = [ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }
        }
    }
    return self;
}

- (NSMutableArray *)getStatus {
    NSMutableArray *arrayOfPKIStatusInfo = [[[NSMutableArray alloc] initWithSize:[self.status size]] autorelease];
    for (int i = 0; i != arrayOfPKIStatusInfo.count; i++) {
        arrayOfPKIStatusInfo[i] = [PKIStatusInfo getInstance:[self.status getObjectAt:i]];
    }
    return arrayOfPKIStatusInfo;
}

- (NSMutableArray *)getRevCerts {
    if (!self.revCerts) {
        return nil;
    }
    NSMutableArray *arrayOfCertId = [[[NSMutableArray alloc] initWithSize:[self.revCerts size]] autorelease];
    for (int i = 0; i != arrayOfCertId.count; i++) {
        arrayOfCertId[i] = [CertIdCRMF getInstance:[self.revCerts getObjectAt:i]];
    }
    return arrayOfCertId;
}

- (NSMutableArray *)getCrls {
    if (!self.crls) {
        return nil;
    }
    NSMutableArray *arrayOfCertificateList = [[[NSMutableArray alloc] initWithSize:[self.crls size]] autorelease];
    for (int i = 0; i != arrayOfCertificateList.count; i++) {
        arrayOfCertificateList[i] = [CertificateList getInstance:[self.crls getObjectAt:i]];
    }
    return arrayOfCertificateList;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.status];
    [self addOptional:localASN1EncodableVector paramInt:0 paramASN1Encodable:self.revCerts];
    [self addOptional:localASN1EncodableVector paramInt:1 paramASN1Encodable:self.crls];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

- (void)addOptional:(ASN1EncodableVector *)paramASN1EncodableVector paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable {
    if (paramASN1Encodable) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:TRUE paramInt:paramInt paramASN1Encodable:paramASN1Encodable];
        [paramASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
}

@end
