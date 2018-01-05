//
//  CertReqMessages.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertReqMessages.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface CertReqMessages ()

@property (nonatomic, readwrite, retain) ASN1Sequence *content;

@end

@implementation CertReqMessages
@synthesize content = _content;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_content) {
        [_content release];
        _content = nil;
    }
    [super dealloc];
#endif
}

+ (CertReqMessages *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[CertReqMessages class]]) {
        return (CertReqMessages *)paramObject;
    }
    if (paramObject) {
        return [[[CertReqMessages alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.content = paramASN1Sequence;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamCertReqMsg:(CertReqMsg *)paramCertReqMsg
{
    if (self = [super init]) {
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1Encodable:paramCertReqMsg];
        self.content = sequence;
#if !__has_feature(objc_arc)
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

- (instancetype)initParamArrayOfCertReqMsg:(NSMutableArray *)paramArrayOfCertReqMsg
{
    if (self = [super init]) {
        ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
        for (int i = 0; i < paramArrayOfCertReqMsg.count; i++) {
            [localASN1EncodableVector add:paramArrayOfCertReqMsg[i]];
        }
        ASN1Sequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector];
        self.content = sequence;
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

- (NSMutableArray *)toCertReqMsgArray {
    NSMutableArray *arrayOfCertReqMsg = [[[NSMutableArray alloc] initWithSize:[self.content size]] autorelease];
    for (int i = 0; i != arrayOfCertReqMsg.count; i++) {
        arrayOfCertReqMsg[i] = [CertReqMsg getInstance:[self.content getObjectAt:i]];
    }
    return arrayOfCertReqMsg;
}

- (ASN1Primitive *)toASN1Primitive {
    return self.content;
}

@end
