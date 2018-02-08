//
//  CertificatePair.m
//  crypto
//
//  Created by JGehry on 7/8/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificatePair.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface CertificatePair ()

@property (nonatomic, readwrite, retain) Certificate *forward;
@property (nonatomic, readwrite, retain) Certificate *reverse;

@end

@implementation CertificatePair
@synthesize forward = _forward;
@synthesize reverse = _reverse;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_forward) {
        [_forward release];
        _forward = nil;
    }
    if (_reverse) {
        [_reverse release];
        _reverse = nil;
    }
    [super dealloc];
#endif
}

+ (CertificatePair *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[CertificatePair class]]) {
        return (CertificatePair *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1Sequence class]]) {
        return [[[CertificatePair alloc] initParamASN1Sequence:(ASN1Sequence *)paramObject] autorelease];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"illegal object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        if (([paramASN1Sequence size] != 1) && ([paramASN1Sequence size] != 2)) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad sequence size: %d", [paramASN1Sequence size]] userInfo:nil];
        }
        NSEnumerator *localEnumeration = [paramASN1Sequence getObjects];
        id localObject = nil;
        while (localObject = [localEnumeration nextObject]) {
            ASN1TaggedObject *localASN1TaggedObject = [ASN1TaggedObject getInstance:localObject];
            if ([localASN1TaggedObject getTagNo] == 0) {
                self.forward = [Certificate getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }else if ([localASN1TaggedObject getTagNo] == 1) {
                self.reverse = [Certificate getInstance:localASN1TaggedObject paramBoolean:TRUE];
            }else {
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Bad tag number: %d", [localASN1TaggedObject getTagNo]] userInfo:nil];
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

- (instancetype)initParamCertificate1:(Certificate *)paramCertificate1 paramCertificate2:(Certificate *)paramCertificate2
{
    if (self = [super init]) {
        self.forward = paramCertificate1;
        self.reverse = paramCertificate2;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (Certificate *)getForward {
    return self.forward;
}

- (Certificate *)getReverse {
    return self.reverse;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.forward) {
        ASN1Encodable *forwardEncodable = [[DERTaggedObject alloc] initParamInt:0 paramASN1Encodable:self.forward];
        [localASN1EncodableVector add:forwardEncodable];
#if !__has_feature(objc_arc)
        if (forwardEncodable) [forwardEncodable release]; forwardEncodable = nil;
#endif
    }
    if (self.reverse) {
        ASN1Encodable *reverseEncodable = [[DERTaggedObject alloc] initParamInt:1 paramASN1Encodable:self.reverse];
        [localASN1EncodableVector add:reverseEncodable];
#if !__has_feature(objc_arc)
        if (reverseEncodable) [reverseEncodable release]; reverseEncodable = nil;
#endif
    }
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
