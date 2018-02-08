//
//  CertRepMessage.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertRepMessage.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "CMPCertificate.h"
#import "CertResponse.h"
#import "DERTaggedObject.h"
#import "CategoryExtend.h"

@interface CertRepMessage ()

@property (nonatomic, readwrite, retain) ASN1Sequence *caPubs;
@property (nonatomic, readwrite, retain) ASN1Sequence *response;

@end

@implementation CertRepMessage
@synthesize caPubs = _caPubs;
@synthesize response = _response;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_caPubs) {
        [_caPubs release];
        _caPubs = nil;
    }
    if (_response) {
        [_response release];
        _response = nil;
    }
    [super dealloc];
#endif
}

+ (CertRepMessage *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertRepMessage class]]) {
        return (CertRepMessage *)paramObject;
    }
    if (paramObject) {
        return [[[CertRepMessage alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        int i = 0;
        if ([paramASN1Sequence size] > 1) {
            self.caPubs = [ASN1Sequence getInstance:(ASN1TaggedObject *)[paramASN1Sequence getObjectAt:i++] paramBoolean:TRUE];
        }
        self.response = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:i]];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfCMPCertificate:(NSMutableArray *)paramArrayOfCMPCertificate paramArrayOfCertResponse:(NSMutableArray *)paramArrayOfCertResponse
{
    if (self = [super init]) {
        if (!paramArrayOfCertResponse) {
            @throw [NSException exceptionWithName:NSGenericException reason:@"'response' cannot be null" userInfo:nil];
        }
        if (paramArrayOfCMPCertificate) {
            ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
            for (int i = 0; i < paramArrayOfCMPCertificate.count; i++) {
                [localASN1EncodableVector add:paramArrayOfCMPCertificate[i]];
            }
            ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
            self.caPubs = sequence;
#if !__has_feature(objc_arc)
            if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
            if (sequence) [sequence release]; sequence = nil;
#endif
        }
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < paramArrayOfCertResponse.count; i++) {
            [localASN1EncodableVector add:paramArrayOfCertResponse[i]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.response = sequence;
#if !__has_feature(objc_arc)
        if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
        if (sequence) [sequence release]; sequence = nil;
#endif
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getCaPubs {
    if (!self.caPubs) {
        return nil;
    }
    NSMutableArray *arrayOfCMPCertificate = [[[NSMutableArray alloc] initWithSize:[self.caPubs size]] autorelease];
    for (int i = 0; i != arrayOfCMPCertificate.count; i++) {
        arrayOfCMPCertificate[i] = [CMPCertificate getInstance:[self.caPubs getObjectAt:i]];
    }
    return arrayOfCMPCertificate;
}

- (NSMutableArray *)getResponse {
    NSMutableArray *arrayOfCertResponse = [[[NSMutableArray alloc] initWithSize:[self.response size]] autorelease];
    for (int i = 0; i != arrayOfCertResponse.count; i++) {
        arrayOfCertResponse[i] = [CertResponse getInstance:[self.response getObjectAt:i]];
    }
    return arrayOfCertResponse;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    if (self.caPubs) {
        ASN1Encodable *encodable = [[DERTaggedObject alloc] initParamBoolean:YES paramInt:1 paramASN1Encodable:self.caPubs];
        [localASN1EncodableVector add:encodable];
#if !__has_feature(objc_arc)
        if (encodable) [encodable release]; encodable = nil;
#endif
    }
    [localASN1EncodableVector add:self.response];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
