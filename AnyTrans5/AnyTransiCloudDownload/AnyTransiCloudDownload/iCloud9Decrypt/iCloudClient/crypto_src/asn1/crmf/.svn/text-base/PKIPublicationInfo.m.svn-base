//
//  PKIPublicationInfo.m
//  crypto
//
//  Created by JGehry on 6/30/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "PKIPublicationInfo.h"
#import "SinglePubInfo.h"
#import "DERSequence.h"
#import "CategoryExtend.h"

@interface PKIPublicationInfo ()

@property (nonatomic, readwrite, retain) ASN1Integer *action;
@property (nonatomic, readwrite, retain) ASN1Sequence *pubInfos;

@end

@implementation PKIPublicationInfo
@synthesize action = _action;
@synthesize pubInfos = _pubInfos;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_action) {
        [_action release];
        _action = nil;
    }
    if (_pubInfos) {
        [_pubInfos release];
        _pubInfos = nil;
    }
   [super dealloc];
#endif
}

+ (PKIPublicationInfo *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[PKIPublicationInfo class]]) {
        return (PKIPublicationInfo *)paramObject;
    }
    if (paramObject) {
        return [[[PKIPublicationInfo alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    self = [super init];
    if (self) {
        self.action = [ASN1Integer getInstance:[paramASN1Sequence getObjectAt:0]];
        self.pubInfos = [ASN1Sequence getInstance:[paramASN1Sequence getObjectAt:1]];
    }
    return self;
}

- (ASN1Integer *)getAction {
    return self.action;
}

- (NSMutableArray *)getPubInfos {
    if (!self.pubInfos) {
        return nil;
    }
    NSMutableArray *arrayOfSinglePubInfo = [[[NSMutableArray alloc] initWithSize:[self.pubInfos size]] autorelease];
    for (int i = 0; i != arrayOfSinglePubInfo.count; i++) {
        arrayOfSinglePubInfo[i] = [SinglePubInfo getInstance:[self.pubInfos getObjectAt:i]];
    }
    return arrayOfSinglePubInfo;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1EncodableVector *localASN1EncodableVector = [[ASN1EncodableVector alloc] init];
    [localASN1EncodableVector add:self.action];
    [localASN1EncodableVector add:self.pubInfos];
    ASN1Primitive *primitive = [[[DERSequence alloc] initDERParamASN1EncodableVector:localASN1EncodableVector] autorelease];
#if !__has_feature(objc_arc)
    if (localASN1EncodableVector) [localASN1EncodableVector release]; localASN1EncodableVector = nil;
#endif
    return primitive;
}

@end
